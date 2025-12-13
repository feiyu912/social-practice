<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>公告管理 - 学生社会实践管理系统</title>
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
            width: 250px;
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
        .content-preview {
            color: #666;
            font-size: 14px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 400px;
        }
        .status-active {
            color: #52c41a;
            font-weight: bold;
        }
        .status-inactive {
            color: #d9d9d9;
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
    <a href="javascript:history.back()" class="back-button">返回上一页</a>
    <div class="content">
        <h2 class="page-title">公告管理</h2>
        
        <div class="search-bar">
            <form action="/notice/list" method="get">
                <input type="text" name="searchKey" placeholder="请输入公告标题或内容关键词" value="${searchKey}">
                <button type="submit">搜索</button>
                <a href="/notice/add" class="btn-add">发布公告</a>
            </form>
        </div>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>标题</th>
                    <th>内容预览</th>
                    <th>发布人</th>
                    <th>发布时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${notices}" var="notice">
                    <tr>
                        <td>${notice.title}</td>
                        <td class="content-preview">${notice.content}</td>
                        <td>${notice.publisherId}</td>
                        <td>${notice.publishTime}</td>
                        <td><span class="${notice.status == 'published' ? 'status-active' : 'status-inactive'}">${notice.status == 'published' ? '已发布' : '未发布'}</span></td>
                        <td>
                            <a href="/notice/edit?id=${notice.id}" class="btn-edit">编辑</a>
                            <a href="javascript:void(0);" onclick="deleteNotice(${notice.id})" class="btn-delete">删除</a>
                            <a href="/notice/view?id=${notice.id}" class="btn-view">查看详情</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    
    <script type="text/javascript">
        function deleteNotice(id) {
            if (confirm('确定要删除这个公告吗？')) {
                window.location.href = '/notice/delete?id=' + id;
            }
        }
    </script>
</body>
</html>