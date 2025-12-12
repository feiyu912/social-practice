<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>成绩管理 - 学生社会实践管理系统</title>
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
        .table-container {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        th {
            background-color: #fafafa;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>成绩管理</h1>
    </div>
    
    <div class="content">
        <div class="table-container">
            <form action="/grade/list" method="get" style="margin-bottom:16px;">
                <label>活动ID：</label>
                <input type="number" name="activityId" value="${activityId}" placeholder="请输入活动ID">
                <button type="submit" style="padding:6px 12px;background:#1890ff;color:#fff;border:none;border-radius:4px;cursor:pointer;">查询</button>
                <span style="color:#888;margin-left:10px;">依据角色展示：教师只看自己评分，学生看自己的成绩，管理员看该活动全部成绩</span>
            </form>

            <c:choose>
                <c:when test="${empty activityId}">
                    <p style="color:#999;padding:12px 0;">请先输入活动ID进行查询。</p>
                </c:when>
                <c:when test="${empty grades}">
                    <p style="color:#999;padding:12px 0;">暂无符合条件的成绩记录。</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <th>学生</th>
                            <th>教师</th>
                            <th>活动ID</th>
                            <th>成绩</th>
                            <th>评语</th>
                            <th>评分时间</th>
                        </tr>
                        <c:forEach items="${grades}" var="grade">
                            <tr>
                                <td>${studentNames[grade.studentId]}</td>
                                <td>${teacherNames[grade.teacherId]}</td>
                                <td>${grade.activityId}</td>
                                <td>${grade.score}</td>
                                <td>${grade.comment}</td>
                                <td><fmt:formatDate value="${grade.gradeTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
