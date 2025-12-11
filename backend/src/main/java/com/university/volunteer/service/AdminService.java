package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.mapper.StudentActivityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminService {

    @Autowired
    private StudentActivityMapper studentActivityMapper;

    /**
     * 获取所有活动列表（管理员可以查看除"待申报"外的所有活动）
     */
    public Result<List<VolunteerActivity>> getAllActivities() {
        try {
            List<VolunteerActivity> activities = studentActivityMapper.findAllActivities();
            
            // 过滤掉"待申报"状态的活动，保留其他所有状态
            List<VolunteerActivity> visibleActivities = activities.stream()
                    .filter(activity -> !"待申报".equals(activity.getFbZt()))
                    .collect(java.util.stream.Collectors.toList());
            
            // 动态更新活动状态
            java.util.Date now = new java.util.Date();
            for (VolunteerActivity activity : visibleActivities) {
                String newStatus = calculateActivityStatus(activity, now);
                // 如果状态发生变化，更新数据库
                if (!newStatus.equals(activity.getHdZt())) {
                    activity.setHdZt(newStatus);
                    studentActivityMapper.updateActivityStatus(activity.getHdBh(), newStatus);
                }
            }
            
            return Result.success(visibleActivities);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取活动列表失败：" + e.getMessage());
        }
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
     * 发布活动（将"待发布"状态的活动改为"已发布"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> publishActivity(Integer activityId) {
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
                return Result.error("只能发布状态为'待发布'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已发布");
            if (rows > 0) {
                return Result.success("活动已发布");
            } else {
                return Result.error("发布失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("发布失败：" + e.getMessage());
        }
    }

    /**
     * 下架活动（将"已发布"状态的活动改为"已下架"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> unpublishActivity(Integer activityId) {
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
            if (!"已发布".equals(currentStatus)) {
                return Result.error("只能下架状态为'已发布'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已下架");
            if (rows > 0) {
                return Result.success("活动已下架");
            } else {
                return Result.error("下架失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("下架失败：" + e.getMessage());
        }
    }
}