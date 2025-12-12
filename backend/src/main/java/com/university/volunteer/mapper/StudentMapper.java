package com.university.volunteer.mapper;

import com.university.volunteer.entity.Student;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 学生数据访问层
 */
@Mapper
public interface StudentMapper {
    
    // 根据用户名查询学生（登录用）
    Student findByUsername(@Param("username") String username);
    
    // 根据学号查询学生完整信息
    Student findStudentById(@Param("studentId") Integer studentId);
    
    // 更新学生信息（学生权限）
    int updateStudentProfile(Student student);
    
    // 更新学生完整信息（管理员权限）
    int updateStudentFullInfo(Student student);
    
    // 更新学生密码
    int updatePassword(@Param("studentId") Integer studentId, @Param("newPassword") String newPassword);
}
