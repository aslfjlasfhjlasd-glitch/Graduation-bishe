package com.university.volunteer.dto;

public class ActivityPerformanceDTO {
    /**
     * 活动编号 (from t_zyhdbmb)
     */
    private String activityId;

    /**
     * 活动名称 (from t_zyhdbmb)
     */
    private String activityName;

    /**
     * 活动时间 (from t_zyhdbmb)
     */
    private String activityTime;

    /**
     * 参与活动时长 (from t_zyhdbmb)
     */
    private Float duration;

    /**
     * 获得学分 (from t_zyhdbmb)
     */
    private Float credits;

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

    public Float getDuration() {
        return duration;
    }

    public void setDuration(Float duration) {
        this.duration = duration;
    }

    public Float getCredits() {
        return credits;
    }

    public void setCredits(Float credits) {
        this.credits = credits;
    }
}
