package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    /**
     * 获取各学院参与度统计
     */
    @GetMapping("/academy-stats")
    public Result<List<Map<String, Object>>> getAcademyStats() {
        return dashboardService.getAcademyStats();
    }

    @GetMapping("/activities")
    public Result<List<Map<String, Object>>> listActivities() {
        return dashboardService.listActivities();
    }

    @GetMapping("/activities/{id}")
    public Result<Map<String, Object>> getActivityDetail(@PathVariable("id") Integer id) {
        return dashboardService.getActivityDetail(id);
    }
}
