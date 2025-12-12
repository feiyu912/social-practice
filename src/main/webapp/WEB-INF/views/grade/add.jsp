<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加成绩 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #1890ff; color: white; padding: 15px 20px; margin-bottom: 20px; }
        .form-container { background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group input, .form-group textarea {
            width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;
        }
        .form-group textarea { height: 100px; resize: vertical; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-primary { background-color: #1890ff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; margin-left: 10px; }
        .error-message { color: #ff4d4f; margin-bottom: 15px; padding: 10px; background-color: #fff2f0; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>添加成绩</h1>
    </div>
    
    <div class="container">
        <div class="form-container">
            <h2>评分信息</h2>
            
            <c:if test="${not empty errorMsg}">
                <div class="error-message">${errorMsg}</div>
            </c:if>
            
            <form action="/grade/add" method="post">
                <input type="hidden" name="activityId" value="${activityId}">
                <input type="hidden" name="studentId" value="${studentId}">
                
                <div class="form-group">
                    <label for="score">分数 (0-100):</label>
                    <input type="number" id="score" name="score" min="0" max="100" step="0.1" placeholder="请输入分数" required>
                </div>
                
                <div class="form-group">
                    <label for="comment">评语（可选）:</label>
                    <textarea id="comment" name="comment" placeholder="请输入评语"></textarea>
                </div>
                
                <div>
                    <button type="submit" class="btn btn-primary">提交评分</button>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">返回</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
