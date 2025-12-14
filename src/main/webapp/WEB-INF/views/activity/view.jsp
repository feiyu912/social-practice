<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>活动详情 - 学生社会实践管理系统</title>
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
        .header {
            background-color: #1890ff;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 20px;
        }
        .header .user-info {
            font-size: 14px;
        }
        .header .user-info a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            padding: 5px 10px;
            border: 1px solid white;
            border-radius: 4px;
        }
        .header .user-info a:hover {
            background-color: rgba(255,255,255,0.2);
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .page-title {
            margin-bottom: 30px;
            color: #333;
            text-align: center;
        }
        .activity-info {
            margin-bottom: 30px;
        }
        .info-item {
            margin-bottom: 15px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }
        .info-value {
            color: #333;
            font-size: 16px;
        }
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin: 0 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #1890ff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #40a9ff;
        }
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
        }
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-recruiting {
            background-color: #fffbe6;
            color: #faad14;
            border: 1px solid #ffe58f;
        }
        .status-ongoing {
            background-color: #f6ffed;
            color: #52c41a;
            border: 1px solid #b7eb8f;
        }
        .status-finished {
            background-color: #f9f0ff;
            color: #722ed1;
            border: 1px solid #d3adf7;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>学生社会实践管理系统</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <h2 class="page-title">活动详情</h2>
        
        <div class="activity-info">
            <div class="info-item">
                <div class="info-label">活动名称：</div>
                <div class="info-value">${activity.activityName}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">活动类型：</div>
                <div class="info-value">${activity.activityType}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">活动时间：</div>
                <div class="info-value">
                    <c:if test="${not empty activity.startTime && not empty activity.endTime}">
                        ${activity.startTime} 至 ${activity.endTime}
                    </c:if>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">活动地点：</div>
                <div class="info-value">${activity.location}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">负责人：</div>
                <div class="info-value">${activity.responsiblePerson}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">参与人数：</div>
                <div class="info-value">${activity.currentParticipants} / ${activity.maxParticipants}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">活动状态：</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${activity.status eq 'recruiting'}">
                            <span class="status-badge status-recruiting">招募中</span>
                        </c:when>
                        <c:when test="${activity.status eq 'ongoing'}">
                            <span class="status-badge status-ongoing">进行中</span>
                        </c:when>
                        <c:when test="${activity.status eq 'finished'}">
                            <span class="status-badge status-finished">已结束</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge">${activity.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">活动描述：</div>
                <div class="info-value">${activity.description}</div>
            </div>
        </div>
        
        <div class="btn-group">
            <c:choose>
                <c:when test="${sessionScope.user.role eq 'student'}">
                    <a href="/studentActivity/myActivities" class="btn btn-secondary">返回列表</a>
                </c:when>
                <c:otherwise>
                    <a href="/activity/list" class="btn btn-secondary">返回列表</a>
                </c:otherwise>
            </c:choose>
            <c:if test="${sessionScope.user.role eq 'teacher' or sessionScope.user.role eq 'admin'}">
                <a href="/activity/edit?id=${activity.id}" class="btn btn-primary">编辑活动</a>
            </c:if>
        </div>
    </div>
</body>
</html>