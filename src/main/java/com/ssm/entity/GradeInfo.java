package com.ssm.entity;

import java.util.Date;

/**
 * 学生成绩实体类
 */
public class GradeInfo {
    private Integer gradeId;      // 成绩ID
    private Integer studentId;    // 学生ID
    private Integer activityId;   // 活动ID
    private Integer teacherId;    // 评分教师ID
    private Double score;         // 分数
    private String comment;       // 评语
    private Date gradeTime;       // 评分时间
    private Date updateTime;      // 更新时间

    // 构造方法
    public GradeInfo() {
    }

    // getter和setter方法
    public Integer getGradeId() {
        return gradeId;
    }

    public void setGradeId(Integer gradeId) {
        this.gradeId = gradeId;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public Integer getActivityId() {
        return activityId;
    }

    public void setActivityId(Integer activityId) {
        this.activityId = activityId;
    }

    public Integer getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Integer teacherId) {
        this.teacherId = teacherId;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getGradeTime() {
        return gradeTime;
    }

    public void setGradeTime(Date gradeTime) {
        this.gradeTime = gradeTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "GradeInfo{" +
                "gradeId=" + gradeId +
                ", studentId=" + studentId +
                ", activityId=" + activityId +
                ", teacherId=" + teacherId +
                ", score=" + score +
                ", comment='" + comment + '\'' +
                ", gradeTime=" + gradeTime +
                ", updateTime=" + updateTime +
                '}';
    }
}