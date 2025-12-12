<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员首页 - 学生社会实践管理系统</title>
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
            background-color: #ff4d4f;
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
            background-color: #fff1f0;
            color: #ff4d4f;
            border-left-color: #ff4d4f;
        }
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        .welcome-card {
            background: linear-gradient(135deg, #ff4d4f 0%, #ff7875 100%);
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
            color: #ff4d4f;
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
        <h1>学生社会实践管理系统 - 管理员端</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="/index">首页</a></li>
                <li><a href="/student/list">学生管理</a></li>
                <li><a href="/teacher/list">教师管理</a></li>
                <li><a href="/activity/list">活动管理</a></li>
                <li><a href="/importExport/importStudents">导入学生</a></li>
                <li><a href="/importExport/importTeachers">导入教师</a></li>
                <li><a href="/grade/list">成绩管理</a></li>
                <li><a href="/notice/list">公告管理</a></li>
                <li><a href="/systemLog/list">系统日志</a></li>
            </ul>
        </div>
        
        <div class="content">
            <div class="welcome-card">
                <h2>欢迎回来，${sessionScope.user.name}！</h2>
                <p>这里是系统管理后台，您可以在这里管理用户、活动、查看系统数据等。</p>
            </div>
            
            <div class="stats-section">
                <div class="stat-card">
                    <div class="number">${studentCount}</div>
                    <div class="label">学生总数</div>
                </div>
                <div class="stat-card">
                    <div class="number">${teacherCount}</div>
                    <div class="label">教师总数</div>
                </div>
                <div class="stat-card">
                    <div class="number">${activityCount}</div>
                    <div class="label">活动总数</div>
                </div>
            </div>
            
            <div class="function-grid">
                <a href="/student/list" class="function-card">
                    <div class="icon">👨‍🎓</div>
                    <h3>学生管理</h3>
                    <p>管理学生信息，查看学生列表，添加、编辑、删除学生</p>
                </a>
                
                <a href="/teacher/list" class="function-card">
                    <div class="icon">👨‍🏫</div>
                    <h3>教师管理</h3>
                    <p>管理教师信息，查看教师列表，添加、编辑、删除教师</p>
                </a>
                
                <a href="/activity/list" class="function-card">
                    <div class="icon">🎯</div>
                    <h3>活动管理</h3>
                    <p>管理所有社会实践活动，查看、编辑、删除活动</p>
                </a>
                
                <a href="/importExport/importStudents" class="function-card">
                    <div class="icon">📥</div>
                    <h3>导入学生</h3>
                    <p>批量导入学生名单，支持CSV格式文件</p>
                </a>
                
                <a href="/importExport/importTeachers" class="function-card">
                    <div class="icon">📥</div>
                    <h3>导入教师</h3>
                    <p>批量导入教师名单，支持CSV格式文件</p>
                </a>
                
                <a href="/grade/list" class="function-card">
                    <div class="icon">📊</div>
                    <h3>成绩管理</h3>
                    <p>查看所有学生成绩，导出成绩单</p>
                </a>
                
                <a href="/notice/list" class="function-card">
                    <div class="icon">📢</div>
                    <h3>公告管理</h3>
                    <p>发布和管理系统公告，通知所有用户</p>
                </a>
                
                <a href="/systemLog/list" class="function-card">
                    <div class="icon">📋</div>
                    <h3>系统日志</h3>
                    <p>查看系统操作日志，监控系统运行状态</p>
                </a>
            </div>
        </div>
    </div>
</body>
</html>

