package com.ssm.entity;

import java.util.Date;

/**
 * 日常任务实体类
 */
public class DailyTask {
    private Integer taskId;       // 任务ID
    private Integer studentId;    // 学生ID
    private Integer activityId;   // 关联活动ID
    private Date taskDate;        // 任务日期
    private String title;         // 任务标题
    private String content;       // 任务内容
    private String status;        // 状态("pending":未完成, "completed":已完成)
    private Integer priority;     // 优先级(0-5)
    private Date completedTime;   // 完成时间
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间
    
    // 关联对象
    private PracticeActivity activity;

    // 构造方法
    public DailyTask() {
    }

    // getter和setter方法
    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
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
    
    public PracticeActivity getActivity() {
        return activity;
    }

    public void setActivity(PracticeActivity activity) {
        this.activity = activity;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getTaskDate() {
        return taskDate;
    }

    public void setTaskDate(Date taskDate) {
        this.taskDate = taskDate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Date getCompletedTime() {
        return completedTime;
    }

    public void setCompletedTime(Date completedTime) {
        this.completedTime = completedTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "DailyTask{" +
                "taskId=" + taskId +
                ", studentId=" + studentId +
                ", activityId=" + activityId +
                ", taskDate=" + taskDate +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", status='" + status + '\'' +
                ", priority=" + priority +
                ", completedTime=" + completedTime +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}