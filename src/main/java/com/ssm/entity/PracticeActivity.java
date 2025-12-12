package com.ssm.entity;

import java.util.Date;

/**
 * 社会实践活动实体类
 */
public class PracticeActivity {
    private Integer id;               // 活动ID（数据库主键）
    private Integer activityId;       // 活动ID
    private String activityName;      // 活动名称
    private String description;       // 活动描述
    private String location;          // 活动地点
    private Date startTime;           // 开始时间
    private Date endTime;             // 结束时间
    private Integer maxParticipants;  // 最大参与人数
    private Integer currentParticipants; // 当前参与人数
    private String status;            // 状态（recruiting/ongoing/finished）
    private Date createTime;          // 创建时间
    private Date updateTime;          // 更新时间
    private String activityType;     // 活动类型
    private String responsiblePerson; // 负责人

    // 构造方法
    public PracticeActivity() {
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

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Integer getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(Integer maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public Integer getCurrentParticipants() {
        return currentParticipants;
    }

    public void setCurrentParticipants(Integer currentParticipants) {
        this.currentParticipants = currentParticipants;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getResponsiblePerson() {
        return responsiblePerson;
    }

    public void setResponsiblePerson(String responsiblePerson) {
        this.responsiblePerson = responsiblePerson;
    }

    @Override
    public String toString() {
        return "PracticeActivity{" +
                "activityId=" + activityId +
                ", activityName='" + activityName + '\'' +
                ", location='" + location + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", maxParticipants=" + maxParticipants +
                ", currentParticipants=" + currentParticipants +
                ", status='" + status + '\'' +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
