package com.ssm.entity;

import java.util.Date;

/**
 * 公告实体类
 */
public class Notice {
    private Integer id;           // 公告ID
    private String title;         // 标题
    private String content;       // 内容
    private Integer publisherId;  // 发布者ID
    private Date publishTime;     // 发布时间
    private Date expiryTime;      // 到期时间
    private String status;        // 状态(draft/published/expired)
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(Integer publisherId) {
        this.publisherId = publisherId;
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public Date getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Date expiryTime) {
        this.expiryTime = expiryTime;
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

    @Override
    public String toString() {
        return "Notice{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", publisherId=" + publisherId +
                ", publishTime=" + publishTime +
                ", expiryTime=" + expiryTime +
                ", status='" + status + '\'' +
                '}';
    }
}