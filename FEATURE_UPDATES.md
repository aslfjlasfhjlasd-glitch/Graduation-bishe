# 志愿活动管理系统 - 功能更新文档

## 📋 版本信息
- **更新日期**: 2025-12-10
- **版本号**: v1.1.0
- **更新类型**: 功能增强 + Bug修复
- **项目名称**: 大学志愿活动管理系统
- **技术栈**: Spring Boot + Vue 3 + MySQL

---

## 📖 目录
1. [Bug修复](#一bug修复)
2. [新增功能](#二新增功能)
3. [数据库变更](#三数据库变更)
4. [技术要点](#四技术要点)
5. [代码详解](#五代码详解)
6. [测试建议](#六测试建议)
7. [部署说明](#七部署说明)
8. [已知问题](#八已知问题)
9. [后续计划](#九后续计划)
10. [文件清单](#十文件清单)

---

## 一、Bug修复

### 1.1 活动结束时间显示问题

#### 问题描述
活动详情页面无法显示活动结束时间（`HD_JSSJ`字段），导致用户无法了解活动的完整时间信息。

#### 问题原因
后端SQL查询使用了`CONCAT`函数将多个时间字段合并为单一字符串，前端无法正确解析和显示各个独立的时间字段。

#### 修复方案

**后端修改 - DashboardMapper.java**
```java
// 修改前：使用CONCAT合并时间
"CONCAT(BM_KSSJ, ' 至 ', BM_JSSJ) AS bmsj, " +
"CONCAT(HD_KSSJ, ' 至 ', HD_JSSJ) AS hdsj"

// 修改后：返回独立的时间字段
"BM_KSSJ AS bmkssj, " +
"BM_JSSJ AS bmjssj, " +
"HD_KSSJ AS hdkssj, " +
"HD_JSSJ AS hdjssj, " +
"ZM_RS AS zyrs, " +
"YBM_RS AS ybmrs"  // 同时添加已报名人数字段
```

**前端修改 - ActivityHall.vue**
```javascript
// 使用独立字段进行时间显示
<p class="text-sm text-gray-600 mb-2">
  <span class="font-medium">报名时间：</span>
  {{ formatDateTime(selectedActivity.bmkssj) }} 至 
  {{ formatDateTime(selectedActivity.bmjssj) }}
</p>
<p class="text-sm text-gray-600 mb-2">
  <span class="font-medium">活动时间：</span>
  {{ formatDateTime(selectedActivity.hdkssj) }} 至 
  {{ formatDateTime(selectedActivity.hdjssj) }}
</p>
```

#### 影响范围
- **后端文件**: `backend/src/main/java/com/university/volunteer/mapper/DashboardMapper.java`
- **前端文件**: `frontend/src/views/student/components/ActivityHall.vue`
- **数据库表**: `t_zyhd` (志愿活动信息表)

#### 验证方法
1. 登录学生账号
2. 进入活动大厅
3. 点击任意活动的"查看详情"按钮
4. 确认活动详情弹窗中显示完整的报名时间和活动时间

---

### 1.2 活动状态实时同步问题

#### 问题描述
活动详情页面的状态显示为静态，不会随着时间推移自动更新。例如，当报名时间结束后，状态仍然显示为"报名中"，需要手动刷新页面才能看到最新状态。

#### 问题原因
前端直接使用后端返回的静态`HD_ZT`字段，没有基于当前时间进行动态计算。

#### 修复方案

**前端实现 - ActivityHall.vue**

1. **添加状态计算函数**
```javascript
// 基于当前时间动态计算活动状态
const computeStatus = (activity) => {
  const now = new Date();
  const bmkssj = new Date(activity.bmkssj);
  const bmjssj = new Date(activity.bmjssj);
  const hdkssj = new Date(activity.hdkssj);
  const hdjssj = new Date(activity.hdjssj);

  if (now < bmkssj) {
    return '报名未开始';
  } else if (now >= bmkssj && now <= bmjssj) {
    return '报名中';
  } else if (now > bmjssj && now < hdkssj) {
    return '报名已结束';
  } else if (now >= hdkssj && now <= hdjssj) {
    return '进行中';
  } else {
    return '已结束';
  }
};
```

2. **添加定时刷新机制**
```javascript
// 每60秒自动刷新状态
let statusInterval = null;

onMounted(() => {
  fetchActivities();
  
  // 设置定时器
  statusInterval = setInterval(() => {
    if (activities.value.length > 0) {
      // 触发响应式更新
      activities.value = [...activities.value];
    }
  }, 60000); // 60秒
});

// 组件卸载时清理定时器
onUnmounted(() => {
  if (statusInterval) {
    clearInterval(statusInterval);
  }
});
```

3. **优化字体渲染**
```css
/* 解决文字模糊问题 */
* {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

#### 技术亮点
- ✅ 实时性：每60秒自动更新，无需手动刷新
- ✅ 准确性：基于客户端时间精确计算
- ✅ 性能优化：使用定时器而非轮询API
- ✅ 资源管理：组件卸载时自动清理定时器

#### 影响范围
- **前端文件**: `frontend/src/views/student/components/ActivityHall.vue`

#### 验证方法
1. 找一个即将结束报名的活动
2. 打开活动详情页面
3. 等待报名时间结束
4. 观察状态是否在60秒内自动更新为"报名已结束"

---

### 1.3 Toast通知位置问题

#### 问题描述
Toast通知使用`absolute`定位固定在页面顶部，当用户向下滚动页面后，通知会移出视野范围，用户无法看到操作反馈。

#### 问题原因
CSS定位方式不当，`absolute`定位相对于最近的定位祖先元素，而非视口。

#### 修复方案

**前端修改 - ActivityHall.vue**
```css
/* 修改前 */
.toast {
  position: absolute;
  top: 20px;
  right: 20px;
}

/* 修改后 */
.toast {
  position: fixed;      /* 相对于视口定位 */
  top: 20px;
  right: 20px;
  z-index: 100;        /* 确保在最上层 */
}
```

#### 技术说明
- **fixed定位**: 相对于浏览器视口定位，不受页面滚动影响
- **z-index**: 设置为100确保Toast始终显示在其他元素之上
- **响应式**: 在移动端自动调整位置

#### 影响范围
- **前端文件**: `frontend/src/views/student/components/ActivityHall.vue`

#### 验证方法
1. 登录系统并进入活动大厅
2. 向下滚动页面
3. 点击报名按钮触发Toast通知
4. 确认通知始终显示在视口右上角

---

### 1.4 报名人数同步问题 ⭐

#### 问题描述
学生成功报名活动后，活动列表中的"已报名人数"（`YBM_RS`字段）没有实时更新，仍然显示旧的数值。只有重新加载页面或重启后端服务才能看到正确的人数。

#### 问题根源分析

**数据库设计问题**
```sql
-- t_zyhd表（活动表）
HD_BH int NOT NULL  -- 活动编号，整数类型

-- t_zyhdbmb表（报名表）
HD_BH varchar(10)   -- 活动编号，字符串类型
```

**问题影响**:
- 类型不匹配导致JOIN查询失败
- COUNT统计无法正确关联两表数据
- 报名记录插入成功，但统计数据不更新

#### 完整修复方案

##### 1. 后端Mapper层修改

**StudentActivityMapper.java - 添加更新方法**
```java
package com.university.volunteer.mapper;

import org.apache.ibatis.annotations.*;

@Mapper
public interface StudentActivityMapper {
    
    // 原有的报名方法
    @Insert("INSERT INTO t_zyhdbmb (XS_XH, XS_XM, SS_XY, HD_BH, HD_MC, HD_SJ, HD_DD, BM_ZT) " +
            "VALUES (#{xsXh}, #{xsXm}, #{ssXy}, #{hdBh}, #{hdMc}, #{hdSj}, #{hdDd}, '未审核')")
    int insertRegistration(@Param("xsXh") String xsXh, 
                          @Param("xsXm") String xsXm,
                          @Param("ssXy") String ssXy, 
                          @Param("hdBh") Integer hdBh,
                          @Param("hdMc") String hdMc, 
                          @Param("hdSj") String hdSj,
                          @Param("hdDd") String hdDd);
    
    // 新增：更新活动已报名人数（关键修复）
    @Update("UPDATE t_zyhd SET YBM_RS = (" +
            "SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId}" +
            ") WHERE HD_BH = #{activityId}")
    int updateRegisteredCount(@Param("activityId") Integer activityId);
    
    // 新增：删除报名记录（用于取消报名）
    @Delete("DELETE FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int deleteRegistration(@Param("studentId") String studentId, 
                          @Param("activityId") Integer activityId);
}
```

**技术要点**:
- 使用子查询实时统计报名人数
- 不依赖字段类型，通过值匹配进行关联
- 支持事务回滚，保证数据一致性

##### 2. Service层修改

**StudentActivityService.java - 报名流程优化**
```java
package com.university.volunteer.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudentActivityService {
    
    @Autowired
    private StudentActivityMapper studentActivityMapper;
    
    @Transactional  // 确保事务一致性
    public void registerActivity(String studentId, Integer activityId, 
                                 String studentName, String academy,
                                 String activityName, String activityTime, 
                                 String activityLocation) {
        // 1. 插入报名记录
        int result = studentActivityMapper.insertRegistration(
            studentId, studentName, academy, activityId,
            activityName, activityTime, activityLocation
        );
        
        if (result > 0) {
            // 2. 立即更新活动已报名人数（关键步骤）
            studentActivityMapper.updateRegisteredCount(activityId);
        }
    }
    
    @Transactional
    public void cancelRegistration(String studentId, Integer activityId) {
        // 1. 删除报名记录
        int result = studentActivityMapper.deleteRegistration(studentId, activityId);
        
        if (result > 0) {
            // 2. 更新活动已报名人数
            studentActivityMapper.updateRegisteredCount(activityId);
        }
    }
}
```

**事务管理**:
- `@Transactional`注解确保操作原子性
- 报名失败时自动回滚，不会出现数据不一致
- 支持并发操作，避免人数统计错误

##### 3. DashboardMapper修改

**DashboardMapper.java - 查询返回YBM_RS字段**
```java
@Select("SELECT HD_BH AS hdbh, HD_MC AS hdmc, " +
        "BM_KSSJ AS bmkssj, BM_JSSJ AS bmjssj, " +
        "HD_KSSJ AS hdkssj, HD_JSSJ AS hdjssj, " +
        "HD_NR AS hdnr, HD_DD AS hddd, " +
        "ZM_RS AS zmrs, " +
        "YBM_RS AS ybmrs, " +  // 添加已报名人数字段
        "HD_BQ AS hdbq, JN_YQ AS jnyq, " +
        "ZY_XZ AS zyxz, HDXQ AS hdxq, " +
        "HD_BZ AS hdbz, HD_FQ_DW AS hdfqdw, " +
        "HD_ZT AS hdzt " +
        "FROM t_zyhd " +
        "WHERE HD_ZT IN ('报名中', '进行中', '未开始')")
List<VolunteerActivity> findAvailableActivities();
```

##### 4. 前端显示优化

**ActivityHall.vue - 显示格式改进**
```vue
<template>
  <div class="activity-card">
    <!-- 活动信息 -->
    <h3>{{ activity.hdmc }}</h3>
    
    <!-- 报名人数显示（新格式） -->
    <p class="text-sm text-gray-600">
      <span class="font-medium">报名人数：</span>
      <span class="text-blue-600 font-semibold">
        {{ activity.ybmrs || 0 }}
      </span>
      <span class="text-gray-500"> / {{ activity.zmrs }}</span>
    </p>
    
    <!-- 报名按钮（根据人数动态禁用） -->
    <button 
      :disabled="activity.ybmrs >= activity.zmrs"
      @click="registerActivity(activity)">
      {{ activity.ybmrs >= activity.zmrs ? '名额已满' : '立即报名' }}
    </button>
  </div>
</template>

<script setup>
// 报名成功后刷新列表
const registerActivity = async (activity) => {
  try {
    await api.register(activity.hdbh);
    showToast('报名成功！', 'success');
    
    // 刷新活动列表，显示最新人数
    await fetchActivities();
  } catch (error) {
    showToast('报名失败：' + error.message, 'error');
  }
};
</script>
```

##### 5. 数据库修复脚本

**update_ybm_rs.sql - 修复历史数据**
```sql
-- 修复所有活动的已报名人数统计
UPDATE t_zyhd 
SET YBM_RS = (
    SELECT COUNT(*) 
    FROM t_zyhdbmb 
    WHERE CAST(t_zyhdbmb.HD_BH AS UNSIGNED) = t_zyhd.HD_BH
);

-- 验证修复结果
SELECT 
    t.HD_BH AS '活动编号',
    t.HD_MC AS '活动名称',
    t.YBM_RS AS '已报名人数',
    t.ZM_RS AS '招募人数',
    (SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = t.HD_BH) AS '实际报名人数'
FROM t_zyhd t
WHERE t.YBM_RS != (SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = t.HD_BH);
```

**执行步骤**:
1. 备份数据库：`mysqldump -u root -p universityta > backup.sql`
2. 执行修复脚本：在Navicat或MySQL客户端中运行
3. 验证结果：检查是否有不一致的记录
4. 重启后端服务

#### 技术难点解决

**1. 类型转换问题**
```sql
-- 错误写法（类型不匹配）
WHERE t_zyhdbmb.HD_BH = t_zyhd.HD_BH

-- 正确写法（使用CAST转换）
WHERE CAST(t_zyhdbmb.HD_BH AS UNSIGNED) = t_zyhd.HD_BH
```

**2. 并发安全问题**
```java
// 使用数据库事务保证并发安全
@Transactional(isolation = Isolation.READ_COMMITTED)
public void registerActivity(...) {
    // 操作代码
}
```

**3. 性能优化**
```java
// 使用子查询而非JOIN，提高查询效率
UPDATE t_zyhd SET YBM_RS = (SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId})
```

#### 影响范围
- **后端文件**:
  - `StudentActivityMapper.java` (新增2个方法)
  - `StudentActivityService.java` (修改报名流程)
  - `DashboardMapper.java` (添加YBM_RS字段)
- **前端文件**:
  - `ActivityHall.vue` (优化显示格式)
- **数据库**:
  - `update_ybm_rs.sql` (修复历史数据)

#### 验证方法
1. 执行SQL修复脚本
2. 重启后端服务
3. 登录学生账号
4. 报名一个活动
5. 立即刷新活动列表
6. 确认已报名人数增加1
7. 取消报名
8. 确认已报名人数减少1

---

## 二、新增功能

### 2.1 个性化搜索功能 🔍

#### 功能概述
在活动大厅页面添加强大的多维度搜索和筛选功能，帮助学生快速找到感兴趣的志愿活动。

#### 功能特性详解

##### 1. 关键词搜索
**支持字段**:
- 活动名称（`HD_MC`）
- 活动地点（`HD_DD`）
- 活动内容（`HD_NR`）
- 发起单位（`HD_FQ_DW`）

**搜索逻辑**:
```javascript
const filteredActivities = computed(() => {
  return activities.value.filter(activity => {
    // 关键词匹配（不区分大小写）
    const keyword = searchKeyword.value.toLowerCase();
    const matchKeyword = !keyword || 
      activity.hdmc.toLowerCase().includes(keyword) ||
      activity.hddd.toLowerCase().includes(keyword) ||
      (activity.hdnr && activity.hdnr.toLowerCase().includes(keyword)) ||
      (activity.hdfqdw && activity.hdfqdw.toLowerCase().includes(keyword));
    
    return matchKeyword && matchStatus && matchLocation;
  });
});
```

##### 2. 活动状态筛选
**状态选项**:
- 全部状态
- 报名未开始
- 报名中（推荐）
- 进行中
- 已结束

**实现代码**:
```vue
<template>
  <div class="filter-group">
    <label class="filter-label">活动状态</label>
    <select v-model="selectedStatus" class="filter-select">
      <option value="">全部状态</option>
      <option value="报名未开始">报名未开始</option>
      <option value="报名中">报名中</option>
      <option value="进行中">进行中</option>
      <option value="已结束">已结束</option>
    </select>
  </div>
</template>
```

##### 3. 地点筛选
**自动提取地点**:
```javascript
const locations = computed(() => {
  const locationSet = new Set();
  activities.value.forEach(activity => {
    if (activity.hddd) {
      locationSet.add(activity.hddd);
    }
  });
  return Array.from(locationSet).sort();
});
```

**下拉选择**:
```vue
<select v-model="selectedLocation" class="filter-select">
  <option value="">全部地点</option>
  <option v-for="loc in locations" :key="loc" :value="loc">
    {{ loc }}
  </option>
</select>
```

##### 4. 可折叠筛选面板
**交互设计**:
```vue
<template>
  <div class="search-section">
    <!-- 折叠按钮 -->
    <button @click="showFilters = !showFilters" class="toggle-btn">
      <span>{{ showFilters ? '收起筛选' : '展开筛选' }}</span>
      <svg :class="{ 'rotate-180': showFilters }">
        <!-- 箭头图标 -->
      </svg>
    </button>
    
    <!-- 筛选面板（带动画） -->
    <transition name="slide-fade">
      <div v-show="showFilters" class="filters-panel">
        <!-- 筛选选项 -->
      </div>
    </transition>
  </div>
</template>

<style>
.slide-fade-enter-active, .slide-fade-leave-active {
  transition: all 0.3s ease;
}
.slide-fade-enter-from, .slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
```

##### 5. 搜索结果统计
```vue
<template>
  <div class="search-results-info">
    <span v-if="searchKeyword || selectedStatus || selectedLocation">
      找到 <strong class="text-blue-600">{{ filteredActivities.length }}</strong> 个活动
    </span>
    <button v-if="hasActiveFilters" @click="clearFilters" class="clear-btn">
      清空筛选
    </button>
  </div>
</template>

<script setup>
const hasActiveFilters = computed(() => {
  return searchKeyword.value || selectedStatus.value || selectedLocation.value;
});

const clearFilters = () => {
  searchKeyword.value = '';
  selectedStatus.value = '';
  selectedLocation.value = '';
};
</script>
```

##### 6. 空状态提示
```vue
<template>
  <div v-if="filteredActivities.length === 0" class="empty-state">
    <svg class="empty-icon"><!-- 空状态图标 --></svg>
    <p class="empty-text">没有找到符合条件的活动</p>
    <button @click="clearFilters" class="retry-btn">
      清空筛选条件
    </button>
  </div>
</template>
```

#### UI设计规范

**颜色方案**:
```css
:root {
  --primary-blue: #3b82f6;
  --primary-blue-dark: #2563eb;
  --gradient-start: #3b82f6;
  --gradient-end: #8b5cf6;
  --text-gray: #6b7280;
  --border-gray: #e5e7eb;
}
```

**响应式布局**:
```css
/* 桌面端 */
@media (min-width: 768px) {
  .filters-panel {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
  }
}

/* 移动端 */
@media (max-width: 767px) {
  .filters-panel {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }
}
```

#### 性能优化

**1. 防抖搜索**:
```javascript
import { debounce } from 'lodash-es';

const debouncedSearch = debounce((keyword) => {
  searchKeyword.value = keyword;
}, 300);
```

**2. 计算属性缓存**:
```javascript
// 使用computed自动缓存结果
const filteredActivities = computed(() => {
  // 筛选逻辑
});
```

**3. 虚拟滚动**（可选）:
```javascript
// 当活动数量超过100时启用虚拟滚动
import { useVirtualList } from '@vueuse/core';
```

#### 影响范围
- **前端文件**: `frontend/src/views/student/components/ActivityHall.vue`

#### 用户体验提升
- ⚡ 实时搜索，无需点击按钮
- 🎯 多维度筛选，精准定位
- 📊 结果统计，一目了然
- 🎨 美观界面，操作流畅
- 📱 响应式设计，移动友好

---

### 2.2 取消报名功能 ❌

#### 功能概述
允许学生在活动开始前取消已报名的活动，提供灵活的报名管理能力。

#### 业务规则

**允许取消的条件**:
1. ✅ 报名记录存在
2. ✅ 活动尚未开始
3. ✅ 报名状态为"未审核"或"已审核通过"

**不允许取消的情况**:
1. ❌ 活动已经开始
2. ❌ 活动已经结束
3. ❌ 报名已被拒绝

#### 完整实现方案

##### 1. 后端Mapper层

**StudentActivityMapper.java**
```java
package com.university.volunteer.mapper;

import org.apache.ibatis.annotations.*;

@Mapper
public interface StudentActivityMapper {
    
    /**
     * 删除报名记录
     * @param studentId 学生学号
     * @param activityId 活动编号
     * @return 影响的行数
     */
    @Delete("DELETE FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int deleteRegistration(@Param("studentId") String studentId, 
                          @Param("activityId") Integer activityId);
    
    /**
     * 查询报名记录是否存在
     * @param studentId 学生学号
     * @param activityId 活动编号
     * @return 报名记录数量
     */
    @Select("SELECT COUNT(*) FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int checkRegistrationExists(@Param("studentId") String studentId, 
                                @Param("activityId") Integer activityId);
    
    /**
     * 查询活动开始时间
     * @param activityId 活动编号
     * @return 活动开始时间
     */
    @Select("SELECT HD_KSSJ FROM t_zyhd WHERE HD_BH = #{activityId}")
    String getActivityStartTime(@Param("activityId") Integer activityId);
}
```

##### 2. Service业务层

**StudentActivityService.java**
```java
package com.university.volunteer.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class StudentActivityService {
    
    @Autowired
    private StudentActivityMapper studentActivityMapper;
    
    /**
     * 取消报名
     * @param studentId 学生学号
     * @param activityId 活动编号
     * @throws RuntimeException 业务异常
     */
    @Transactional(rollbackFor = Exception.class)
    public void cancelRegistration(String studentId, Integer activityId) {
        // 1. 验证报名记录是否存在
        int count = studentActivityMapper.checkRegistrationExists(studentId, activityId);
        if (count == 0) {
            throw new RuntimeException("未找到报名记录");
        }
        
        // 2. 检查活动是否已开始
        String startTimeStr = studentActivityMapper.getActivityStartTime(activityId);
        LocalDateTime startTime = LocalDateTime.parse(startTimeStr, 
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime now = LocalDateTime.now();
        
        if (now.isAfter(startTime)) {
            throw new RuntimeException("活动已开始，无法取消报名");
        }
        
        // 3. 删除报名记录
        int result = studentActivityMapper.deleteRegistration(studentId, activityId);
        if (result == 0) {
