<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的成绩 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .header { background-color: #1890ff; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid white; border-radius: 4px; }
        .content { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .page-title { font-size: 24px; margin-bottom: 20px; color: #333; }
        
        .grade-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; overflow: hidden; }
        .grade-card-header { background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%); color: white; padding: 20px; }
        .grade-card-header h3 { margin: 0 0 10px 0; font-size: 18px; }
        .grade-card-header p { margin: 0; opacity: 0.9; font-size: 14px; }
        
        .grade-card-body { padding: 20px; }
        .score-display { text-align: center; padding: 30px 0; }
        .score-number { font-size: 64px; font-weight: bold; color: #1890ff; }
        .score-label { color: #666; margin-top: 10px; }
        
        .grade-details { margin-top: 20px; }
        .grade-details h4 { margin-bottom: 15px; color: #333; font-size: 16px; border-bottom: 1px solid #f0f0f0; padding-bottom: 10px; }
        
        .teacher-grade { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px dashed #f0f0f0; }
        .teacher-grade:last-child { border-bottom: none; }
        .teacher-name { color: #666; }
        .teacher-score { font-weight: bold; color: #52c41a; font-size: 18px; }
        
        .comments-section { background: #fafafa; padding: 15px; border-radius: 8px; margin-top: 15px; }
        .comments-section h5 { margin-bottom: 10px; color: #333; }
        .comments-text { color: #666; line-height: 1.8; font-size: 14px; }
        
        .empty-state { text-align: center; padding: 80px 20px; }
        .empty-state .icon { font-size: 64px; margin-bottom: 20px; }
        .empty-state p { color: #999; font-size: 16px; }
        
        .score-excellent { color: #52c41a; }
        .score-good { color: #1890ff; }
        .score-pass { color: #faad14; }
        .score-fail { color: #ff4d4f; }
    </style>
</head>
<body>
    <div class="header">
        <h1>我的成绩</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">实践活动成绩</h2>
        
        <c:choose>
            <c:when test="${empty gradeList}">
                <div class="empty-state">
                    <div class="icon">📊</div>
                    <p>暂无成绩记录</p>
                    <p style="margin-top:10px;color:#999;font-size:14px;">已结束的活动且教师评分后才会显示成绩</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${gradeList}" var="item">
                    <div class="grade-card">
                        <div class="grade-card-header">
                            <h3>${item.activity.activityName}</h3>
                            <p>
                                <c:if test="${item.activity.startTime != null}">
                                    <fmt:formatDate value="${item.activity.startTime}" pattern="yyyy-MM-dd"/> ~ 
                                    <fmt:formatDate value="${item.activity.endTime}" pattern="yyyy-MM-dd"/>
                                </c:if>
                                | 地点：${item.activity.location != null ? item.activity.location : '未设置'}
                            </p>
                        </div>
                        <div class="grade-card-body">
                            <div class="score-display">
                                <div class="score-number 
                                    <c:choose>
                                        <c:when test="${item.avgScore >= 90}">score-excellent</c:when>
                                        <c:when test="${item.avgScore >= 75}">score-good</c:when>
                                        <c:when test="${item.avgScore >= 60}">score-pass</c:when>
                                        <c:otherwise>score-fail</c:otherwise>
                                    </c:choose>
                                ">
                                    <fmt:formatNumber value="${item.avgScore}" pattern="#0.0"/>
                                </div>
                                <div class="score-label">平均成绩</div>
                            </div>
                            
                            <c:if test="${not empty item.grades}">
                                <div class="grade-details">
                                    <h4>各教师评分明细</h4>
                                    <c:forEach items="${item.grades}" var="grade">
                                        <div class="teacher-grade">
                                            <span class="teacher-name">
                                                教师评分
                                            </span>
                                            <span class="teacher-score">
                                                <fmt:formatNumber value="${grade.score}" pattern="#0.0"/>分
                                            </span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty item.comments}">
                                <div class="comments-section">
                                    <h5>教师评语</h5>
                                    <div class="comments-text">${item.comments}</div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
