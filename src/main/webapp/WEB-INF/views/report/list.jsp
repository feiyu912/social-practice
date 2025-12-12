<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>实践报告管理 - 学生社会实践管理系统</title>
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
        .content {
            padding: 20px;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .btn-add {
            padding: 8px 16px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
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
            color: #333;
        }
        .status-pending {
            color: #faad14;
            font-weight: bold;
        }
        .status-reviewed {
            color: #52c41a;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>实践报告管理</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/index" style="color: white; text-decoration: none; margin-left: 15px;">返回首页</a>
        </div>
    </div>
    
    <div class="content">
        <h2 class="page-title">实践报告列表</h2>
        
        <c:if test="${sessionScope.user.role == 'student'}">
            <a href="/practiceReport/add" class="btn-add">提交报告</a>
        </c:if>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>报告标题</th>
                    <th>活动ID</th>
                    <th>状态</th>
                    <th>提交时间</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty reports}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px; color: #999;">
                                暂无报告
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${reports}" var="report">
                            <tr>
                                <td>${report.title}</td>
                                <td>${report.activityId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.status == 'pending'}">
                                            <span class="status-pending">待审核</span>
                                        </c:when>
                                        <c:when test="${report.status == 'reviewed'}">
                                            <span class="status-reviewed">已审核</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${report.submitTime != null}">
                                        <fmt:formatDate value="${report.submitTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="/practiceReport/view?id=${report.reportId}">查看</a>
                                    <c:if test="${sessionScope.user.role == 'student'}">
                                        <a href="/practiceReport/edit?id=${report.reportId}" style="margin-left: 10px;">编辑</a>
                                    </c:if>
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


