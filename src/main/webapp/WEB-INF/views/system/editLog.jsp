<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑系统日志 - 学生社会实践管理系统</title>
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
        <h2 class="page-title">编辑系统日志</h2>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/systemLog/edit" method="post">
            <input type="hidden" name="id" value="${log.id}">
            
            <div class="form-group">
                <label for="operation">操作类型：</label>
                <select id="operation" name="operation" required>
                    <option value="">请选择操作类型</option>
                    <option value="登录" ${log.operation eq '登录' ? 'selected' : ''}>登录</option>
                    <option value="登出" ${log.operation eq '登出' ? 'selected' : ''}>登出</option>
                    <option value="添加" ${log.operation eq '添加' ? 'selected' : ''}>添加</option>
                    <option value="修改" ${log.operation eq '修改' ? 'selected' : ''}>修改</option>
                    <option value="删除" ${log.operation eq '删除' ? 'selected' : ''}>删除</option>
                    <option value="查询" ${log.operation eq '查询' ? 'selected' : ''}>查询</option>
                    <option value="导出" ${log.operation eq '导出' ? 'selected' : ''}>导出</option>
                    <option value="导入" ${log.operation eq '导入' ? 'selected' : ''}>导入</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="operator">操作人：</label>
                <input type="text" id="operator" name="operator" value="${log.operator}" readonly>
            </div>
            
            <div class="form-group">
                <label for="ipAddress">IP地址：</label>
                <input type="text" id="ipAddress" name="ipAddress" value="${log.ipAddress}" placeholder="请输入IP地址">
            </div>
            
            <div class="form-group">
                <label for="moduleName">模块名称：</label>
                <input type="text" id="moduleName" name="moduleName" value="${log.moduleName}" placeholder="请输入模块名称" required>
            </div>
            
            <div class="form-group">
                <label for="description">操作描述：</label>
                <textarea id="description" name="description" placeholder="请输入操作描述" required>${log.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="operateTime">操作时间：</label>
                <input type="text" id="operateTime" name="operateTime" value="${log.operateTime}" readonly>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">更新日志</button>
                <a href="/systemLog/list" class="btn btn-secondary">返回列表</a>
            </div>
        </form>
    </div>
</body>
</html>