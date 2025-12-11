package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Student;
import com.university.volunteer.entity.StudentTag;
import com.university.volunteer.entity.Tag;
import com.university.volunteer.mapper.StudentMapper;
import com.university.volunteer.mapper.StudentTagMapper;
import com.university.volunteer.mapper.TagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StudentService {

    @Autowired
    private StudentMapper studentMapper;
    
    @Autowired
    private StudentTagMapper studentTagMapper;
    
    @Autowired
    private TagMapper tagMapper;

    /**
     * 根据学号获取学生完整信息
     * @param studentId 学号
     * @return 学生信息
     */
    public Result<Student> getStudentProfile(Integer studentId) {
        try {
            Student student = studentMapper.findStudentById(studentId);
            if (student == null) {
                return Result.error("学生信息不存在");
            }
            // 不返回密码信息
            student.setXsMm(null);
            return Result.success(student);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取学生信息失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生个人信息（学生权限）
     * 仅允许更新：政治面貌、联系电话、兴趣标签、技能标签、个人简介
     * @param student 学生信息
     * @return 更新结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentProfile(Student student) {
        try {
            // 验证必填字段
            if (student.getXsXh() == null) {
                return Result.error("学号不能为空");
            }

            // 验证联系电话格式（如果提供）
            if (student.getXsDh() != null && !student.getXsDh().isEmpty()) {
                if (!student.getXsDh().matches("^1[3-9]\\d{9}$")) {
                    return Result.error("联系电话格式不正确");
                }
            }

            // 验证政治面貌（如果提供）
            if (student.getZzmm() != null && !student.getZzmm().isEmpty()) {
                String[] validPoliticalStatus = {"群众", "共青团员", "中共党员", "中共预备党员", "民主党派", "无党派人士"};
                boolean isValid = false;
                for (String status : validPoliticalStatus) {
                    if (status.equals(student.getZzmm())) {
                        isValid = true;
                        break;
                    }
                }
                if (!isValid) {
                    return Result.error("政治面貌选项不正确");
                }
            }

            // 处理标签更新（新增逻辑）
            if (student.getTagIds() != null && !student.getTagIds().isEmpty()) {
                // 1. 删除学生的所有旧标签关联
                studentTagMapper.deleteByStudentId(student.getXsXh());
                
                // 2. 批量插入新的标签关联
                List<StudentTag> studentTags = new ArrayList<>();
                for (Integer tagId : student.getTagIds()) {
                    StudentTag st = new StudentTag();
                    st.setXsXh(student.getXsXh());
                    st.setBqId(tagId);
                    studentTags.add(st);
                }
                if (!studentTags.isEmpty()) {
                    studentTagMapper.insertBatch(studentTags);
                }
                
                // 3. 更新冗余字段（用于兼容和快速查询）
                List<Tag> tags = tagMapper.findByIds(student.getTagIds());
                if (tags != null && !tags.isEmpty()) {
                    // 分离兴趣标签和技能标签
                    String xqBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 1)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    String jnBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 2)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    student.setXqBq(xqBq.isEmpty() ? null : xqBq);
                    student.setJnBq(jnBq.isEmpty() ? null : jnBq);
                }
            }

            // 更新学生基本信息
            int rows = studentMapper.updateStudentProfile(student);
            if (rows > 0) {
                return Result.success("个人信息更新成功");
            } else {
                return Result.error("更新失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新个人信息失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生完整信息（管理员权限）
     * @param student 学生信息
     * @return 更新结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentFullInfo(Student student) {
        try {
            if (student.getXsXh() == null) {
                return Result.error("学号不能为空");
            }

            // 处理标签更新（与updateStudentProfile相同的逻辑）
            if (student.getTagIds() != null && !student.getTagIds().isEmpty()) {
                studentTagMapper.deleteByStudentId(student.getXsXh());
                
                List<StudentTag> studentTags = new ArrayList<>();
                for (Integer tagId : student.getTagIds()) {
                    StudentTag st = new StudentTag();
                    st.setXsXh(student.getXsXh());
                    st.setBqId(tagId);
                    studentTags.add(st);
                }
                if (!studentTags.isEmpty()) {
                    studentTagMapper.insertBatch(studentTags);
                }
                
                List<Tag> tags = tagMapper.findByIds(student.getTagIds());
                if (tags != null && !tags.isEmpty()) {
                    String xqBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 1)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    String jnBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 2)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    student.setXqBq(xqBq.isEmpty() ? null : xqBq);
                    student.setJnBq(jnBq.isEmpty() ? null : jnBq);
                }
            }

            int rows = studentMapper.updateStudentFullInfo(student);
            if (rows > 0) {
                return Result.success("学生信息更新成功");
            } else {
                return Result.error("更新失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新学生信息失败: " + e.getMessage());
        }
    }
}