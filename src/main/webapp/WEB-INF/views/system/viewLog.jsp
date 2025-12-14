<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统日志详情</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        .log-info {
            margin-bottom: 20px;
        }
        .info-item {
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f9f9f9;
            border-left: 3px solid #1890ff;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            display: inline-block;
            width: 120px;
        }
        .info-value {
            color: #333;
        }
        .operation-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 14px;
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
        .operation-desc {
            color: #333;
            line-height: 1.6;
            padding: 15px;
            background-color: #f9f9f9;
            border-left: 3px solid #4CAF50;
            margin: 20px 0;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .btn {
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn:hover {
            background-color: #5a6268;
        }
        .btn-danger {
            background-color: #ff4d4f;
        }
        .btn-danger:hover {
            background-color: #ff7875;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>系统日志详情</h2>
        
        <div class="log-info">
            <div class="info-item">
                <span class="info-label">日志ID:</span>
                <span class="info-value">${log.id}</span>
            </div>
            <div class="info-item">
                <span class="info-label">用户ID:</span>
                <span class="info-value">${log.userId}</span>
            </div>
            <div class="info-item">
                <span class="info-label">用户名:</span>
                <span class="info-value">${log.username}</span>
            </div>
            <div class="info-item">
                <span class="info-label">操作:</span>
                <span class="info-value">${log.operation}</span>
            </div>
            <div class="info-item">
                <span class="info-label">IP地址:</span>
                <span class="info-value">${log.ip}</span>
            </div>
            <div class="info-item">
                <span class="info-label">操作时间:</span>
                <span class="info-value">
                    <fmt:formatDate value="${log.createTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                </span>
            </div>
        </div>
        
            <div class="info-item">
                <span class="info-label">请求方法:</span>
                <span class="info-value">${log.method}</span>
            </div>
            <div class="info-item">
                <span class="info-label">请求参数:</span>
                <span class="info-value">${log.params}</span>
            </div>
        
        <div style="margin-top: 20px;">
            <a href="/systemLog/list" class="btn">返回列表</a>
            <a href="javascript:void(0);" onclick="deleteLog(${log.id})" class="btn btn-danger">删除日志</a>
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

