package com.ssm.entity;

import java.util.Date;

/**
 * 学生参与活动实体类
 */
public class StudentActivity {
    private Integer id;           // 主键ID
    private Integer studentId;    // 学生ID
    private Integer activityId;   // 活动ID
    private Integer groupId;      // 小组ID，可以为null表示个人参与
    private Integer status;       // 状态(0:待审核, 1:已通过, 2:已拒绝)
    private Date joinTime;        // 加入时间
    private Date updateTime;      // 更新时间
    private PracticeActivity activity; // 关联的活动对象
    private Student student;      // 关联的学生对象

    // 构造方法
    public StudentActivity() {
    }

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getJoinTime() {
        return joinTime;
    }

    public void setJoinTime(Date joinTime) {
        this.joinTime = joinTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public PracticeActivity getActivity() {
        return activity;
    }

    public void setActivity(PracticeActivity activity) {
        this.activity = activity;
    }
    
    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    @Override
    public String toString() {
        return "StudentActivity{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", activityId=" + activityId +
                ", groupId=" + groupId +
                ", status=" + status +
                ", joinTime=" + joinTime +
                ", updateTime=" + updateTime +
                '}';
    }
}