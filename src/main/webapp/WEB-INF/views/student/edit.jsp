<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑学生 - 学生社会实践管理系统</title>
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
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 600px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: inline-block;
            width: 120px;
            text-align: right;
            margin-right: 10px;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 300px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        .form-group input[type="radio"] {
            width: auto;
            margin-right: 5px;
        }
        .form-error {
            color: #ff4d4f;
            margin-left: 130px;
            font-size: 14px;
            margin-top: 5px;
        }
        .form-buttons {
            margin-top: 30px;
            text-align: center;
        }
        .btn-submit {
            padding: 10px 30px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-back {
            padding: 10px 30px;
            background-color: #d9d9d9;
            color: #333;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .error-message {
            color: #d9534f;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="content">
        <h2 class="page-title">编辑学生</h2>
        
        <div class="form-container">
            <c:if test="${not empty errorMsg}">
                <div class="error-message">${errorMsg}</div>
            </c:if>
            
            <form action="/student/edit" method="post">
                <input type="hidden" name="id" value="${student.id}">
                
                <div class="form-group">
                    <label for="studentId">学号 *</label>
                    <input type="text" id="studentId" name="studentId" value="${student.studentNumber}" required placeholder="请输入学号">
                </div>
                
                <div class="form-group">
                    <label for="realName">姓名 *</label>
                    <input type="text" id="realName" name="realName" value="${student.realName}" required placeholder="请输入姓名">
                </div>
                
                <div class="form-group">
                    <label>性别 *</label>
                    <input type="radio" name="gender" value="1" <c:if test="${student.gender == 1}">checked</c:if>> 男
                    <input type="radio" name="gender" value="0" <c:if test="${student.gender == 0}">checked</c:if>> 女
                </div>
                
                <div class="form-group">
                    <label for="className">专业班级 *</label>
                    <input type="text" id="className" name="className" value="${student.className}" required placeholder="请输入专业班级">
                </div>
                
                <div class="form-group">
                    <label for="phone">联系电话 *</label>
                    <input type="text" id="phone" name="phone" value="${student.phone}" required placeholder="请输入联系电话">
                </div>
                
                <div class="form-group">
                    <label for="email">邮箱 *</label>
                    <input type="email" id="email" name="email" value="${student.email}" required placeholder="请输入邮箱">
                </div>
                
                <div class="form-buttons">
                    <button type="submit" class="btn-submit">保存修改</button>
                    <a href="/student/list" class="btn-back">返回列表</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
