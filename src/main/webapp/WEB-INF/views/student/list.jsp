<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生管理 - 学生社会实践管理系统</title>
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
        .search-bar button:hover {
            background-color: #40a9ff;
        }
        .btn-add {
            padding: 8px 16px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 10px;
        }
        .btn-add:hover {
            background-color: #73d13d;
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
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            display: inline-block;
            padding: 5px 10px;
            margin: 0 5px;
            border: 1px solid #ddd;
            color: #1890ff;
            text-decoration: none;
        }
        .pagination a:hover {
            border-color: #1890ff;
        }
        .pagination .active {
            background-color: #1890ff;
            color: white;
            border-color: #1890ff;
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
        <h2 class="page-title">学生管理</h2>
        
        <div class="search-bar">
            <form action="/student/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入学号或姓名" value="${searchKey}">
                <button type="submit">搜索</button>
                <a href="/student/add" class="btn-add">添加学生</a>
            </form>
        </div>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>学号</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>专业班级</th>
                    <th>联系电话</th>
                    <th>邮箱</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${students}" var="student">
                    <tr>
                        <td>${student.studentNumber}</td>
                        <td>${student.realName != null ? student.realName : ''}</td>
                        <td>${student.gender != null ? student.gender : '未知'}</td>
                        <td>${student.className}</td>
                        <td>${student.phone}</td>
                        <td>${student.email}</td>
                        <td>
                            <a href="/student/edit?id=${student.id}" class="btn-edit">编辑</a>
                            <a href="javascript:void(0);" onclick="deleteStudent(${student.id})" class="btn-delete">删除</a>
                            <a href="/student/view?id=${student.id}" class="btn-view">查看详情</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <div class="pagination">
                <a href="/student/list?pageNum=1">首页</a>

                <%-- 上一页 --%>
                <c:if test="${pageNum > 1}">
                    <a href="/student/list?pageNum=${pageNum-1}">上一页</a>
                </c:if>

                <%-- 页码列表 --%>
                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                    <a href="/student/list?pageNum=${i}"
                       class="${pageNum == i ? 'active' : ''}">${i}</a>
                </c:forEach>

                <%-- 下一页 --%>
                <c:if test="${pageNum < totalPages}">
                    <a href="/student/list?pageNum=${pageNum+1}">下一页</a>
                </c:if>

                <a href="/student/list?pageNum=${totalPages}">末页</a>
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
        function deleteStudent(id) {
            if (confirm('确定要删除这个学生吗？')) {
                window.location.href = '/student/delete?id=' + id;
            }
        }
    </script>
</body>
</html>