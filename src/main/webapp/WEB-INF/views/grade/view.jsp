<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的成绩 - 学生社会实践管理系统</title>
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
        }
        .header a {
            color: white;
            text-decoration: none;
            padding: 5px 15px;
            border: 1px solid white;
            border-radius: 4px;
        }
        .header a:hover {
            background-color: rgba(255,255,255,0.2);
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e8e8e8;
        }
        th {
            background-color: #fafafa;
            font-weight: 600;
        }
        .avg-score-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-bottom: 20px;
        }
        .avg-score-box h3 {
            color: white;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>我的成绩</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <c:if test="${averageScore != null}">
            <div class="info-box avg-score-box">
                <h3>平均分</h3>
                <p style="font-size: 32px; font-weight: bold; margin: 0;"><fmt:formatNumber value="${averageScore}" pattern="#0.00"/></p>
            </div>
        </c:if>
        
        <div class="info-box">
            <h3>教师评分详情</h3>
            <c:choose>
                <c:when test="${empty grades}">
                    <p style="color: #999; padding: 20px;">暂无评分记录</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <c:if test="${empty activityId}">
                                <th>活动ID</th>
                            </c:if>
                            <th>教师ID</th>
                            <th>分数</th>
                            <th>评语</th>
                            <th>评分时间</th>
                        </tr>
                        <c:forEach items="${grades}" var="grade">
                            <tr>
                                <c:if test="${empty activityId}">
                                    <td>${grade.activityId}</td>
                                </c:if>
                                <td>${grade.teacherId}</td>
                                <td>${grade.score}</td>
                                <td>${grade.comment != null ? grade.comment : '无'}</td>
                                <td>
                                    <c:if test="${grade.gradeTime != null}">
                                        <fmt:formatDate value="${grade.gradeTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>