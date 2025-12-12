<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>浏览实践活动 - 学生社会实践管理系统</title>
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
        .btn-register {
            padding: 4px 8px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
            cursor: pointer;
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
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .message.success {
            background-color: #f6ffed;
            border: 1px solid #b7eb8f;
            color: #52c41a;
        }
        .message.error {
            background-color: #fff2f0;
            border: 1px solid #ffccc7;
            color: #ff4d4f;
        }
    </style>
</head>
<body>
    <div class="content">
        <h2 class="page-title">浏览实践活动</h2>
        
        <div class="search-bar">
            <form action="/activity/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入活动名称或关键词" value="${searchKey}">
                <button type="submit">搜索</button>
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
                    <th>参与人数限制</th>
                    <th>当前报名人数</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty activities}">
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 30px; color: #999;">
                                暂无可报名的活动
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${activities}" var="activity">
                            <tr>
                                <td>${activity.activityName}</td>
                                <td>${activity.activityType != null ? activity.activityType : '社会实践'}</td>
                                <td>${activity.startTime}</td>
                                <td>${activity.endTime}</td>
                                <td>${activity.responsiblePerson != null ? activity.responsiblePerson : '未指定'}</td>
                                <td>${activity.maxParticipants}</td>
                                <td>${activity.currentParticipants}</td>
                                <td><span class="${activity.status == 'recruiting' ? 'status-recruiting' : (activity.status == 'ongoing' ? 'status-ongoing' : 'status-finished')}">
                                    ${activity.status == 'recruiting' ? '招募中' : (activity.status == 'ongoing' ? '进行中' : '已结束')}
                                </span></td>
                                <td>
                                    <a href="/activity/view?id=${activity.id}" class="btn-view">查看详情</a>
                                    <c:if test="${activity.status == 'recruiting'}">
                                        <button class="btn-register" onclick="registerActivity('${activity.id}')">报名</button>                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <script type="text/javascript">
        function registerActivity(activityId) {
            if (confirm('确定要报名此活动吗？')) {
                fetch('/activity/register?activityId=' + activityId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('报名失败，请稍后重试');
                });
            }
        }
    </script>
</body>
</html>