<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>添加教师</title>
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
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #6c757d;
            margin-left: 10px;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .error-message {
            color: #d9534f;
            margin-top: 5px;
            font-size: 14px;
        }
        .gender-group {
            margin-top: 5px;
        }
        .gender-group label {
            display: inline-block;
            margin-right: 20px;
            font-weight: normal;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>添加教师</h2>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/teacher/add" method="post">
            <div class="form-group">
                <label for="teacherId">工号:</label>
                <input type="text" id="teacherId" name="teacherId" 
                       value="${teacher.teacherId}" placeholder="请输入工号" required>
            </div>
            
            <div class="form-group">
                <label for="name">姓名:</label>
                <input type="text" id="name" name="name" 
                       value="${teacher.name}" placeholder="请输入姓名" required>
            </div>
            
            <div class="form-group">
                <label for="gender">性别:</label>
                <div class="gender-group">
                    <label>
                        <input type="radio" name="gender" value="男" 
                                <c:if test="${teacher.gender == '男' or empty teacher.gender}">checked</c:if>>
                        男
                    </label>
                    <label>
                        <input type="radio" name="gender" value="女" 
                                <c:if test="${teacher.gender == '女'}">checked</c:if>>
                        女
                    </label>
                </div>
            </div>
            
            <div class="form-group">
                <label for="age">年龄:</label>
                <input type="number" id="age" name="age" 
                       value="${teacher.age}" placeholder="请输入年龄">
            </div>
            
            <div class="form-group">
                <label for="department">部门:</label>
                <input type="text" id="department" name="department" 
                       value="${teacher.department}" placeholder="请输入所属部门" required>
            </div>
            
            <div class="form-group">
                <label for="position">职位:</label>
                <input type="text" id="position" name="position" 
                       value="${teacher.position}" placeholder="请输入职位">
            </div>
            
            <div class="form-group">
                <label for="phone">电话:</label>
                <input type="tel" id="phone" name="phone" 
                       value="${teacher.phone}" placeholder="请输入联系电话">
            </div>
            
            <div class="form-group">
                <label for="email">邮箱:</label>
                <input type="email" id="email" name="email" 
                       value="${teacher.email}" placeholder="请输入电子邮箱">
            </div>
            
            <div class="form-group" style="margin-top: 20px;">
                <button type="submit" class="btn">保存</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='/teacher/list'">返回列表</button>
            </div>
        </form>
    </div>
</body>
</html>