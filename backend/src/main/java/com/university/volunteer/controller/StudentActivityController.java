package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.VolunteerActivity;
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

    /**
     * 公假单（已确认）列表
     */
    @GetMapping("/leave-permits")
    public Result<List<ActivityRegistration>> getLeavePermits(@RequestParam String studentId) {
        return studentActivityService.getConfirmedLeavePermits(studentId);
    }

    /**
     * 公假单下载
     */
    @GetMapping("/leave-permits/{registrationId}/download")
    public org.springframework.http.ResponseEntity<byte[]> downloadLeavePermit(@PathVariable Integer registrationId,
                                                                              @RequestParam String studentId) {
        return studentActivityService.downloadLeavePermit(studentId, registrationId);
    }

    /**
     * 证明（已确认）列表
     */
    @GetMapping("/certificates")
    public Result<List<ActivityRegistration>> getCertificates(@RequestParam String studentId) {
        return studentActivityService.getConfirmedCertificates(studentId);
    }

    /**
     * 证明下载
     */
    @GetMapping("/certificates/{registrationId}/download")
    public org.springframework.http.ResponseEntity<byte[]> downloadCertificate(@PathVariable Integer registrationId,
                                                                              @RequestParam String studentId) {
        return studentActivityService.downloadCertificate(studentId, registrationId);
    }

    /**
     * 学生活动评分
     */
    @PutMapping("/performance/{registrationId}/rate")
    public Result<String> rateActivity(@PathVariable Integer registrationId,
                                       @RequestBody Map<String, Object> body) {
        String studentId = (String) body.get("studentId");
        Integer rating = body.get("rating") == null ? null : Integer.parseInt(body.get("rating").toString());
        return studentActivityService.rateActivity(studentId, registrationId, rating);
    }

    @GetMapping("/performance")
    public Result<List<ActivityPerformanceDTO>> getActivityPerformance(@RequestParam String studentId) {
        return studentActivityService.getActivityPerformance(studentId);
    }

    /**
     * 活动详情（学生端查看）
     */
    @GetMapping("/activity/{activityId}")
    public Result<VolunteerActivity> getActivityDetail(@PathVariable Integer activityId) {
        return studentActivityService.getActivityDetail(activityId);
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

    /**
     * 取消报名
     *
     * @param requestBody 包含 studentId 和 activityId
     */
    @PostMapping("/activity/cancel")
    public Result<String> cancelRegistration(@RequestBody Map<String, Object> requestBody) {
        String studentId = (String) requestBody.get("studentId");
        Integer activityId = (Integer) requestBody.get("activityId");

        if (studentId == null || activityId == null) {
            return Result.error("参数不完整");
        }

        return studentActivityService.cancelRegistration(studentId, activityId);
    }
}
