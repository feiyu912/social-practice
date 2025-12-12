<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑公告 - 学生社会实践管理系统</title>
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
            max-width: 800px;
            margin: 0 auto;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #1890ff;
            text-decoration: none;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            min-height: 200px;
            resize: vertical;
        }
        .form-group select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-actions {
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
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
            text-decoration: none;
            display: inline-block;
        }
        .error-message {
            color: #ff4d4f;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #fff2f0;
            border: 1px solid #ffccc7;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="content">
        <h2 class="page-title">编辑公告</h2>
        
        <a href="/notice/list" class="back-link">&lt;&lt; 返回公告列表</a>
        
        <div class="form-container">
            <c:if test="${not empty errorMsg}">
                <div class="error-message">${errorMsg}</div>
            </c:if>
            
            <form action="/notice/edit" method="post">
                <input type="hidden" name="id" value="${notice.id}">
                
                <div class="form-group">
                    <label for="title">标题 *</label>
                    <input type="text" id="title" name="title" value="${notice.title}" required>
                </div>
                
                <div class="form-group">
                    <label for="content">内容 *</label>
                    <textarea id="content" name="content" required>${notice.content}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="status">状态</label>
                    <select id="status" name="status">
                        <option value="1" ${notice.status == 'published' ? 'selected' : ''}>发布</option>
                        <option value="0" ${notice.status != 'published' ? 'selected' : ''}>草稿</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">保存</button>
                    <a href="/notice/list" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>