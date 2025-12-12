<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>实践活动 - 学生社会实践管理系统</title>
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
            padding: 15px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-admin { background-color: #ff4d4f; }
        .header-teacher { background-color: #52c41a; }
        .header-student { background-color: #1890ff; }
        .header a {
            color: white;
            text-decoration: none;
            padding: 5px 15px;
            border: 1px solid white;
            border-radius: 4px;
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
        .search-bar {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 250px;
            margin-right: 10px;
        }
        .search-bar button {
            padding: 8px 16px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-add {
            padding: 8px 16px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin-left: 10px;
        }
        .table-container {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
            color: #333;
        }
        tr:hover {
            background-color: #fafafa;
        }
        .btn-edit {
            padding: 4px 8px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-delete {
            padding: 4px 8px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-view {
            padding: 4px 8px;
            background-color: #faad14;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-register {
            padding: 4px 8px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-register:disabled {
            background-color: #d9d9d9;
            cursor: not-allowed;
        }
        .status-recruiting {
            color: #52c41a;
            font-weight: bold;
        }
        .status-ongoing {
            color: #1890ff;
            font-weight: bold;
        }
        .status-finished {
            color: #d9d9d9;
        }
    </style>
</head>
<body>
    <c:set var="role" value="${sessionScope.user.role}" />
    
    <div class="header header-${role}">
        <h1>
            <c:choose>
                <c:when test="${role == 'student'}">实践活动</c:when>
                <c:when test="${role == 'teacher'}">我的活动</c:when>
                <c:otherwise>活动管理</c:otherwise>
            </c:choose>
        </h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <div class="search-bar">
            <form action="/activity/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入活动名称或关键词" value="${searchKey}">
                <button type="submit">搜索</button>
                <c:if test="${role == 'teacher' || role == 'admin'}">
                    <a href="/activity/add" class="btn-add">添加活动</a>
                </c:if>
            </form>
        </div>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>活动名称</th>
                    <th>活动类型</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>负责人</th>
                    <th>名额</th>
                    <th>已报名</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${activities}" var="activity">
                    <tr>
                        <td>${activity.activityName}</td>
                        <td>${activity.activityType != null ? activity.activityType : '社会实践'}</td>
                        <td>
                            <c:if test="${activity.startTime != null}">
                                <fmt:formatDate value="${activity.startTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${activity.endTime != null}">
                                <fmt:formatDate value="${activity.endTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </c:if>
                        </td>
                        <td>${activity.responsiblePerson != null ? activity.responsiblePerson : '未指定'}</td>
                        <td>${activity.maxParticipants}</td>
                        <td>${activity.currentParticipants}</td>
                        <td>
                            <c:choose>
                                <c:when test="${activity.status == 'recruiting'}">
                                    <span class="status-recruiting">招募中</span>
                                </c:when>
                                <c:when test="${activity.status == 'ongoing'}">
                                    <span class="status-ongoing">进行中</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-finished">已结束</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="/activity/view?id=${activity.id}" class="btn-view">查看详情</a>
                            <c:choose>
                                <c:when test="${role == 'student'}">
                                    <c:if test="${activity.status == 'recruiting'}">
                                        <button class="btn-register" onclick="registerActivity(${activity.id})">报名</button>
                                    </c:if>
                                </c:when>
                                <c:when test="${role == 'teacher' || role == 'admin'}">
                                    <a href="/activity/edit?id=${activity.id}" class="btn-edit">编辑</a>
                                    <a href="javascript:void(0);" onclick="deleteActivity(${activity.id})" class="btn-delete">删除</a>
                                    <a href="/studentActivity/list?activityId=${activity.id}" class="btn-view">查看报名</a>
                                    <a href="/group/list?activityId=${activity.id}" class="btn-view">查看小组</a>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty activities}">
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 30px; color: #999;">暂无活动数据</td>
                    </tr>
                </c:if>
            </table>
        </div>
    </div>
    
    <script type="text/javascript">
        function deleteActivity(id) {
            if (confirm('确定要删除这个活动吗？')) {
                window.location.href = '/activity/delete?id=' + id;
            }
        }
        
        function registerActivity(activityId) {
            if (confirm('确定要报名这个活动吗？')) {
                fetch('/studentActivity/register?activityId=' + activityId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('操作失败，请稍后重试');
                });
            }
        }
    </script>
</body>
</html>