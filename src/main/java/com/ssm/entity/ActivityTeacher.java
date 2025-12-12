package com.ssm.entity;

/**
 * 活动教师关联表实体类
 * 用于存储社会实践活动的负责教师信息
 */
public class ActivityTeacher {
    private Integer id;           // 主键ID
    private Integer activityId;   // 活动ID
    private Integer teacherId;    // 教师ID

    // 构造方法
    public ActivityTeacher() {
    }

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    @Override
    public String toString() {
        return "ActivityTeacher{" +
                "id=" + id +
                ", activityId=" + activityId +
                ", teacherId=" + teacherId +
                '}';
    }
}