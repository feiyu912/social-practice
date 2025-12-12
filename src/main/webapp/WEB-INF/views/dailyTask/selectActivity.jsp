<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>选择活动 - 学生社会实践管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .content {
            padding: 20px;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .activity-list {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .activity-item {
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .activity-item:hover {
            border-color: #1890ff;
            background-color: #f0f8ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .activity-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .activity-info {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .activity-link {
            display: block;
            text-decoration: none;
            color: inherit;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-link:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="content">
        <h2 class="page-title">选择活动查看学生任务</h2>
        
        <div class="activity-list">
            <c:choose>
                <c:when test="${empty activities}">
                    <div class="empty-message">
                        <p>暂无活动记录</p>
                        <a href="/activity/list" class="back-link">查看活动列表</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${activities}" var="activity">
                        <a href="/dailyTask/viewByActivity?activityId=${activity.id}" class="activity-link">
                            <div class="activity-item">
                                <div class="activity-title">${activity.activityName != null ? activity.activityName : '未命名活动'}</div>
                                <div class="activity-info">活动ID: ${activity.id}</div>
                                <c:if test="${activity.startTime != null}">
                                    <div class="activity-info">开始时间: <fmt:formatDate value="${activity.startTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                                </c:if>
                                <c:if test="${activity.endTime != null}">
                                    <div class="activity-info">结束时间: <fmt:formatDate value="${activity.endTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                                </c:if>
                                <c:if test="${activity.status != null}">
                                    <div class="activity-info">状态: 
                                        <c:choose>
                                            <c:when test="${activity.status == 'recruiting'}">招募中</c:when>
                                            <c:when test="${activity.status == 'ongoing'}">进行中</c:when>
                                            <c:when test="${activity.status == 'finished'}">已结束</c:when>
                                            <c:otherwise>${activity.status}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="/index" class="back-link">返回首页</a>
        </div>
    </div>
</body>
</html>

