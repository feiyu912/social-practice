<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>编辑实践报告 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background-color: #1890ff; color: white; padding: 15px 20px; margin-bottom: 20px; }
        .form-container { background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;
        }
        .form-group textarea { height: 200px; resize: vertical; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-primary { background-color: #1890ff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; margin-left: 10px; }
        .error-message { color: #ff4d4f; margin-bottom: 15px; padding: 10px; background-color: #fff2f0; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>编辑实践报告</h1>
    </div>
    
    <div class="container">
        <div class="form-container">
            <h2>修改报告信息</h2>
            
            <c:if test="${not empty errorMsg}">
                <div class="error-message">${errorMsg}</div>
            </c:if>
            
            <form action="/practiceReport/edit" method="post">
                <input type="hidden" name="id" value="${report.reportId}">
                
                <div class="form-group">
                    <label for="title">报告标题:</label>
                    <input type="text" id="title" name="title" value="${report.title}" placeholder="请输入报告标题" required>
                </div>
                
                <div class="form-group">
                    <label for="content">报告内容:</label>
                    <textarea id="content" name="content" placeholder="请输入报告内容" required>${report.content}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="attachment">附件路径（可选）:</label>
                    <input type="text" id="attachment" name="attachment" value="${report.attachment}" placeholder="请输入附件路径">
                </div>
                
                <div>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='/practiceReport/list'">返回列表</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
