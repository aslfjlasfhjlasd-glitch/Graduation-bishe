package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.Student;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.mapper.StudentActivityMapper;
import com.university.volunteer.mapper.StudentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class StudentActivityService {

    @Autowired
    private StudentActivityMapper studentActivityMapper;

    @Autowired
    private StudentMapper studentMapper;

    public Result<List<ActivityRegistration>> getRegistrationStatus(String studentId) {
        List<ActivityRegistration> list = studentActivityMapper.selectRegistrationsByStudentId(studentId);
        return Result.success(list);
    }

    public Result<List<ActivityPerformanceDTO>> getActivityPerformance(String studentId) {
        List<ActivityPerformanceDTO> list = studentActivityMapper.selectPerformanceByStudentId(studentId);
        return Result.success(list);
    }

    /**
     * 活动报名
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> registerActivity(String studentId, Integer activityId) {
        // 1. 验证学生身份
        // 注意：这里 studentId 是 String，但 studentMapper.findStudentById 接受 Integer
        // 假设 studentId 总是数字字符串
        Student student;
        try {
            student = studentMapper.findStudentById(Integer.parseInt(studentId));
        } catch (NumberFormatException e) {
            return Result.error("无效的学生ID");
        }

        if (student == null) {
            return Result.error("学生不存在");
        }

        // 2. 验证活动是否存在
        VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
        if (activity == null) {
            return Result.error("活动不存在");
        }

        // 3. 检查活动状态
        // 动态计算活动状态
        Date now = new Date();
        String status = "未知";
        if (activity.getBmKssj() != null && now.before(activity.getBmKssj())) {
            status = "报名未开始";
        } else if (activity.getBmKssj() != null && activity.getBmJssj() != null && now.after(activity.getBmKssj()) && now.before(activity.getBmJssj())) {
            status = "报名中";
        } else if (activity.getHdKssj() != null && activity.getHdJssj() != null && now.after(activity.getHdKssj()) && now.before(activity.getHdJssj())) {
            status = "进行中";
        } else if (activity.getHdJssj() != null && now.after(activity.getHdJssj())) {
            status = "已结束";
        }

        if ("报名未开始".equals(status)) {
            return Result.error("报名尚未开始");
        } else if ("进行中".equals(status)) {
            return Result.error("活动正在进行中，无法报名");
        } else if ("已结束".equals(status)) {
            return Result.error("活动已结束，无法报名");
        } else if (!"报名中".equals(status)) {
            // 如果状态不明确（例如时间字段为空），根据业务需求决定是否允许报名
            // 这里为了安全起见，如果不处于明确的"报名中"状态，则禁止报名
            // 除非是某些特殊情况（如长期招募），需根据实际需求调整
            // 假设如果没有设置报名时间，则不允许报名
            return Result.error("不在报名时间内");
        }

        // 4. 检查是否重复报名
        int count = studentActivityMapper.countRegistration(studentId, activityId);
        if (count > 0) {
            return Result.error("您已报名该活动");
        }

        // 5. 检查剩余名额
        // 解析 ZM_RS (招募人数)
        int maxCapacity = 0;
        try {
            String zmRs = activity.getZmRs();
            if (zmRs != null) {
                // 尝试提取数字，例如 "35人" -> 35
                String numStr = zmRs.replaceAll("[^0-9]", "");
                if (!numStr.isEmpty()) {
                    maxCapacity = Integer.parseInt(numStr);
                }
            }
        } catch (Exception e) {
            // 解析失败，默认为0 (或者视为无限? 视业务而定，为了安全起见，如果解析不到数字，可能需要人工干预)
            // 这里简单处理：如果解析出数字 > 0，则校验；否则忽略名额限制(如 "若干")
        }

        int currentRegistered = studentActivityMapper.countRegistrationsByActivityId(activityId);
        if (maxCapacity > 0 && currentRegistered >= maxCapacity) {
            return Result.error("活动名额已满");
        }

        // 6. 构造报名记录
        ActivityRegistration registration = new ActivityRegistration();
        registration.setStudentId(studentId);
        registration.setStudentName(student.getXsXm());
        registration.setAcademyName(student.getSsXy());
        registration.setActivityId(String.valueOf(activityId));
        registration.setActivityName(activity.getHdMc());
        registration.setActivityTime(activity.getHdSj());
        registration.setActivityLocation(activity.getHdDd()); // 同步活动地点
        registration.setStatus("未审核"); // 初始状态
        // registration.setRegisterTime(new Date()); // 数据库没有该字段，暂不设置

        // 7. 插入数据库
        int rows = studentActivityMapper.insertRegistration(registration);
        if (rows <= 0) {
            return Result.error("报名失败");
        }

        // 8. 更新活动的已报名人数（YBM_RS字段）
        studentActivityMapper.updateRegisteredCount(activityId);

        return Result.success("报名成功");
    }

    /**
     * 取消报名
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> cancelRegistration(String studentId, Integer activityId) {
        // 1. 检查报名记录是否存在
        int count = studentActivityMapper.countRegistration(studentId, activityId);
        if (count == 0) {
            return Result.error("未找到报名记录");
        }

        // 2. 验证活动状态（可选：只允许在特定状态下取消）
        VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
        if (activity == null) {
            return Result.error("活动不存在");
        }

        // 检查活动是否已开始或已结束
        Date now = new Date();
        if (activity.getHdKssj() != null && now.after(activity.getHdKssj())) {
            return Result.error("活动已开始，无法取消报名");
        }

        // 3. 删除报名记录
        int rows = studentActivityMapper.deleteRegistration(studentId, activityId);
        if (rows <= 0) {
            return Result.error("取消报名失败");
        }

        // 4. 更新活动的已报名人数（YBM_RS字段）
        studentActivityMapper.updateRegisteredCount(activityId);

        return Result.success("取消报名成功");
    }
}
