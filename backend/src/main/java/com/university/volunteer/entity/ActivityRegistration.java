package com.university.volunteer.entity;

import java.util.Date;

public class ActivityRegistration {
    /**
     * 记录ID (ID)
     */
    private Integer id;

    /**
     * 学生学号 (XS_XH)
     */
    private String studentId;

    /**
     * 学生姓名 (XS_XM)
     */
    private String studentName;

    /**
     * 所属学院 (SS_XY)
     */
    private String academyName;

    /**
     * 已报名活动编号 (HD_BH)
     */
    private String activityId;

    /**
     * 已报名活动名称 (HD_MC)
     */
    private String activityName;

    /**
     * 已报名活动的活动时间 (HD_SJ)
     */
    private String activityTime;

    /**
     * 已报名活动的活动地点 (HD_DD)
     */
    private String activityLocation;

    /**
     * 报名状态：未审核；已审核通过；已拒绝 (BM_ZT)
     */
    private String status;

    /**
     * 签到时间 (QD_SJ)
     */
    private Date checkInTime;

    /**
     * 签退时间 (QT_SJ)
     */
    private Date checkOutTime;

    /**
     * 考勤状态: 0-未签 1-正常 2-迟到 3-缺勤 (QD_ZT)
     */
    private Integer attendanceStatus;

    /**
     * 参与活动时长 (HD_SC)
     */
    private Integer duration;

    /**
     * 获得学分 (HD_XF)
     */
    private Integer credits;

    /**
     * 志愿者评价 (ZYZ_PJ)
     */
    private String evaluation;

    /**
     * 评分(1-5分) (PF)
     */
    private Integer rating;

    /**
     * 报名时间 (BM_SJ) - 新增字段
     */
    private Date registerTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getAcademyName() {
        return academyName;
    }

    public void setAcademyName(String academyName) {
        this.academyName = academyName;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(String activityTime) {
        this.activityTime = activityTime;
    }

    public String getActivityLocation() {
        return activityLocation;
    }

    public void setActivityLocation(String activityLocation) {
        this.activityLocation = activityLocation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Date getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Date checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public Integer getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(Integer attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Integer getCredits() {
        return credits;
    }

    public void setCredits(Integer credits) {
        this.credits = credits;
    }

    public String getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(String evaluation) {
        this.evaluation = evaluation;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public Date getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(Date registerTime) {
        this.registerTime = registerTime;
    }
}
