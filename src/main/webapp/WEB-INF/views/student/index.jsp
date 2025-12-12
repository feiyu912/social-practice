<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生首页 - 学生社会实践管理系统</title>
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
        }
        .user-info {
            font-size: 14px;
        }
        .user-info a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
        }
        .container {
            display: flex;
            min-height: calc(100vh - 60px);
        }
        .sidebar {
            width: 200px;
            background-color: #fff;
            box-shadow: 2px 0 8px rgba(0,0,0,0.08);
        }
        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }
        .sidebar-menu li {
            padding: 0;
        }
        .sidebar-menu a {
            display: block;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background-color: #e6f7ff;
            color: #1890ff;
            border-right: 3px solid #1890ff;
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        .welcome-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .welcome-card h2 {
            margin-bottom: 10px;
            color: #333;
        }
        .welcome-card p {
            color: #666;
            line-height: 1.6;
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
            color: #1890ff;
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
        <h1>学生社会实践管理系统 - 学生端</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="/index">首页</a></li>
                <li><a href="/activity/list">实践活动</a></li>
                <li><a href="/studentActivity/myActivities">我的活动</a></li>
                <li><a href="/group/manage">小组管理</a></li>
                <li><a href="/dailyTask/myTasks">日常任务</a></li>
                <li><a href="/practiceReport/list">实践报告</a></li>
                <li><a href="/grade/view">我的成绩</a></li>
            </ul>
        </div>
        
        <div class="content">
            <div class="welcome-card">
                <h2>欢迎回来，${sessionScope.user.name}！</h2>
                <p>这里是您的学生工作台，您可以在这里查看实践活动、管理日常任务、提交实践报告等。</p>
            </div>
            
            <div class="stats-section">
                <div class="stat-card">
                    <div class="number">${registeredActivityCount}</div>
                    <div class="label">已报名活动</div>
                </div>
                <div class="stat-card">
                    <div class="number">${pendingTaskCount}</div>
                    <div class="label">待完成任务</div>
                </div>
                <div class="stat-card">
                    <div class="number">${submittedReportCount}</div>
                    <div class="label">已提交报告</div>
                </div>
            </div>
            
            <div class="function-grid">
                <a href="/activity/list" class="function-card">
                    <div class="icon">🔍</div>
                    <h3>浏览实践活动</h3>
                    <p>查看所有可报名的社会实践活动，了解活动详情和要求</p>
                </a>
                
                <a href="/studentActivity/myActivities" class="function-card">
                    <div class="icon">📋</div>
                    <h3>我的活动</h3>
                    <p>查看已报名的活动，进行改选或退选操作</p>
                </a>
                
                <a href="/group/manage" class="function-card">
                    <div class="icon">👥</div>
                    <h3>小组管理</h3>
                    <p>从已报名的活动中选择，创建或加入实践小组，与同学协作完成实践活动</p>
                </a>
                
                <a href="/dailyTask/myTasks" class="function-card">
                    <div class="icon">✅</div>
                    <h3>日常任务</h3>
                    <p>填写和提交日常任务完成情况，记录实践过程</p>
                </a>
                
                <a href="/practiceReport/list" class="function-card">
                    <div class="icon">📝</div>
                    <h3>实践报告</h3>
                    <p>提交实践报告，查看教师反馈和评语</p>
                </a>
                
                <a href="/grade/view" class="function-card">
                    <div class="icon">📊</div>
                    <h3>我的成绩</h3>
                    <p>查看实践活动成绩和教师评语</p>
                </a>
            </div>
        </div>
    </div>
</body>
</html>