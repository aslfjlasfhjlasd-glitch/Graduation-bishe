package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
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
}
