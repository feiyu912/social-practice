<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生详情</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { margin-bottom: 16px; }
        .row { display: flex; margin-bottom: 12px; }
        .label { width: 140px; color: #666; font-weight: bold; }
        .value { flex: 1; color: #333; }
        .actions { margin-top: 20px; }
        .btn { display: inline-block; padding: 8px 14px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .btn-primary { background: #1890ff; color: #fff; }
        .btn-secondary { background: #6c757d; color: #fff; margin-left: 10px; }
        .empty { color: #999; }
    </style>
</head>
<body>
<div class="container">
    <h2>学生详情</h2>

    <c:choose>
        <c:when test="${empty student}">
            <p class="empty">未找到对应的学生信息。</p>
        </c:when>
        <c:otherwise>
            <div class="row"><div class="label">学生ID：</div><div class="value">${student.id}</div></div>
            <div class="row"><div class="label">学号：</div><div class="value">${student.studentNumber}</div></div>
            <div class="row"><div class="label">姓名：</div><div class="value">${student.realName}</div></div>
            <div class="row"><div class="label">性别：</div><div class="value">${empty student.gender ? '未填写' : student.gender}</div></div>
            <div class="row"><div class="label">班级：</div><div class="value">${student.className}</div></div>
            <div class="row"><div class="label">手机号：</div><div class="value">${student.phone}</div></div>
            <div class="row"><div class="label">邮箱：</div><div class="value">${student.email}</div></div>
        </c:otherwise>
    </c:choose>

    <div class="actions">
        <a href="/student/list" class="btn btn-secondary">返回列表</a>
        <c:if test="${not empty student.id}">
            <a href="/student/edit?id=${student.id}" class="btn btn-primary">编辑</a>
        </c:if>
    </div>
</div>
</body>
</html>

