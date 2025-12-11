package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    /**
     * 获取所有活动列表（管理员可以查看所有活动）
     */
    @GetMapping("/activities")
    public Result<List<VolunteerActivity>> getAllActivities() {
        return adminService.getAllActivities();
    }

    /**
     * 发布活动（将"已申报"状态的活动改为"已发布"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/publish")
    public Result<String> publishActivity(@PathVariable Integer activityId) {
        return adminService.publishActivity(activityId);
    }

    /**
     * 下架活动（将"已发布"状态的活动改为"已下架"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/unpublish")
    public Result<String> unpublishActivity(@PathVariable Integer activityId) {
        return adminService.unpublishActivity(activityId);
    }
}