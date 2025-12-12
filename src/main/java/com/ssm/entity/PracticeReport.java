package com.ssm.entity;

import java.util.Date;

/**
 * 实践报告实体类
 */
public class PracticeReport {
    private Integer reportId;     // 报告ID
    private Integer studentId;    // 学生ID
    private Integer activityId;   // 活动ID
    private String title;         // 报告标题
    private String content;       // 报告内容
    private String attachment;    // 附件路径
    private String status;
    private String feedback;      // 教师反馈
    private Date submitTime;      // 提交时间
    private Date updateTime;      // 更新时间

    // 构造方法
    public PracticeReport() {
    }

    // getter和setter方法
    public Integer getReportId() {
        return reportId;
    }

    public void setReportId(Integer reportId) {
        this.reportId = reportId;
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

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public Date getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(Date submitTime) {
        this.submitTime = submitTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "PracticeReport{" +
                "reportId=" + reportId +
                ", studentId=" + studentId +
                ", activityId=" + activityId +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", submitTime=" + submitTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
