package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Academy;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.DepartmentHead;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.mapper.AcademyMapper;
import com.university.volunteer.mapper.DepartmentHeadMapper;
import com.university.volunteer.mapper.StudentActivityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DepartmentHeadService {

    @Autowired
    private DepartmentHeadMapper departmentHeadMapper;

    @Autowired
    private AcademyMapper academyMapper;

    @Autowired
    private StudentActivityMapper studentActivityMapper;

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
        return Result.success(activities);
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
}
