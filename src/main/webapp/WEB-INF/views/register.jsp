<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生社会实践管理系统 - 注册</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .register-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
            padding: 40px;
            width: 400px;
            max-width: 90%;
        }
        .register-title {
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
        .form-group label .required {
            color: #ff4d4f;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1890ff;
        }
        .btn-register {
            width: 100%;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 15px;
        }
        .btn-register:hover {
            background-color: #73d13d;
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
            text-decoration: none;
            display: block;
            text-align: center;
            box-sizing: border-box;
        }
        .btn-login:hover {
            background-color: #40a9ff;
        }
        .error-message {
            color: #ff4d4f;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
            padding: 10px;
            background-color: #fff1f0;
            border: 1px solid #ffccc7;
            border-radius: 4px;
        }
        .success-message {
            color: #52c41a;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
            padding: 10px;
            background-color: #f6ffed;
            border: 1px solid #b7eb8f;
            border-radius: 4px;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }
        .login-link a {
            color: #1890ff;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1 class="register-title">用户注册</h1>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <c:if test="${not empty successMsg}">
            <div class="success-message">${successMsg}</div>
        </c:if>
        
        <form action="/user/register" method="post" id="registerForm">
            <div class="form-group">
                <label for="username">用户名 <span class="required">*</span></label>
                <input type="text" id="username" name="username" placeholder="请输入用户名" required>
            </div>
            
            <div class="form-group">
                <label for="password">密码 <span class="required">*</span></label>
                <input type="password" id="password" name="password" placeholder="请输入密码" required>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">确认密码 <span class="required">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
            </div>
            
            <div class="form-group">
                <label for="name">真实姓名 <span class="required">*</span></label>
                <input type="text" id="name" name="name" placeholder="请输入真实姓名" required>
            </div>
            
            <div class="form-group">
                <label for="role">角色 <span class="required">*</span></label>
                <select id="role" name="role" required>
                    <option value="">请选择角色</option>
                    <option value="student">学生</option>
                    <option value="teacher">教师</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="email">邮箱</label>
                <input type="email" id="email" name="email" placeholder="请输入邮箱（可选）">
            </div>
            
            <div class="form-group">
                <label for="phone">手机号</label>
                <input type="tel" id="phone" name="phone" placeholder="请输入手机号（可选）">
            </div>
            
            <button type="submit" class="btn-register">注册</button>
        </form>
        
        <div class="login-link">
            已有账号？<a href="/login">立即登录</a>
        </div>
    </div>
    
    <script>
        // 客户端验证密码确认
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致，请重新输入');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('密码长度至少为6位');
                return false;
            }
        });
    </script>
</body>
</html>

