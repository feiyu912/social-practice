package com.ssm.entity;

import java.util.Date;

/**
 * 小组实体类
 */
public class GroupInfo {
    private Integer groupId;      // 小组ID
    private Integer activityId;   // 活动ID
    private String groupName;     // 小组名称
    private Integer leaderId;     // 组长ID(学生ID)
    private Integer memberCount;  // 成员数量
    private Integer status;       // 状态(0:未开始, 1:进行中, 2:已完成)
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间
    private PracticeActivity activity; // 关联的活动对象

    // 构造方法
    public GroupInfo() {
    }

    // getter和setter方法
    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getActivityId() {
        return activityId;
    }

    public void setActivityId(Integer activityId) {
        this.activityId = activityId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public Integer getLeaderId() {
        return leaderId;
    }

    public void setLeaderId(Integer leaderId) {
        this.leaderId = leaderId;
    }

    public Integer getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(Integer memberCount) {
        this.memberCount = memberCount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
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
    
    public PracticeActivity getActivity() {
        return activity;
    }

    public void setActivity(PracticeActivity activity) {
        this.activity = activity;
    }

    @Override
    public String toString() {
        return "GroupInfo{" +
                "groupId=" + groupId +
                ", activityId=" + activityId +
                ", groupName='" + groupName + '\'' +
                ", leaderId=" + leaderId +
                ", memberCount=" + memberCount +
                ", status=" + status +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}