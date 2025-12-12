<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>小组详情 - 学生社会实践管理系统</title>
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
        }
        .content {
            padding: 20px;
        }
        .info-box {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>小组详情</h1>
    </div>
    
    <div class="content">
        <div class="info-box">
            <h3>${group.groupName}</h3>
            <p>组长ID：${group.leaderId}</p>
            <p>成员数量：${group.memberCount}</p>
            <p>状态：
                <c:choose>
                    <c:when test="${group.status == 0}">创建中</c:when>
                    <c:when test="${group.status == 1}">已确认</c:when>
                    <c:when test="${group.status == 2}">已完成</c:when>
                </c:choose>
            </p>
        </div>
        
        <div class="info-box">
            <h3>小组成员</h3>
            <c:choose>
                <c:when test="${empty members}">
                    <p>暂无成员</p>
                </c:when>
                <c:otherwise>
                    <ul>
                        <c:forEach items="${members}" var="memberId">
                            <li>学生ID: ${memberId}</li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>


