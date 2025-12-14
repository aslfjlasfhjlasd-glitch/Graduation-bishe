<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import axios from 'axios'
import Button from '@/components/ui/button/button.vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Calendar, MapPin, Users, Leaf, BookOpen, HeartPulse, Sparkles, Info, ShieldCheck, Building2, Clock, CalendarCheck, CalendarX, Activity, Flag, AlertCircle, CheckCircle2, Search, X, Filter, SlidersHorizontal, Star, TrendingUp } from 'lucide-vue-next'
import { DialogRoot, DialogOverlay, DialogContent, DialogTitle, DialogDescription } from 'radix-vue'
import { ToastProvider, ToastViewport, ToastRoot, ToastTitle, ToastDescription, ToastClose } from 'radix-vue'
import { getRecommendedActivities, reportActivityView } from '@/api/recommend.js'
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

// 搜索和筛选相关状态
const searchKeyword = ref('')
const selectedStatus = ref('全部')
const selectedLocation = ref('全部')
const showFilters = ref(false)

const icons = { Leaf, BookOpen, HeartPulse, Sparkles }
const pickIcon = (title) => {
  const t = String(title || '')
  if (/(环保|环境|垃圾|绿|生态)/.test(t)) return 'Leaf'
  if (/(教育|简历|咨询|大赛|毕业|迎新|开学|学院|课堂)/.test(t)) return 'BookOpen'
  if (/(医疗|献血|健康|体质|医|医院|心理)/.test(t)) return 'HeartPulse'
  return 'Sparkles'
}

const activities = ref([])
const listLoading = ref(false)
const detailOpen = ref(false)
const detailLoading = ref(false)
const selectedId = ref(null)
const detail = ref(null)
const toastOpen = ref(false)
const toastTitle = ref('')
const toastDesc = ref('')

// 推荐相关状态
const recommendedActivities = ref([])
const recommendLoading = ref(false)
const showRecommendations = ref(false) // 🔥 改为 false，不自动显示
const showAllRecommendations = ref(false) // 新增：控制是否展开所有推荐

const loadActivities = async () => {
  listLoading.value = true
  try {
    const res = await axios.get(`${API_BASE}/api/dashboard/activities`)
    if (res.data && res.data.code === 200) {
      const rows = Array.isArray(res.data.data) ? res.data.data : []
      activities.value = rows.map(r => ({
        id: Number(r.id),
        hdmc: String(r.hdmc || ''),
        bmsj: String(r.bmsj || ''),
        hdsj: String(r.hdsj || ''),
        hddd: String(r.hddd || ''),
        zyrs: String(r.zyrs || ''),
        ybmrs: Number(r.ybmrs || 0),  // 已报名人数
        // 新增独立时间字段
        bmkssj: r.bmkssj || null,
        bmjssj: r.bmjssj || null,
        hdkssj: r.hdkssj || null,
        hdjssj: r.hdjssj || null,
        // 【新增】活动类型字段
        hdbq: r.hdbq || r.hdBq || r.HD_BQ || '其他',
        icon: pickIcon(r.hdmc)
      }))
      updateStatuses()
    } else {
      activities.value = []
    }
  } catch (e) {
    activities.value = []
  } finally {
    listLoading.value = false
  }
}

// 🔥 修改：手动触发推荐加载
const handleSmartRecommendClick = async () => {
  // 如果已经加载过推荐，直接显示
  if (recommendedActivities.value.length > 0) {
    showRecommendations.value = true
    showAllRecommendations.value = false
    return
  }

  // 开始加载推荐
  recommendLoading.value = true
  try {
    const studentId = localStorage.getItem('studentId')
    if (!studentId) {
      showToast('error', '推荐失败', '未找到学生信息，请重新登录')
      return
    }
    
    const res = await getRecommendedActivities(parseInt(studentId))
    if (res.data && res.data.code === 200) {
      const recommendations = res.data.data || []
      
      // 如果没有推荐结果
      if (recommendations.length === 0) {
        showToast('info', '暂无推荐', '暂时没有适合您的活动推荐，快去多参与几个活动吧！')
        return
      }
      
      // 转换推荐数据格式
      recommendedActivities.value = recommendations.map(item => ({
        id: item.activity.hdBh,
        hdmc: item.activity.hdMc,
        bmsj: item.activity.bmSj || '',
        hdsj: item.activity.hdSj || '',
        hddd: item.activity.hdDd || '',
        zyrs: item.activity.zmRs || '不限',
        ybmrs: item.activity.ybmRs || 0,
        bmkssj: item.activity.bmKssj,
        bmjssj: item.activity.bmJssj,
        hdkssj: item.activity.hdKssj,
        hdjssj: item.activity.hdJssj,
        hdbq: item.activity.hdBq || '其他',
        icon: pickIcon(item.activity.hdMc),
        matchScore: item.matchScore || 0,
        matchedTags: item.matchedTags || [],
        activityTags: item.activityTags || [],
        recommendType: item.recommendType || 'HOT'
      }))
      
      // 计算推荐活动的状态
      recommendedActivities.value = recommendedActivities.value.map(a => ({
        ...a,
        status: computeStatus(a)
      }))
      
      // 显示推荐区域
      showRecommendations.value = true
      showAllRecommendations.value = false
      
      showToast('success', '推荐成功', `为您找到 ${recommendedActivities.value.length} 个推荐活动`)
      console.log('✨ 推荐活动加载成功:', recommendedActivities.value.length, '个')
    } else {
      showToast('error', '推荐失败', res.data?.message || '获取推荐失败')
    }
  } catch (e) {
    console.error('❌ 加载推荐失败:', e)
    showToast('error', '推荐失败', '推荐服务暂时不可用，请稍后再试')
  } finally {
    recommendLoading.value = false
  }
}

/**
 * 打开活动详情
 * 关键改动：在打开详情的第一时间，静默上报浏览次数
 * 使用 Fire-and-Forget 模式，不等待响应，避免影响用户体验
 */
const openDetail = async (id) => {
  // 🔥 埋点：上报浏览次数（不等待响应）
  reportActivityView(id).catch(err => {
    // 静默处理错误，不影响用户查看详情
    console.warn('浏览计数失败:', err)
  })
  
  // 继续原有的详情加载逻辑
  selectedId.value = id
  detailOpen.value = true
  detailLoading.value = true
  detail.value = null
  try {
    const res = await axios.get(`${API_BASE}/api/dashboard/activities/${id}`)
    if (res.data && res.data.code === 200) {
      const data = res.data.data || null
      if (data) {
        // 添加独立时间字段并计算实时状态
        detail.value = {
          ...data,
          bmkssj: data.bmkssj || null,
          bmjssj: data.bmjssj || null,
          hdkssj: data.hdkssj || null,
          hdjssj: data.hdjssj || null,
          // 计算实时状态
          computedStatus: computeStatus({
            bmkssj: data.bmkssj,
            bmjssj: data.bmjssj,
            hdkssj: data.hdkssj,
            hdjssj: data.hdjssj
          })
        }
      } else {
        detail.value = null
      }
    } else {
      detail.value = null
    }
  } catch (e) {
    detail.value = null
  } finally {
    detailLoading.value = false
  }
}

let toastTimer = null
const toastType = ref('info')
const toastIcon = computed(() => toastType.value === 'success' ? CheckCircle2 : AlertCircle)
const toastRootClass = computed(() => {
  if (toastType.value === 'success') return 'bg-emerald-50 border border-emerald-200'
  if (toastType.value === 'error') return 'bg-rose-50 border border-rose-200'
  return 'bg-white border border-slate-200'
})
const toastTitleClass = computed(() => {
  if (toastType.value === 'success') return 'font-semibold text-emerald-800'
  if (toastType.value === 'error') return 'font-semibold text-rose-800'
  return 'font-semibold text-slate-800'
})
const toastDescClass = computed(() => {
  if (toastType.value === 'success') return 'text-emerald-700 text-sm'
  if (toastType.value === 'error') return 'text-rose-700 text-sm'
  return 'text-slate-500 text-sm'
})

const showToast = (type, title, desc) => {
  toastType.value = type
  toastTitle.value = title
  toastDesc.value = desc || ''
  toastOpen.value = true
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastOpen.value = false }, 2500)
}
  

const registerActivity = async (item) => {
  // 检查活动状态 - 只有"活动报名中"才能报名
  if (item.status === '报名未开始') {
    return showToast('error', '报名失败', '报名尚未开始，请等待报名开始时间')
  }
  if (item.status === '活动未开始') {
    return showToast('error', '报名失败', '报名已结束，请关注下次活动')
  }
  if (item.status === '活动进行中') {
    return showToast('error', '报名失败', '活动已经开始，无法报名')
  }
  if (item.status === '活动已结束') {
    return showToast('error', '报名失败', '活动已结束')
  }

  try {
    const studentId = localStorage.getItem('studentId') || '2024104'
    const res = await axios.post(`${API_BASE}/api/student/activity/register`, {
      studentId,
      activityId: item.id
    })
    
    if (res.data.code === 200) {
      showToast('success', '报名成功', `您已成功报名：${item.hdmc}`)
      // 刷新活动列表以更新状态（如名额变化）
      loadActivities()
    } else {
      // 处理后端返回的错误信息（如重复报名）
      const errorMsg = res.data.message || '未知错误'
      showToast('error', '报名失败', errorMsg)
    }
  } catch (error) {
    // 处理网络错误
    const errorMsg = error.response?.data?.message || '网络请求失败，请稍后重试'
    showToast('error', '报名失败', errorMsg)
    console.error('报名错误:', error)
  }
}

// 获取北京时间（UTC+8）
const toBJNow = () => {
  const now = new Date()
  return new Date(now.getTime() + (480 + now.getTimezoneOffset()) * 60000)
}

// 解析后端返回的时间字符串（格式：YYYY-MM-DD HH:mm:ss）
const parseDateTime = (dateStr) => {
  if (!dateStr) return null
  try {
    // 格式：2026-02-08 14:00:00
    const match = dateStr.match(/(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})/)
    if (!match) return null
    
    const [, year, month, day, hour, minute, second] = match
    // 创建UTC时间，然后减去8小时得到北京时间对应的UTC时间
    const utcTime = Date.UTC(
      parseInt(year),
      parseInt(month) - 1,
      parseInt(day),
      parseInt(hour) - 8,  // 北京时间减8小时得到UTC
      parseInt(minute),
      parseInt(second)
    )
    return new Date(utcTime)
  } catch (e) {
    console.error('解析时间失败:', dateStr, e)
    return null
  }
}

const statusIconMap = {
  '报名未开始': Clock,
  '活动报名中': CalendarCheck,
  '活动未开始': CalendarX,
  '活动进行中': Activity,
  '活动已结束': Flag
}

const statusClassMap = {
  '报名未开始': 'bg-slate-100 text-slate-700',
  '活动报名中': 'bg-green-100 text-green-700',
  '活动未开始': 'bg-amber-100 text-amber-700',
  '活动进行中': 'bg-emerald-100 text-emerald-700',
  '活动已结束': 'bg-slate-200 text-slate-700'
}

// 根据独立时间字段计算活动状态
const computeStatus = (item) => {
  const now = toBJNow()
  
  // 使用独立的时间字段
  const regStart = parseDateTime(item.bmkssj)
  const regEnd = parseDateTime(item.bmjssj)
  const actStart = parseDateTime(item.hdkssj)
  const actEnd = parseDateTime(item.hdjssj)
  
  // 如果时间字段不完整，返回未知状态
  if (!regStart || !regEnd || !actStart || !actEnd) {
    return '报名未开始'
  }
  
  // 状态判断逻辑（按时间顺序）
  // 1. 报名未开始
  if (now < regStart) {
    return '报名未开始'
  }
  
  // 2. 活动报名中
  if (now >= regStart && now <= regEnd) {
    return '活动报名中'
  }
  
  // 3. 报名已结束，活动未开始
  if (now > regEnd && now < actStart) {
    return '活动未开始'
  }
  
  // 4. 活动进行中
  if (now >= actStart && now <= actEnd) {
    return '活动进行中'
  }
  
  // 5. 活动已结束
  if (now > actEnd) {
    return '活动已结束'
  }
  
  // 默认状态
  return '报名未开始'
}

const updateStatuses = () => {
  activities.value = activities.value.map(a => {
    const s = computeStatus(a)
    return { ...a, status: s }
  })
}

// 获取所有唯一的地点
const uniqueLocations = computed(() => {
  const locations = activities.value.map(a => a.hddd).filter(Boolean)
  return ['全部', ...new Set(locations)]
})

// 筛选后的活动列表
const filteredActivities = computed(() => {
  let result = activities.value

  // 关键词搜索
  if (searchKeyword.value.trim()) {
    const keyword = searchKeyword.value.trim().toLowerCase()
    result = result.filter(a =>
      a.hdmc.toLowerCase().includes(keyword) ||
      a.hddd.toLowerCase().includes(keyword) ||
      a.bmsj.toLowerCase().includes(keyword)
    )
  }

  // 状态筛选
  if (selectedStatus.value !== '全部') {
    result = result.filter(a => a.status === selectedStatus.value)
  }

  // 地点筛选
  if (selectedLocation.value !== '全部') {
    result = result.filter(a => a.hddd === selectedLocation.value)
  }

  return result
})

// 清空搜索
const clearSearch = () => {
  searchKeyword.value = ''
  selectedStatus.value = '全部'
  selectedLocation.value = '全部'
}

// 切换筛选面板
const toggleFilters = () => {
  showFilters.value = !showFilters.value
}

let statusTimer = null
onMounted(async () => {
  await loadActivities()
  // 🔥 移除自动加载推荐
  statusTimer = setInterval(updateStatuses, 60000)
})
onUnmounted(() => {
  if (statusTimer) clearInterval(statusTimer)
})
</script>

<template>
  <div class="relative">
    <ToastProvider>
      <ToastViewport class="fixed left-1/2 -translate-x-1/2 top-4 z-[100]" />
      <ToastRoot v-model:open="toastOpen" :class="[toastRootClass, 'rounded-md shadow-xl p-4 pr-10 flex items-start gap-3 data-[state=open]:animate-in data-[state=open]:fade-in data-[state=open]:slide-in-from-top-1 data-[state=closed]:animate-out data-[state=closed]:fade-out data-[state=closed]:slide-out-to-top-1 duration-300']">
        <component :is="toastIcon" class="w-5 h-5" />
        <div>
          <ToastTitle :class="toastTitleClass">{{ toastTitle }}</ToastTitle>
          <ToastDescription :class="toastDescClass">{{ toastDesc }}</ToastDescription>
        </div>
        <ToastClose class="absolute right-2 top-2 text-slate-400">×</ToastClose>
      </ToastRoot>
    </ToastProvider>

    <!-- 🌟 智能推荐区域 -->
    <div v-if="showRecommendations && recommendedActivities.length > 0" class="mb-8 animate-in fade-in slide-in-from-top-4 duration-500">
      <div class="flex items-center justify-between mb-5">
        <div class="flex items-center gap-3">
          <div class="flex items-center justify-center w-10 h-10 rounded-xl bg-gradient-to-br from-amber-400 via-orange-400 to-rose-400 shadow-lg">
            <Star class="w-5 h-5 text-white" />
          </div>
          <div>
            <h2 class="text-2xl font-bold text-slate-900 flex items-center gap-2">
              猜你喜欢
              <span class="text-sm font-normal text-amber-600 bg-amber-50 px-2 py-0.5 rounded-full">智能推荐</span>
            </h2>
            <p class="text-sm text-slate-600 mt-0.5">基于您的兴趣标签为您精选活动</p>
          </div>
        </div>
        <Button
          variant="ghost"
          size="sm"
          @click="showRecommendations = false"
          class="text-slate-500 hover:text-slate-700"
        >
          <X class="w-4 h-4" />
        </Button>
      </div>

      <!-- 推荐活动卡片 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <Card
          v-for="item in (showAllRecommendations ? recommendedActivities : recommendedActivities.slice(0, 6))"
          :key="item.id"
          class="group relative bg-gradient-to-br from-white to-slate-50/50 border-2 hover:shadow-2xl rounded-2xl transition-all duration-300 hover:scale-[1.03] overflow-hidden"
          :class="item.recommendType === 'CONTENT_BASED' ? 'border-amber-200 hover:border-amber-400' : 'border-blue-200 hover:border-blue-400'"
        >
          <!-- 推荐标签角标 -->
          <div class="absolute top-0 right-0 z-10">
            <div
              v-if="item.recommendType === 'CONTENT_BASED'"
              class="bg-gradient-to-br from-amber-500 to-orange-500 text-white text-xs font-bold px-3 py-1.5 rounded-bl-xl rounded-tr-xl shadow-lg flex items-center gap-1"
            >
              <Star class="w-3 h-3 fill-current" />
              匹配度 {{ item.matchScore }}分
            </div>
            <div
              v-else
              class="bg-gradient-to-br from-blue-500 to-cyan-500 text-white text-xs font-bold px-3 py-1.5 rounded-bl-xl rounded-tr-xl shadow-lg flex items-center gap-1"
            >
              <TrendingUp class="w-3 h-3" />
              热门推荐
            </div>
          </div>

          <CardHeader class="pb-3 px-5 pt-5">
            <div class="flex items-center gap-3">
              <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-tr from-blue-600 via-cyan-500 to-emerald-500 text-white shadow-lg">
                <component :is="icons[item.icon]" class="w-5 h-5" />
              </span>
              <div class="flex-1 min-w-0">
                <CardTitle class="text-slate-900 text-base font-bold line-clamp-2">{{ item.hdmc }}</CardTitle>
                <!-- 【新增】活动类型标签 -->
                <div v-if="item.hdbq" class="flex flex-wrap gap-1.5 mt-1.5">
                  <Badge
                    v-for="tag in item.hdbq.split(',')"
                    :key="tag"
                    variant="outline"
                    class="text-xs px-2 py-0.5 bg-blue-50 text-blue-700 border-blue-200"
                  >
                    {{ tag.trim() }}
                  </Badge>
                </div>
              </div>
            </div>
          </CardHeader>

          <CardContent class="space-y-3 px-5 pb-20">
            <!-- 匹配标签高亮显示 -->
            <div v-if="item.matchedTags && item.matchedTags.length > 0" class="flex flex-wrap gap-1.5">
              <span
                v-for="tag in item.matchedTags.slice(0, 4)"
                :key="tag"
                class="inline-flex items-center gap-1 text-xs font-semibold bg-gradient-to-r from-red-100 to-rose-100 text-red-700 px-2.5 py-1 rounded-full border border-red-200 shadow-sm"
              >
                <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span>
                {{ tag }}
              </span>
              <span
                v-if="item.matchedTags.length > 4"
                class="inline-flex items-center text-xs text-slate-500 px-2 py-1"
              >
                +{{ item.matchedTags.length - 4 }}
              </span>
            </div>

            <!-- 活动信息 -->
            <div class="text-sm text-slate-700 space-y-2">
              <div class="flex items-center gap-2">
                <Calendar class="w-4 h-4 text-blue-600 flex-shrink-0" />
                <span class="line-clamp-1">{{ item.hdsj }}</span>
              </div>
              <div class="flex items-center gap-2">
                <MapPin class="w-4 h-4 text-emerald-600 flex-shrink-0" />
                <span class="line-clamp-1">{{ item.hddd }}</span>
              </div>
              <div class="flex items-center gap-2">
                <Users class="w-4 h-4 text-cyan-600 flex-shrink-0" />
                <span>
                  <span class="font-semibold text-cyan-700">{{ item.ybmrs }}</span>
                  <span class="text-slate-500 mx-1">/</span>
                  <span>{{ item.zyrs }}</span>
                </span>
              </div>
            </div>
          </CardContent>

          <!-- 操作按钮 -->
          <div class="absolute bottom-4 left-4 flex items-center gap-2">
            <Button
              variant="default"
              size="sm"
              class="gap-1.5 shadow-md"
              @click="openDetail(item.id)"
            >
              <Info class="w-3.5 h-3.5" />
              查看详情
            </Button>
            <Button
              variant="secondary"
              size="sm"
              class="shadow-md"
              @click="registerActivity(item)"
            >
              立即报名
            </Button>
          </div>

          <!-- 状态标签 -->
          <div class="absolute bottom-4 right-4">
            <span
              class="inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium shadow-sm"
              :class="statusClassMap[item.status]"
            >
              <component :is="statusIconMap[item.status]" class="w-3.5 h-3.5" />
              {{ item.status }}
            </span>
          </div>
        </Card>
      </div>

      <!-- 查看更多推荐 -->
      <div v-if="recommendedActivities.length > 6 && !showAllRecommendations" class="mt-4 text-center">
        <Button
          variant="outline"
          class="gap-2"
          @click="showAllRecommendations = true"
        >
          <Sparkles class="w-4 h-4" />
          查看更多推荐 ({{ recommendedActivities.length - 6 }}+)
        </Button>
      </div>

      <!-- 收起推荐 -->
      <div v-if="showAllRecommendations && recommendedActivities.length > 6" class="mt-4 text-center">
        <Button
          variant="ghost"
          class="gap-2 text-slate-500"
          @click="showAllRecommendations = false"
        >
          收起推荐
        </Button>
      </div>

      <!-- 分隔线 -->
      <div class="mt-8 mb-6 border-t border-slate-200"></div>
    </div>

    <!-- 搜索和筛选区域 -->
    <div class="mb-6 space-y-4">
      <!-- 搜索框 -->
      <div class="relative">
        <div class="relative flex items-center gap-3">
          <div class="relative flex-1">
            <Search class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
            <input
              v-model="searchKeyword"
              type="text"
              placeholder="搜索活动名称、地点或时间..."
              class="w-full pl-12 pr-12 py-3.5 bg-white/80 backdrop-blur-sm border border-slate-200 rounded-xl text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 transition-all duration-200 shadow-sm hover:shadow-md"
            />
            <button
              v-if="searchKeyword"
              @click="searchKeyword = ''"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
            >
              <X class="w-5 h-5" />
            </button>
          </div>
          
          <!-- 🔥 新增：智能推荐按钮 -->
          <Button
            @click="handleSmartRecommendClick"
            :disabled="recommendLoading"
            class="flex items-center gap-2 px-4 py-3.5 bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white border-0 shadow-md hover:shadow-lg transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Sparkles class="w-5 h-5" :class="{ 'animate-spin': recommendLoading }" />
            <span class="hidden sm:inline">{{ recommendLoading ? '加载中...' : '智能推荐' }}</span>
          </Button>
          
          <Button
            @click="toggleFilters"
            variant="outline"
            class="flex items-center gap-2 px-4 py-3.5 bg-white/80 backdrop-blur-sm border-slate-200 hover:bg-slate-50 transition-all duration-200"
            :class="{ 'bg-blue-50 border-blue-300 text-blue-700': showFilters }"
          >
            <SlidersHorizontal class="w-5 h-5" />
            <span class="hidden sm:inline">筛选</span>
          </Button>
          <Button
            v-if="searchKeyword || selectedStatus !== '全部' || selectedLocation !== '全部'"
            @click="clearSearch"
            variant="outline"
            class="flex items-center gap-2 px-4 py-3.5 bg-white/80 backdrop-blur-sm border-slate-200 hover:bg-rose-50 hover:border-rose-300 hover:text-rose-700 transition-all duration-200"
          >
            <X class="w-5 h-5" />
            <span class="hidden sm:inline">清空</span>
          </Button>
        </div>
      </div>

      <!-- 筛选面板 -->
      <div
        v-if="showFilters"
        class="bg-white/80 backdrop-blur-sm border border-slate-200 rounded-xl p-5 shadow-sm animate-in fade-in slide-in-from-top-2 duration-300"
      >
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <!-- 状态筛选 -->
          <div>
            <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
              <Filter class="w-4 h-4 text-blue-600" />
              活动状态
            </label>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="status in ['全部', '报名未开始', '活动报名中', '活动未开始', '活动进行中', '活动已结束']"
                :key="status"
                @click="selectedStatus = status"
                class="px-3 py-1.5 rounded-lg text-sm font-medium transition-all duration-200"
                :class="selectedStatus === status
                  ? 'bg-gradient-to-r from-blue-600 to-cyan-500 text-white shadow-md'
                  : 'bg-slate-100 text-slate-700 hover:bg-slate-200'"
              >
                {{ status }}
              </button>
            </div>
          </div>

          <!-- 地点筛选 -->
          <div>
            <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
              <MapPin class="w-4 h-4 text-emerald-600" />
              活动地点
            </label>
            <select
              v-model="selectedLocation"
              class="w-full px-4 py-2 bg-white border border-slate-200 rounded-lg text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500 transition-all duration-200"
            >
              <option v-for="loc in uniqueLocations" :key="loc" :value="loc">
                {{ loc }}
              </option>
            </select>
          </div>
        </div>
      </div>

      <!-- 搜索结果统计 -->
      <div v-if="searchKeyword || selectedStatus !== '全部' || selectedLocation !== '全部'" class="flex items-center gap-2 text-sm text-slate-600">
        <Info class="w-4 h-4" />
        <span>找到 <span class="font-semibold text-blue-600">{{ filteredActivities.length }}</span> 个活动</span>
      </div>
    </div>

    <!-- 无结果提示 -->
    <div v-if="filteredActivities.length === 0" class="text-center py-16">
      <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-slate-100 mb-4">
        <Search class="w-10 h-10 text-slate-400" />
      </div>
      <h3 class="text-lg font-semibold text-slate-900 mb-2">未找到相关活动</h3>
      <p class="text-slate-600 mb-4">请尝试调整搜索条件或筛选选项</p>
      <Button @click="clearSearch" variant="outline" class="gap-2">
        <X class="w-4 h-4" />
        清空筛选条件
      </Button>
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <Card v-for="item in filteredActivities" :key="item.id" class="group relative bg-white border border-slate-200/70 shadow-sm hover:shadow-lg rounded-2xl transition-all duration-300 hover:scale-[1.02] ring-1 ring-white/40 min-h-[260px] md:min-h-[300px]">
      <CardHeader class="pb-3 px-6 pt-5">
        <div class="flex items-center gap-3">
          <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-tr from-blue-600 via-cyan-500 to-emerald-500 text-white shadow">
            <component :is="icons[item.icon]" class="w-5 h-5" />
          </span>
          <div class="flex-1 min-w-0">
            <CardTitle class="text-slate-900 text-lg">{{ item.hdmc }}</CardTitle>
            <!-- 【新增】活动类型标签 -->
            <div v-if="item.hdbq" class="flex flex-wrap gap-1.5 mt-1.5">
              <Badge
                v-for="tag in item.hdbq.split(',')"
                :key="tag"
                variant="outline"
                class="text-xs px-2 py-0.5 bg-blue-50 text-blue-700 border-blue-200"
              >
                {{ tag.trim() }}
              </Badge>
            </div>
          </div>
        </div>
      </CardHeader>
      <CardContent class="space-y-4 px-6 pb-20">
        <div class="flex items-center text-slate-700 gap-2">
          <Calendar class="w-5 h-5 text-blue-600" />
          <span class="text-[0.95rem]">{{ item.bmsj }}</span>
        </div>
        <div class="flex items-center text-slate-700 gap-2">
          <MapPin class="w-5 h-5 text-emerald-600" />
          <span class="text-[0.95rem]">{{ item.hddd }}</span>
        </div>
        <div class="flex items-center text-slate-700 gap-2">
          <Users class="w-5 h-5 text-cyan-600" />
          <span class="text-[0.95rem]">
            <span class="font-semibold text-cyan-700">{{ item.ybmrs }}</span>
            <span class="text-slate-500 mx-1">/</span>
            <span>{{ item.zyrs }}</span>
          </span>
        </div>
      
      </CardContent>
      <div class="absolute bottom-4 left-4 flex items-center gap-3">
        <Button variant="default" class="group gap-2" @click="openDetail(item.id)">
          <span>查看详情</span>
          <Info class="w-4 h-4 transition-transform group-hover:translate-x-0.5" />
        </Button>
        <Button variant="secondary" class="group" @click="registerActivity(item)">报名</Button>
      </div>
      <div class="absolute bottom-4 right-4">
        <span class="inline-flex items-center gap-2 rounded-full px-3 py-1.5 text-xs md:text-sm font-medium shadow-sm transition-colors duration-300" :class="statusClassMap[item.status]">
          <component :is="statusIconMap[item.status]" class="w-4 h-4" />
          <span>{{ item.status }}</span>
        </span>
      </div>
    </Card>
    </div>
  </div>

  <DialogRoot v-model:open="detailOpen">
    <DialogOverlay class="fixed inset-0 bg-slate-900/30 backdrop-blur-[6px]" />
    <DialogContent class="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-[90vw] max-w-lg max-h-[85vh] bg-white/80 backdrop-blur-xl border border-white/40 rounded-xl shadow-2xl p-0 z-50 flex flex-col">
      <div class="h-1.5 w-full bg-gradient-to-r from-blue-600 via-cyan-500 to-emerald-500 rounded-t-xl flex-shrink-0"></div>
      <div class="p-5 flex items-center gap-3 flex-shrink-0">
        <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-blue-600 text-white">
          <Info class="w-4 h-4" />
        </span>
        <DialogTitle class="text-lg font-semibold text-slate-900">活动详情</DialogTitle>
      </div>
      <DialogDescription class="px-5 -mt-2 text-slate-600 text-xs flex-shrink-0">编号 {{ detail?.id ?? selectedId }}</DialogDescription>

      <div v-if="detailLoading" class="py-12 text-center text-slate-500 flex-1">加载中...</div>
      <div v-else-if="!detail" class="py-12 text-center text-red-500 flex-1">未获取到详情</div>
      <div v-else class="mt-3 px-5 pb-4 overflow-y-auto flex-1 custom-scrollbar">
        <div class="grid grid-cols-1 gap-2.5">
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Sparkles class="w-4 h-4 text-indigo-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动名称：</span>{{ detail.hdmc }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Calendar class="w-4 h-4 text-blue-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">报名时间：</span>{{ detail.bmsj }}</div>
          </div>
          <div v-if="detail.hdkssj" class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Calendar class="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动开始时间：</span>{{ detail.hdkssj }}</div>
          </div>
          <div v-if="detail.hdjssj" class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Calendar class="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动结束时间：</span>{{ detail.hdjssj }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <MapPin class="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动地点：</span>{{ detail.hddd }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Users class="w-4 h-4 text-cyan-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">招募人数：</span>{{ detail.zyrs }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <BookOpen class="w-4 h-4 text-purple-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动内容：</span>{{ detail.hdnr }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <ShieldCheck class="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动需求条件：</span>{{ detail.hdxq }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <ShieldCheck class="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">活动保障：</span>{{ detail.hdbz }}</div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Building2 class="w-4 h-4 text-slate-700 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700"><span class="font-medium">发起单位：</span>{{ detail.hdfqdw }}</div>
          </div>
          <!-- 【新增】活动类型显示 -->
          <div v-if="detail.hdbq" class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <Sparkles class="w-4 h-4 text-purple-600 flex-shrink-0 mt-0.5" />
            <div class="text-sm text-slate-700">
              <span class="font-medium">活动类型：</span>
              <span class="inline-flex flex-wrap gap-1.5 ml-1">
                <Badge
                  v-for="tag in detail.hdbq.split(',')"
                  :key="tag"
                  variant="secondary"
                  class="text-xs px-2 py-0.5"
                >
                  {{ tag.trim() }}
                </Badge>
              </span>
            </div>
          </div>
          <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-2.5">
            <component :is="statusIconMap[detail.computedStatus]" class="w-4 h-4 flex-shrink-0 mt-0.5" :class="detail.computedStatus === '活动报名中' ? 'text-green-600' : detail.computedStatus === '活动进行中' ? 'text-emerald-600' : detail.computedStatus === '活动已结束' ? 'text-slate-600' : 'text-slate-700'" />
            <div class="text-sm text-slate-700">
              <span class="font-medium">状态：</span>
              <span :class="statusClassMap[detail.computedStatus]?.replace('bg-', 'text-').replace('-100', '-700')" class="font-semibold">
                {{ detail.computedStatus }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div class="px-5 pb-4 flex justify-end flex-shrink-0 border-t border-slate-200/50 pt-3">
        <Button variant="outline" @click="detailOpen = false">关闭</Button>
      </div>
    </DialogContent>
  </DialogRoot>
</template>

<style scoped>
.radix-vue-toast-viewport {
  width: 380px;
}

/* 自定义滚动条样式 */
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 3px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* 优化字体渲染，防止模糊 */
* {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}

/* 确保对话框内容清晰 */
.text-sm {
  font-size: 0.875rem;
  line-height: 1.5;
  letter-spacing: 0.01em;
}

.font-medium {
  font-weight: 500;
}

.font-semibold {
  font-weight: 600;
}
</style>
