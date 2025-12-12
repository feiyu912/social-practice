<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的小组 - 学生社会实践管理系统</title>
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
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .table-container {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        th {
            background-color: #fafafa;
            font-weight: 600;
        }
        .btn {
            padding: 4px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #1890ff;
            color: white;
        }
        .btn-success {
            background-color: #52c41a;
            color: white;
        }
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        .btn-warning {
            background-color: #faad14;
            color: white;
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
                <li><a href="/group/manage" class="active">小组管理</a></li>
                <li><a href="/dailyTask/myTasks">日常任务</a></li>
                <li><a href="/practiceReport/list">实践报告</a></li>
                <li><a href="/grade/view">我的成绩</a></li>
            </ul>
        </div>
        
        <div class="content">
            <h2 class="page-title">我的小组</h2>
            
            <div class="table-container">
                <table>
                    <tr>
                        <th>小组名称</th>
                        <th>活动名称</th>
                        <th>组长</th>
                        <th>成员数量</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                    <c:choose>
                        <c:when test="${empty myGroups}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 30px; color: #999;">
                                    您暂未加入任何小组
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${myGroups}" var="group">
                                <tr>
                                    <td>${group.groupName}</td>
                                    <td>${group.activity.title}</td>
                                    <td>${group.leaderName}</td>
                                    <td>${group.memberCount}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${group.status == 0}">创建中</c:when>
                                            <c:when test="${group.status == 1}">进行中</c:when>
                                            <c:when test="${group.status == 2}">已完成</c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="/group/view?groupId=${group.groupId}" class="btn btn-primary">查看详情</a>
                                        <c:if test="${group.leaderId == student.id}">
                                            <a href="javascript:void(0);" onclick="deleteGroup('${group.groupId}')" class="btn btn-danger">解散小组</a>
                                        </c:if>
                                        <c:if test="${group.leaderId != student.id}">
                                            <a href="javascript:void(0);" onclick="leaveGroup('${group.groupId}')" class="btn btn-warning">退出小组</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function deleteGroup(groupId) {
            if (confirm('确定要解散该小组吗？')) {
                fetch('/group/delete?groupId=' + groupId, {
                    method: 'POST'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(function(error) {
                    alert('操作失败：' + error);
                });
            }
        }
        
        function leaveGroup(groupId) {
            if (confirm('确定要退出该小组吗？')) {
                fetch('/group/leave?groupId=' + groupId, {
                    method: 'POST'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(function(error) {
                    alert('操作失败：' + error);
                });
            }
        }
    </script>
</body>
</html>