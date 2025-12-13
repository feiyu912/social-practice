<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑教师信息</title>
    <style>
        body {
            font-family: Arial, "Microsoft YaHei", sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }
        h2 {
            color: #333;
            margin-bottom: 25px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
            color: #555;
            margin-right: 10px;
        }
        input[type="text"], 
        input[type="number"], 
        select {
            width: 250px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        input[type="text"]:focus, 
        input[type="number"]:focus, 
        select:focus {
            border-color: #007bff;
            outline: none;
        }
        .error-message {
            color: #d9534f;
            margin-left: 130px;
            margin-top: 5px;
            font-size: 14px;
        }
        .btn-group {
            margin-left: 130px;
            margin-top: 30px;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0069d9;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>编辑教师信息</h2>
        
        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMsg") %></div>
        <% } %>
        
        <form action="/teacher/edit" method="post">
            <div class="form-group">
                <label for="teacherNumber">工号：</label>
                <input type="text" id="teacherNumber" name="teacherNumber" value="${teacher.teacherNumber}" readonly>
            </div>
            
            <div class="form-group">
                <label for="teacherName">姓名：</label>
                <input type="text" id="teacherName" name="teacherName" value="${teacher.realName}" required>
            </div>
            
            <div class="form-group">
                <label for="gender">性别：</label>
                <select id="gender" name="gender" required>
                    <option value="男" ${teacher.gender == '男' ? 'selected' : ''}>男</option>
                    <option value="女" ${teacher.gender == '女' ? 'selected' : ''}>女</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="department">部门：</label>
                <input type="text" id="department" name="department" value="${teacher.department}" required>
            </div>
            
            <div class="form-group">
                <label for="position">职位：</label>
                <input type="text" id="position" name="position" value="${teacher.position}" required>
            </div>
            
            <div class="form-group">
                <label for="phone">联系电话：</label>
                <input type="text" id="phone" name="phone" value="${teacher.phone}">
            </div>
            
            <div class="form-group">
                <label for="email">电子邮箱：</label>
                <input type="text" id="email" name="email" value="${teacher.email}">
            </div>
            
            <input type="hidden" name="id" value="${teacher.id}">
            
            <div class="btn-group">
                <button type="submit" class="btn-primary">保存修改</button>
                <button type="button" class="btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/teacher/list'">返回列表</button>
            </div>
        </form>
    </div>
</body>
</html>