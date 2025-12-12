<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>教师首页 - 学生社会实践管理系统</title>
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
            background-color: #52c41a;
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
            display: flex;
            min-height: calc(100vh - 60px);
        }
        .sidebar {
            width: 220px;
            background-color: #fff;
            border-right: 1px solid #e8e8e8;
            padding: 20px 0;
            box-shadow: 2px 0 8px rgba(0,0,0,0.05);
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li {
            margin-bottom: 5px;
        }
        .sidebar-menu a {
            display: block;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        .sidebar-menu a:hover {
            background-color: #f6ffed;
            color: #52c41a;
            border-left-color: #52c41a;
        }
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        .welcome-card {
            background: linear-gradient(135deg, #52c41a 0%, #73d13d 100%);
            color: white;
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .welcome-card h2 {
            margin: 0 0 10px 0;
            font-size: 28px;
        }
        .welcome-card p {
            margin: 0;
            opacity: 0.9;
            font-size: 16px;
        }
        .function-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .function-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .function-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .function-card .icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .function-card h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 18px;
        }
        .function-card p {
            margin: 0;
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .stat-card .number {
            font-size: 32px;
            font-weight: bold;
            color: #52c41a;
            margin-bottom: 5px;
        }
        .stat-card .label {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>学生社会实践管理系统 - 教师端</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="/index">首页</a></li>
                <li><a href="/activity/list">我的活动</a></li>
                <li><a href="/activity/add">发布活动</a></li>
                <li><a href="/studentActivity/list">报名管理</a></li>
                <li><a href="/dailyTask/viewByActivity">学生任务</a></li>
                <li><a href="/practiceReport/list">报告审核</a></li>
                <li><a href="/grade/list">成绩评定</a></li>
            </ul>
        </div>
        
        <div class="content">
            <div class="welcome-card">
                <h2>欢迎回来，${sessionScope.user.name}老师！</h2>
                <p>这里是您的教师工作台，您可以在这里发布活动、管理学生、评定成绩等。</p>
            </div>
            
            <div class="stats-section">
                <div class="stat-card">
                    <div class="number">${activityCount}</div>
                    <div class="label">负责的活动</div>
                </div>
                <div class="stat-card">
                    <div class="number">${pendingReportCount}</div>
                    <div class="label">待审核报告</div>
                </div>
                <div class="stat-card">
                    <div class="number">${pendingGradeCount}</div>
                    <div class="label">待评定成绩</div>
                </div>
            </div>
            
            <div class="function-grid">
                <a href="/activity/add" class="function-card">
                    <div class="icon">➕</div>
                    <h3>发布实践活动</h3>
                    <p>创建新的社会实践活动，设置活动要求和参与条件</p>
                </a>
                
                <a href="/activity/list" class="function-card">
                    <div class="icon">📋</div>
                    <h3>我的活动</h3>
                    <p>查看和管理您负责的社会实践活动</p>
                </a>
                
                <a href="/studentActivity/list" class="function-card">
                    <div class="icon">👥</div>
                    <h3>报名管理</h3>
                    <p>查看活动报名情况，审核学生报名申请</p>
                </a>
                
                <a href="/dailyTask/viewByActivity" class="function-card">
                    <div class="icon">📝</div>
                    <h3>学生日常任务</h3>
                    <p>查看和管理学生提交的日常任务完成情况</p>
                </a>
                
                <a href="/practiceReport/list" class="function-card">
                    <div class="icon">📄</div>
                    <h3>实践报告审核</h3>
                    <p>审核学生提交的实践报告，给出反馈意见</p>
                </a>
                
                <a href="/grade/list" class="function-card">
                    <div class="icon">📊</div>
                    <h3>成绩评定</h3>
                    <p>评定学生实践活动成绩，支持多人评分和平均分计算</p>
                </a>
            </div>
        </div>
    </div>
</body>
</html>

