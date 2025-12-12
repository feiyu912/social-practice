<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教师详情信息</title>
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
        .info-group {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
            color: #555;
            margin-right: 10px;
        }
        .value {
            color: #333;
            flex: 1;
        }
        .btn-group {
            margin-top: 30px;
            text-align: center;
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
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .card {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>教师详情信息</h2>
        
        <div class="card">
            <div class="info-group">
                <span class="label">工号：</span>
                <span class="value">${teacher.teacherNumber}</span>
            </div>
            
            <div class="info-group">
                <span class="label">姓名：</span>
                <span class="value">${teacher.realName}</span>
            </div>
            
            <div class="info-group">
                <span class="label">性别：</span>
                <span class="value">${teacher.gender == 1 ? '男' : '女'}</span>
            </div>
            
            <div class="info-group">
                <span class="label">部门：</span>
                <span class="value">${teacher.department}</span>
            </div>
            
            <div class="info-group">
                <span class="label">职位：</span>
                <span class="value">${teacher.position}</span>
            </div>
            
            <div class="info-group">
                <span class="label">联系电话：</span>
                <span class="value">${teacher.phone}</span>
            </div>
            
            <div class="info-group">
                <span class="label">电子邮箱：</span>
                <span class="value">${teacher.email}</span>
            </div>
        </div>
        
        <div class="btn-group">
            <button type="button" class="btn-primary" onclick="window.location.href='/teacher/edit?id=${teacher.id}'">编辑信息</button>
            <button type="button" class="btn-danger" onclick="confirmDelete(${teacher.id})">删除教师</button>
            <button type="button" class="btn-secondary" onclick="window.location.href='/teacher/list'">返回列表</button>
        </div>
    </div>
    
    <script type="text/javascript">
        function confirmDelete(teacherId) {
            if (confirm('确定要删除该教师信息吗？此操作不可撤销！')) {
                window.location.href = '${pageContext.request.contextPath}/teacher/delete?id=' + teacherId;
            }
        }
    </script>
</body>
</html>