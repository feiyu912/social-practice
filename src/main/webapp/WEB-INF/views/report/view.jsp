<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看实践报告 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background-color: #1890ff; color: white; padding: 15px 20px; margin-bottom: 20px; }
        .report-container { background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { margin-bottom: 20px; color: #333; }
        .info-row { margin-bottom: 15px; padding: 10px 0; border-bottom: 1px solid #f0f0f0; }
        .info-row label { font-weight: bold; color: #555; display: inline-block; width: 100px; }
        .info-row span { color: #333; }
        .content-section { margin-top: 20px; padding: 15px; background-color: #fafafa; border-radius: 4px; }
        .content-section h3 { margin-bottom: 10px; color: #333; }
        .content-section p { line-height: 1.8; color: #666; white-space: pre-wrap; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .status-pending { color: #faad14; font-weight: bold; }
        .status-reviewed { color: #52c41a; font-weight: bold; }
        .feedback-section { margin-top: 20px; padding: 15px; background-color: #e6f7ff; border-radius: 4px; border: 1px solid #91d5ff; }
    </style>
</head>
<body>
    <div class="header">
        <h1>查看实践报告</h1>
    </div>
    
    <div class="container">
        <div class="report-container">
            <h2>${report.title}</h2>
            
            <div class="info-row">
                <label>报告ID:</label>
                <span>${report.reportId}</span>
            </div>
            
            <div class="info-row">
                <label>活动ID:</label>
                <span>${report.activityId}</span>
            </div>
            
            <div class="info-row">
                <label>状态:</label>
                <span>
                    <c:choose>
                        <c:when test="${report.status == 'pending'}">
                            <span class="status-pending">待审核</span>
                        </c:when>
                        <c:when test="${report.status == 'reviewed'}">
                            <span class="status-reviewed">已审核</span>
                        </c:when>
                        <c:otherwise>${report.status}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-row">
                <label>提交时间:</label>
                <span>
                    <c:if test="${report.submitTime != null}">
                        <fmt:formatDate value="${report.submitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </c:if>
                </span>
            </div>
            
            <div class="content-section">
                <h3>报告内容</h3>
                <p>${report.content}</p>
            </div>
            
            <c:if test="${not empty report.attachment}">
                <div class="info-row">
                    <label>附件:</label>
                    <span><a href="${report.attachment}" target="_blank">查看附件</a></span>
                </div>
            </c:if>
            
            <c:if test="${not empty report.feedback}">
                <div class="feedback-section">
                    <h3>教师反馈</h3>
                    <p>${report.feedback}</p>
                </div>
            </c:if>
            
            <div style="margin-top: 20px;">
                <a href="/practiceReport/list" class="btn btn-secondary">返回列表</a>
            </div>
        </div>
    </div>
</body>
</html>
