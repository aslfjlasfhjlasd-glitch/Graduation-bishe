package com.university.volunteer.entity;

import java.util.Date;

public class ActivityRegistration {
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
     * 报名状态：未审核；已审核 (BM_ZT)
     */
    private String status;

    /**
     * 报名时间 (BM_SJ) - 新增字段
     */
    private Date registerTime;

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

    public Date getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(Date registerTime) {
        this.registerTime = registerTime;
    }
}
