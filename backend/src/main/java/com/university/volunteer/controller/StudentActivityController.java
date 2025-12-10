package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.service.StudentActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/student")
public class StudentActivityController {

    @Autowired
    private StudentActivityService studentActivityService;

    @GetMapping("/registrations")
    public Result<List<ActivityRegistration>> getRegistrationStatus(@RequestParam String studentId) {
        return studentActivityService.getRegistrationStatus(studentId);
    }

    @GetMapping("/performance")
    public Result<List<ActivityPerformanceDTO>> getActivityPerformance(@RequestParam String studentId) {
        return studentActivityService.getActivityPerformance(studentId);
    }

    /**
     * 报名参加活动
     *
     * @param requestBody 包含 studentId 和 activityId
     */
    @PostMapping("/activity/register")
    public Result<String> registerActivity(@RequestBody Map<String, Object> requestBody) {
        String studentId = (String) requestBody.get("studentId");
        Integer activityId = (Integer) requestBody.get("activityId");

        if (studentId == null || activityId == null) {
            return Result.error("参数不完整");
        }

        return studentActivityService.registerActivity(studentId, activityId);
    }
}
