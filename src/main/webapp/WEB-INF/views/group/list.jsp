<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>小组管理 - 学生社会实践管理系统</title>
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
        }
        .content {
            padding: 20px;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
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
    </style>
</head>
<body>
    <div class="header">
        <h1>小组管理</h1>
    </div>
    
    <div class="content">
        <h2 class="page-title">活动小组列表</h2>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>小组名称</th>
                    <th>组长ID</th>
                    <th>成员数量</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty groups}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px; color: #999;">
                                暂无小组
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${groups}" var="group">
                            <tr>
                                <td>${group.groupName}</td>
                                <td>${group.leaderId}</td>
                                <td>${group.memberCount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${group.status == 0}">创建中</c:when>
                                        <c:when test="${group.status == 1}">已确认</c:when>
                                        <c:when test="${group.status == 2}">已完成</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="/group/view?groupId=${group.groupId}">查看详情</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
</body>
</html>


