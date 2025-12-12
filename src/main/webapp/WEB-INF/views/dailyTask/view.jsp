<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看学生任务 - 学生社会实践管理系统</title>
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
            background-color: #52c41a;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        .info-box {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .info-box p {
            margin: 10px 0;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>学生社会实践管理系统 - 查看学生任务</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/index" style="color: white; text-decoration: none; margin-left: 15px;">返回首页</a>
        </div>
    </div>
    
    <div class="content">
        <h2 class="page-title">学生日常任务</h2>
        
        <div class="info-box">
            <p><strong>活动ID：</strong>${activityId}</p>
            <c:if test="${studentId != null}">
                <p><strong>学生ID：</strong>${studentId}</p>
            </c:if>
            <p style="color: #999; margin-top: 20px;">此功能需要根据活动ID和学生ID查询任务，请完善相关查询逻辑。</p>
        </div>
    </div>
</body>
</html>


