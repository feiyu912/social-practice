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
            <p>组长：
                <c:choose>
                    <c:when test="${group.leader != null}">
                        ${group.leader.realName} (${group.leader.studentNumber}) - ${group.leader.className}
                    </c:when>
                    <c:otherwise>未设置</c:otherwise>
                </c:choose>
            </p>
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
                <c:when test="${empty group.members}">
                    <p>暂无成员</p>
                </c:when>
                <c:otherwise>
                    <table style="width:100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background-color: #fafafa; border-bottom: 1px solid #ddd;">
                                <th style="padding: 10px; text-align: left;">学号</th>
                                <th style="padding: 10px; text-align: left;">姓名</th>
                                <th style="padding: 10px; text-align: left;">性别</th>
                                <th style="padding: 10px; text-align: left;">班级</th>
                                <th style="padding: 10px; text-align: left;">联系电话</th>
                                <th style="padding: 10px; text-align: left;">邮箱</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${group.members}" var="member">
                                <tr style="border-bottom: 1px solid #f0f0f0;">
                                    <td style="padding: 10px;">${member.studentNumber}</td>
                                    <td style="padding: 10px;">${member.realName}</td>
                                    <td style="padding: 10px;">${member.gender != null ? member.gender : '未知'}</td>
                                    <td style="padding: 10px;">${member.className}</td>
                                    <td style="padding: 10px;">${member.phone}</td>
                                    <td style="padding: 10px;">${member.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div style="margin-top: 20px;">
            <a href="javascript:history.back()" style="padding: 8px 16px; background-color: #1890ff; color: white; text-decoration: none; border-radius: 4px;">返回</a>
        </div>
    </div>
</body>
</html>


