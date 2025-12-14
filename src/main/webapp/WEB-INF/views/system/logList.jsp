<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统日志 - 学生社会实践管理系统</title>
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
        .btn-delete {
            padding: 4px 8px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
        }
        .operation-desc {
            color: #666;
            font-size: 14px;
            max-width: 400px;
            word-wrap: break-word;
        }
        .operation-type {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .type-login {
            background-color: #e6f7ff;
            color: #1890ff;
        }
        .type-logout {
            background-color: #fff7e6;
            color: #fa8c16;
        }
        .type-create {
            background-color: #f6ffed;
            color: #52c41a;
        }
        .type-update {
            background-color: #e6f7ff;
            color: #1890ff;
        }
        .type-delete {
            background-color: #fff1f0;
            color: #ff4d4f;
        }
        .type-query {
            background-color: #f9f0ff;
            color: #722ed1;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .back-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            z-index: 1000;
        }
        .back-button:hover {
            background-color: #40a9ff;
        }
    </style>
</head>
<body>
    <a href="/index" class="back-button">返回首页</a>
    <div class="content">
        <h2 class="page-title">系统日志</h2>
        
        <div class="search-bar">
            <form action="/systemLog/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入用户名或操作描述关键词" value="${searchKey}">
                <button type="submit">搜索</button>
            </form>
        </div>
        
        <div class="table-container">
            <c:choose>
                <c:when test="${empty logs}">
                    <div class="empty-message">
                        <p>暂无系统日志记录</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>操作说明</th>
                            <th>请求方法</th>
                            <th>IP地址</th>
                            <th>操作时间</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${logs}" var="log">
                            <tr>
                                <td>${log.id}</td>
                                <td>${log.username}</td>
                                <td class="operation-desc">${log.operation}</td>
                                <td>${log.method}</td>
                                <td>${log.ip}</td>
                                <td>
                                    <fmt:formatDate value="${log.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </td>
                                <td>
                                    <a href="/systemLog/view?id=${log.id}" class="btn-view">查看详情</a>
                                    <a href="javascript:void(0);" onclick="deleteLog(${log.id})" class="btn-delete">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script type="text/javascript">
        function deleteLog(id) {
            if (confirm('确定要删除这条日志吗？')) {
                window.location.href = '/systemLog/delete?id=' + id;
            }
        }
    </script>
</body>
</html>

