package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.*;
import com.university.volunteer.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class DepartmentHeadService {

    @Autowired
    private DepartmentHeadMapper departmentHeadMapper;

    @Autowired
    private AcademyMapper academyMapper;

    @Autowired
    private StudentActivityMapper studentActivityMapper;
    
    @Autowired
    private ActivityTagMapper activityTagMapper;
    
    @Autowired
    private TagMapper tagMapper;
    
    @Autowired
    private AdminMapper adminMapper;

    @Transactional(rollbackFor = Exception.class)
    public Result<String> auditRegistration(Integer registrationId, String status) {
        int rows = departmentHeadMapper.updateRegistrationStatus(registrationId, status);
        if (rows > 0) {
            return Result.success("审核操作成功");
        } else {
            return Result.error("审核操作失败，记录不存在或状态未变更");
        }
    }

    /**
     * 获取负责人信息（支持部门负责人和学院负责人）
     */
    public Result<Map<String, Object>> getHeadInfo(String username) {
        // 先查部门负责人表
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            Map<String, Object> info = new HashMap<>();
            info.put("type", "department");
            info.put("username", deptHead.getXjbmfzrZh());
            info.put("name", deptHead.getXjbmfzrXm());
            info.put("department", deptHead.getXjbmMc());
            info.put("phone", deptHead.getXjbmfzrDh());
            return Result.success(info);
        }

        // 再查学院表
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            Map<String, Object> info = new HashMap<>();
            info.put("type", "academy");
            info.put("username", academy.getXyZh());
            info.put("name", academy.getFzrXm());
            info.put("department", academy.getXyMc());
            info.put("phone", academy.getXyDh());
            return Result.success(info);
        }

        return Result.error("未找到用户信息");
    }

    /**
     * 更新负责人信息
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateHeadInfo(String username, String name, String phone) {
        // 先尝试更新部门负责人
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            deptHead.setXjbmfzrXm(name);
            deptHead.setXjbmfzrDh(phone);
            int rows = departmentHeadMapper.updateDepartmentHead(deptHead);
            if (rows > 0) {
                return Result.success("信息更新成功");
            } else {
                return Result.error("信息更新失败");
            }
        }

        // 再尝试更新学院负责人
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            academy.setFzrXm(name);
            academy.setXyDh(phone);
            int rows = academyMapper.updateAcademy(academy);
            if (rows > 0) {
                return Result.success("信息更新成功");
            } else {
                return Result.error("信息更新失败");
            }
        }

        return Result.error("未找到用户信息");
    }

    /**
     * 根据负责人获取其发起的活动列表
     */
    public Result<List<VolunteerActivity>> getActivitiesByHead(String username) {
        // 先获取负责人信息以确定部门/学院名称
        Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
        if (headInfoResult.getCode() != 200) {
            return Result.error("获取负责人信息失败");
        }

        String department = (String) headInfoResult.getData().get("department");
        if (department == null || department.isEmpty()) {
            return Result.error("未找到部门/学院信息");
        }

        // 根据部门/学院名称查询活动
        List<VolunteerActivity> activities = studentActivityMapper.findActivitiesByDepartment(department);
        
        // 动态更新活动状态
        java.util.Date now = new java.util.Date();
        for (VolunteerActivity activity : activities) {
            String newStatus = calculateActivityStatus(activity, now);
            // 如果状态发生变化，更新数据库
            if (!newStatus.equals(activity.getHdZt())) {
                activity.setHdZt(newStatus);
                studentActivityMapper.updateActivityStatus(activity.getHdBh(), newStatus);
            }
        }
        
        return Result.success(activities);
    }

    /**
     * 根据当前时间计算活动状态
     */
    private String calculateActivityStatus(VolunteerActivity activity, java.util.Date now) {
        if (activity.getBmKssj() == null || activity.getBmJssj() == null ||
            activity.getHdKssj() == null || activity.getHdJssj() == null) {
            return "未开始";
        }

        // 判断活动状态
        if (now.before(activity.getBmKssj())) {
            // 当前时间在报名开始之前
            return "未开始";
        } else if (now.after(activity.getBmKssj()) && now.before(activity.getBmJssj())) {
            // 当前时间在报名时间段内
            return "报名中";
        } else if (now.after(activity.getHdKssj()) && now.before(activity.getHdJssj())) {
            // 当前时间在活动时间段内
            return "进行中";
        } else if (now.after(activity.getHdJssj())) {
            // 当前时间在活动结束之后
            return "已结束";
        } else {
            // 报名已结束但活动未开始
            return "未开始";
        }
    }

    /**
     * 根据负责人获取报名记录列表（用于各种管理功能）
     */
    public Result<List<ActivityRegistration>> getRegistrationsByHead(String username) {
        // 先获取负责人信息以确定部门/学院名称
        Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
        if (headInfoResult.getCode() != 200) {
            return Result.error("获取负责人信息失败");
        }

        String department = (String) headInfoResult.getData().get("department");
        if (department == null || department.isEmpty()) {
            return Result.error("未找到部门/学院信息");
        }

        // 根据部门/学院名称查询报名记录
        List<ActivityRegistration> registrations = studentActivityMapper.findRegistrationsByDepartment(department);
        return Result.success(registrations);
    }

    /**
     * 更新活动信息（新增标签处理）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateActivity(VolunteerActivity activity) {
        if (activity.getHdBh() == null) {
            return Result.error("活动编号不能为空");
        }
        
        // 处理标签更新
        if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
            // 1. 删除活动的所有旧标签关联
            activityTagMapper.deleteByActivityId(activity.getHdBh());
            
            // 2. 批量插入新的标签关联
            List<ActivityTag> activityTags = new ArrayList<>();
            for (Integer tagId : activity.getTagIds()) {
                ActivityTag at = new ActivityTag();
                at.setHdBh(activity.getHdBh());
                at.setBqId(tagId);
                activityTags.add(at);
            }
            if (!activityTags.isEmpty()) {
                activityTagMapper.insertBatch(activityTags);
            }
            
            // 3. 更新冗余字段（用于兼容和快速查询）
            List<Tag> tags = tagMapper.findByIds(activity.getTagIds());
            if (tags != null && !tags.isEmpty()) {
                // 分离活动标签和技能要求
                String hdBq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 1)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                String jnYq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 2)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                activity.setHdBq(hdBq.isEmpty() ? null : hdBq);
                activity.setJnYq(jnYq.isEmpty() ? null : jnYq);
            }
        }
        
        int rows = studentActivityMapper.updateActivity(activity);
        if (rows > 0) {
            return Result.success("活动更新成功");
        } else {
            return Result.error("活动更新失败，活动不存在");
        }
    }

    /**
     * 删除活动
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> deleteActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        // 先删除该活动的所有报名记录
        // 注意：这里简化处理，实际应该先检查是否有已审核通过的报名
        int rows = studentActivityMapper.deleteActivity(activityId);
        if (rows > 0) {
            return Result.success("活动删除成功");
        } else {
            return Result.error("活动删除失败，活动不存在");
        }
    }

    /**
     * 下架活动（更新发布状态为"已下架"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> unpublishActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已下架");
        if (rows > 0) {
            return Result.success("活动已下架");
        } else {
            return Result.error("下架失败，活动不存在");
        }
    }

    /**
     * 上架活动（已废弃，负责人不再有此权限）
     */
    @Deprecated
    @Transactional(rollbackFor = Exception.class)
    public Result<String> publishActivity(Integer activityId) {
        return Result.error("负责人无权限发布活动，请申报后由管理员发布");
    }

    /**
     * 申报活动（将活动状态从"待申报"改为"待发布"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> submitActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        try {
            // 先查询活动当前状态
            VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
            if (activity == null) {
                return Result.error("活动不存在");
            }
            
            String currentStatus = activity.getFbZt();
            if (!"待申报".equals(currentStatus)) {
                return Result.error("只能申报状态为'待申报'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "待发布");
            if (rows > 0) {
                return Result.success("活动已申报，等待管理员审核发布");
            } else {
                return Result.error("申报失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("申报失败：" + e.getMessage());
        }
    }

    /**
     * 撤销申报（将活动状态从"待发布"改回"待申报"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> cancelSubmitActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        try {
            // 先查询活动当前状态
            VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
            if (activity == null) {
                return Result.error("活动不存在");
            }
            
            String currentStatus = activity.getFbZt();
            if (!"待发布".equals(currentStatus)) {
                return Result.error("只能撤销状态为'待发布'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "待申报");
            if (rows > 0) {
                return Result.success("已撤销申报");
            } else {
                return Result.error("撤销申报失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("撤销申报失败：" + e.getMessage());
        }
    }

    /**
     * 创建新活动（新增标签处理）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<VolunteerActivity> createActivity(String username, VolunteerActivity activity) {
        // 1. 判断用户是否是管理员
        boolean isAdmin = false;
        String department = null;
        
        Admin admin = adminMapper.findByUsername(username);
        if (admin != null) {
            isAdmin = true;
            // 管理员使用"校级管理"作为发起单位
            department = "校级管理";
        } else {
            // 2. 获取负责人信息以确定发起单位
            Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
            if (headInfoResult.getCode() != 200) {
                return Result.error("获取负责人信息失败");
            }

            department = (String) headInfoResult.getData().get("department");
            if (department == null || department.isEmpty()) {
                return Result.error("未找到部门/学院信息");
            }
        }

        // 3. 设置活动发起单位
        activity.setHdFqDw(department);
        
        // 4. 设置默认值
        activity.setYbmRs(0); // 已报名人数初始为0
        activity.setHdZt("未开始"); // 活动状态初始为未开始
        
        // 根据用户类型设置不同的默认发布状态
        // 管理员创建的活动默认为"待发布"，负责人创建的活动默认为"待申报"
        if (isAdmin) {
            activity.setFbZt("待发布"); // 管理员创建的活动默认待发布
        } else {
            activity.setFbZt("待申报"); // 负责人创建的活动默认待申报
        }
        
        activity.setBbh(0); // 乐观锁版本号初始为0

        // 5. 验证必填字段
        if (activity.getHdMc() == null || activity.getHdMc().trim().isEmpty()) {
            return Result.error("活动名称不能为空");
        }
        if (activity.getHdNr() == null || activity.getHdNr().trim().isEmpty()) {
            return Result.error("活动内容不能为空");
        }
        if (activity.getHdDd() == null || activity.getHdDd().trim().isEmpty()) {
            return Result.error("活动地点不能为空");
        }
        if (activity.getZmRs() == null || activity.getZmRs() <= 0) {
            return Result.error("招募人数必须大于0");
        }
        if (activity.getBmKssj() == null || activity.getBmJssj() == null) {
            return Result.error("报名时间不能为空");
        }
        if (activity.getHdKssj() == null || activity.getHdJssj() == null) {
            return Result.error("活动时间不能为空");
        }

        // 6. 验证时间逻辑
        if (activity.getBmKssj().after(activity.getBmJssj())) {
            return Result.error("报名开始时间不能晚于结束时间");
        }
        if (activity.getHdKssj().after(activity.getHdJssj())) {
            return Result.error("活动开始时间不能晚于结束时间");
        }
        if (activity.getBmJssj().after(activity.getHdKssj())) {
            return Result.error("报名结束时间不能晚于活动开始时间");
        }

        // 7. 处理标签（在插入活动之前准备冗余字段）
        if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
            List<Tag> tags = tagMapper.findByIds(activity.getTagIds());
            if (tags != null && !tags.isEmpty()) {
                String hdBq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 1)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                String jnYq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 2)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                activity.setHdBq(hdBq.isEmpty() ? null : hdBq);
                activity.setJnYq(jnYq.isEmpty() ? null : jnYq);
            }
        }

        // 8. 插入活动到数据库
        int rows = studentActivityMapper.insertActivity(activity);
        if (rows > 0) {
            // 9. 插入标签关联
            if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
                List<ActivityTag> activityTags = new ArrayList<>();
                for (Integer tagId : activity.getTagIds()) {
                    ActivityTag at = new ActivityTag();
                    at.setHdBh(activity.getHdBh()); // 使用自动生成的活动编号
                    at.setBqId(tagId);
                    activityTags.add(at);
                }
                if (!activityTags.isEmpty()) {
                    activityTagMapper.insertBatch(activityTags);
                }
            }
            return Result.success(activity);
        } else {
            return Result.error("创建活动失败");
        }
    }
}
