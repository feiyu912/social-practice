<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加系统日志 - 学生社会实践管理系统</title>
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
            max-width: 800px;
            margin: 30px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .page-title {
            margin-bottom: 30px;
            color: #333;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #666;
            font-weight: bold;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group textarea {
            height: 120px;
            resize: vertical;
        }
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin: 0 10px;
        }
        .btn-primary {
            background-color: #1890ff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #40a9ff;
        }
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        .error-message {
            color: #ff4d4f;
            background-color: #fff2f0;
            border: 1px solid #ffccc7;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
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
        <h2 class="page-title">添加系统日志</h2>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/systemLog/add" method="post">
            <div class="form-group">
                <label for="operation">操作类型：</label>
                <select id="operation" name="operation" required>
                    <option value="">请选择操作类型</option>
                    <option value="登录">登录</option>
                    <option value="登出">登出</option>
                    <option value="添加">添加</option>
                    <option value="修改">修改</option>
                    <option value="删除">删除</option>
                    <option value="查询">查询</option>
                    <option value="导出">导出</option>
                    <option value="导入">导入</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="operator">操作人：</label>
                <input type="text" id="operator" name="operator" value="${sessionScope.user.name}" readonly>
            </div>
            
            <div class="form-group">
                <label for="ipAddress">IP地址：</label>
                <input type="text" id="ipAddress" name="ipAddress" placeholder="请输入IP地址">
            </div>
            
            <div class="form-group">
                <label for="moduleName">模块名称：</label>
                <input type="text" id="moduleName" name="moduleName" placeholder="请输入模块名称" required>
            </div>
            
            <div class="form-group">
                <label for="description">操作描述：</label>
                <textarea id="description" name="description" placeholder="请输入操作描述" required></textarea>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">添加日志</button>
                <a href="/systemLog/list" class="btn btn-secondary">返回列表</a>
            </div>
        </form>
    </div>
</body>
</html>