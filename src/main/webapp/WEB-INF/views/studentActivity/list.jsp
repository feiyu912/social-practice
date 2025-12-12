<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的活动 - 学生社会实践管理系统</title>
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
        .header a {
            color: white;
            text-decoration: none;
        }
        .content {
            padding: 20px;
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
        }
        .btn-cancel {
            padding: 4px 8px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
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
        .status-pending {
            color: #faad14;
            font-weight: bold;
        }
        .status-approved {
            color: #52c41a;
            font-weight: bold;
        }
        .status-rejected {
            color: #ff4d4f;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>我的活动</h1>
    </div>
    
    <div class="content">
        <div class="table-container">
            <table>
                <tr>
                    <th>活动名称</th>
                    <th>活动状态</th>
                    <th>报名状态</th>
                    <th>报名时间</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty activities}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px; color: #999;">
                                暂无报名记录
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${activities}" var="studentActivity">
                            <tr>
                                <td>${studentActivity.activity.activityName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${studentActivity.activity.status == 'recruiting'}">
                                            <span style="color: #52c41a; font-weight: bold;">招募中</span>
                                        </c:when>
                                        <c:when test="${studentActivity.activity.status == 'ongoing'}">
                                            <span style="color: #1890ff; font-weight: bold;">进行中</span>
                                        </c:when>
                                        <c:when test="${studentActivity.activity.status == 'finished'}">
                                            <span style="color: #d9d9d9;">已结束</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${studentActivity.status == 0}">
                                            <span class="status-pending">待审核</span>
                                        </c:when>
                                        <c:when test="${studentActivity.status == 1}">
                                            <span class="status-approved">已通过</span>
                                        </c:when>
                                        <c:when test="${studentActivity.status == 2}">
                                            <span class="status-rejected">已拒绝</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${studentActivity.joinTime != null}">
                                        <fmt:formatDate value="${studentActivity.joinTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="/activity/view?id=${studentActivity.activity.id}" class="btn-view">查看详情</a>
                                    <a href="/group/list?activityId=${studentActivity.activity.id}" style="padding: 4px 8px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 4px; font-size: 12px; margin-right: 5px;">查看小组</a>
                                    <c:if test="${studentActivity.status == 0 && studentActivity.activity.status == 'recruiting'}">
                                        <button class="btn-cancel" onclick="cancelRegistration('${studentActivity.activity.id}')">退选</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <script>
        function cancelRegistration(activityId) {
            if (confirm('确定要退选此活动吗？')) {
                fetch('/studentActivity/cancel?activityId=' + activityId, {
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
