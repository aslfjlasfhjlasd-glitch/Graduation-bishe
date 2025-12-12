package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.VolunteerAuditDTO;
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

    /**
     * 获取志愿者审核列表
     * @param status 审核状态：未审核/已审核通过/已拒绝，为空则查询所有状态
     */
    @GetMapping("/reviews")
    public Result<List<VolunteerAuditDTO>> getVolunteerReviews(@RequestParam(required = false) String status) {
        return adminService.getVolunteerReviews(status);
    }

    /**
     * 根据ID获取志愿者审核详情
     * @param registrationId 报名ID
     */
    @GetMapping("/reviews/{registrationId}")
    public Result<VolunteerAuditDTO> getVolunteerReviewDetail(@PathVariable Integer registrationId) {
        return adminService.getVolunteerReviewDetail(registrationId);
    }

    /**
     * 审核通过志愿者报名
     * @param registrationId 报名ID
     */
    @PutMapping("/reviews/{registrationId}/approve")
    public Result<String> approveVolunteerRegistration(@PathVariable Integer registrationId) {
        return adminService.approveVolunteerRegistration(registrationId);
    }

    /**
     * 审核拒绝志愿者报名
     * @param registrationId 报名ID
     * @param payload 携带拒绝原因的请求体
     */
    @PutMapping("/reviews/{registrationId}/reject")
    public Result<String> rejectVolunteerRegistration(@PathVariable Integer registrationId,
                                                      @RequestBody(required = false) java.util.Map<String, String> payload) {
        String reason = payload != null ? payload.getOrDefault("reason", null) : null;
        return adminService.rejectVolunteerRegistration(registrationId, reason);
    }
}