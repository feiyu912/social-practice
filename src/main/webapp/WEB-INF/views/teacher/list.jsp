<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>教师管理 - 学生社会实践管理系统</title>
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
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .search-bar {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .search-bar input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
            margin-right: 10px;
        }
        .search-bar button {
            padding: 8px 16px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-add {
            padding: 8px 16px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin-left: 10px;
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
            color: #333;
        }
        tr:hover {
            background-color: #fafafa;
        }
        .btn-edit {
            padding: 4px 8px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-delete {
            padding: 4px 8px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-view {
            padding: 4px 8px;
            background-color: #faad14;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
        }
        .back-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            z-index: 1000;
        }
        .back-button:hover {
            background-color: #40a9ff;
        }
    </style>
</head>
<body>
    <a href="/index" class="back-button">返回首页</a>
    <div class="content">
        <h2 class="page-title">教师管理</h2>
        
        <div class="search-bar">
            <form action="${pageContext.request.contextPath}/teacher/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入工号或姓名" value="${searchKey}">
                <button type="submit">搜索</button>
                <a href="${pageContext.request.contextPath}/teacher/add" class="btn-add">添加教师</a>
            </form>
        </div>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>工号</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>所属学院</th>
                    <th>职务</th>
                    <th>联系电话</th>
                    <th>邮箱</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty teachers}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 30px; color: #999;">
                                暂无教师数据
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${teachers}" var="teacher">
                            <tr>
                                <td>${teacher.teacherNumber}</td>
                                <td>${teacher.realName != null ? teacher.realName : ''}</td>
                                <td>${empty teacher.gender ? '未知' : teacher.gender}</td>
                                <td>${teacher.college != null ? teacher.college : teacher.department}</td>
                                <td>${teacher.position != null ? teacher.position : '未指定'}</td>
                                <td>${teacher.phone}</td>
                                <td>${teacher.email}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/teacher/edit?id=${teacher.id}" class="btn-edit">编辑</a>
                                    <a href="javascript:void(0);" onclick="deleteTeacher(${teacher.id})" class="btn-delete">删除</a>
                                    <a href="${pageContext.request.contextPath}/teacher/view?id=${teacher.id}" class="btn-view">查看详情</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <script type="text/javascript">
        function deleteTeacher(id) {
            if (confirm('确定要删除这个教师吗？')) {
                window.location.href = '${pageContext.request.contextPath}/teacher/delete?id=' + id;
            }
        }
    </script>
</body>
</html>