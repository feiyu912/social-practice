package com.ssm.entity;

import java.util.Date;

/**
 * 系统日志实体类
 */
public class SystemLog {
    private Integer id;             // 日志ID
    private Integer userId;         // 用户ID
    private String username;        // 用户名
    private String operationType;   // 操作类型
    private String operationDesc;   // 操作描述
    private String ipAddress;       // IP地址
    private Date operationTime;     // 操作时间

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getOperationDesc() {
        return operationDesc;
    }

    public void setOperationDesc(String operationDesc) {
        this.operationDesc = operationDesc;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Date getOperationTime() {
        return operationTime;
    }

    public void setOperationTime(Date operationTime) {
        this.operationTime = operationTime;
    }

    @Override
    public String toString() {
        return "SystemLog{" +
                "id=" + id +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", operationType='" + operationType + '\'' +
                ", operationDesc='" + operationDesc + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", operationTime=" + operationTime +
                '}';
    }
}