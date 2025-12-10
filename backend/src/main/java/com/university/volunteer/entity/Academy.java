package com.university.volunteer.entity;

/**
 * 学院实体类
 * 对应数据库表: t_xy
 */
public class Academy {
    // 账号 (主键)
    private String xyZh;
    // 密码
    private String xyMm;
    // 学院名称
    private String xyMc;

    public String getXyZh() {
        return xyZh;
    }

    public void setXyZh(String xyZh) {
        this.xyZh = xyZh;
    }

    public String getXyMm() {
        return xyMm;
    }

    public void setXyMm(String xyMm) {
        this.xyMm = xyMm;
    }

    public String getXyMc() {
        return xyMc;
    }

    public void setXyMc(String xyMc) {
        this.xyMc = xyMc;
    }
}
