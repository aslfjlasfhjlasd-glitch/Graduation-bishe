package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.service.DepartmentHeadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/head")
public class DepartmentHeadController {

    @Autowired
    private DepartmentHeadService departmentHeadService;

    /**
     * 审核活动报名
     * @param requestBody 包含 registrationId 和 status
     */
    @PostMapping("/audit/registration")
    public Result<String> auditRegistration(@RequestBody Map<String, Object> requestBody) {
        Integer registrationId = (Integer) requestBody.get("registrationId");
        String status = (String) requestBody.get("status");

        if (registrationId == null || status == null) {
            return Result.error("参数不完整");
        }

        if (!"已审核通过".equals(status) && !"已拒绝".equals(status)) {
            return Result.error("无效的状态值");
        }

        return departmentHeadService.auditRegistration(registrationId, status);
    }

    /**
     * 获取负责人信息
     * @param username 用户账号
     */
    @GetMapping("/info/{username}")
    public Result<Map<String, Object>> getHeadInfo(@PathVariable String username) {
        return departmentHeadService.getHeadInfo(username);
    }

    /**
     * 更新负责人信息
     * @param requestBody 包含 username, name, phone
     */
    @PutMapping("/info")
    public Result<String> updateHeadInfo(@RequestBody Map<String, String> requestBody) {
        String username = requestBody.get("username");
        String name = requestBody.get("name");
        String phone = requestBody.get("phone");

        if (username == null || name == null || phone == null) {
            return Result.error("参数不完整");
        }

        return departmentHeadService.updateHeadInfo(username, name, phone);
    }

    /**
     * 获取负责人发起的活动列表
     * @param username 负责人账号
     */
    @GetMapping("/activities/{username}")
    public Result<?> getActivitiesByHead(@PathVariable String username) {
        return departmentHeadService.getActivitiesByHead(username);
    }

    /**
     * 获取负责人管理的报名记录列表
     * @param username 负责人账号
     */
    @GetMapping("/registrations/{username}")
    public Result<?> getRegistrationsByHead(@PathVariable String username) {
        return departmentHeadService.getRegistrationsByHead(username);
    }

    /**
     * 更新活动信息
     * @param activity 活动信息
     */
    @PutMapping("/activity")
    public Result<String> updateActivity(@RequestBody VolunteerActivity activity) {
        return departmentHeadService.updateActivity(activity);
    }

    /**
     * 删除活动
     * @param activityId 活动编号
     */
    @DeleteMapping("/activity/{activityId}")
    public Result<String> deleteActivity(@PathVariable Integer activityId) {
        return departmentHeadService.deleteActivity(activityId);
    }

    /**
     * 下架活动
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/unpublish")
    public Result<String> unpublishActivity(@PathVariable Integer activityId) {
        return departmentHeadService.unpublishActivity(activityId);
    }
}
