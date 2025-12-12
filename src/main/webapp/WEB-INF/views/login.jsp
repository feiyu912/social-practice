<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生社会实践管理系统 - 登录</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
            padding: 40px;
            width: 360px;
        }
        .login-title {
            text-align: center;
            font-size: 24px;
            margin-bottom: 30px;
            color: #333;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #1890ff;
        }
        .btn-login {
            width: 100%;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-login:hover {
            background-color: #40a9ff;
        }
        .error-message {
            color: #ff4d4f;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1 class="login-title">学生社会实践管理系统</h1>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/user/login" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" placeholder="请输入用户名" required>
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" placeholder="请输入密码" required>
            </div>
            <div class="form-group" style="text-align: center; margin-top: 20px; font-size: 14px; color: #666;">
                <div style="margin-bottom: 10px;">测试账号：admin / teacher1 / student1</div>
                <div>统一密码：123456</div>
            </div>
            <button type="submit" class="btn-login">登录</button>
        </form>
        
        <div style="text-align: center; margin-top: 20px; font-size: 14px; color: #666;">
            还没有账号？<a href="/user/register" style="color: #1890ff; text-decoration: none;">立即注册</a>
        </div>
    </div>
</body>
</html>
