package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Student;
import com.university.volunteer.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    /**
     * 获取学生个人信息
     * @param studentId 学号
     * @return 学生信息
     */
    @GetMapping("/profile")
    public Result<Student> getProfile(@RequestParam Integer studentId) {
        return studentService.getStudentProfile(studentId);
    }

    /**
     * 更新学生个人信息（学生权限）
     * 仅允许更新：政治面貌、联系电话、兴趣标签、技能标签、个人简介
     * @param student 学生信息
     * @return 更新结果
     */
    @PutMapping("/profile")
    public Result<String> updateProfile(@RequestBody Student student) {
        return studentService.updateStudentProfile(student);
    }

    /**
     * 更新学生完整信息（管理员权限）
     * @param student 学生信息
     * @return 更新结果
     */
    @PutMapping("/profile/full")
    public Result<String> updateFullProfile(@RequestBody Student student) {
        return studentService.updateStudentFullInfo(student);
    }

    /**
     * 修改学生密码
     * @param requestBody 包含 studentId, oldPassword, newPassword
     * @return 修改结果
     */
    @PutMapping("/password")
    public Result<String> updatePassword(@RequestBody java.util.Map<String, Object> requestBody) {
        Integer studentId = (Integer) requestBody.get("studentId");
        String oldPassword = (String) requestBody.get("oldPassword");
        String newPassword = (String) requestBody.get("newPassword");

        if (studentId == null || oldPassword == null || newPassword == null) {
            return Result.error("参数不完整");
        }

        return studentService.updatePassword(studentId, oldPassword, newPassword);
    }
}