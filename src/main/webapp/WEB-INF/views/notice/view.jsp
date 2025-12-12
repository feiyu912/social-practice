<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看公告详情 - 学生社会实践管理系统</title>
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
            max-width: 1000px;
            margin: 0 auto;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 15px;
            color: #1890ff;
            text-decoration: none;
        }
        .notice-detail {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .notice-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }
        .notice-meta {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-top: 1px solid #f0f0f0;
            border-bottom: 1px solid #f0f0f0;
            margin-bottom: 20px;
            color: #666;
        }
        .notice-content {
            line-height: 1.8;
            color: #333;
            white-space: pre-wrap;
        }
        .actions {
            margin-top: 30px;
            text-align: center;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin: 0 5px;
            cursor: pointer;
        }
        .btn-edit {
            background-color: #1890ff;
            color: white;
        }
        .btn-delete {
            background-color: #ff4d4f;
            color: white;
        }
    </style>
</head>
<body>
    <div class="content">
        <h2 class="page-title">查看公告详情</h2>
        
        <a href="/notice/list" class="back-link">&lt;&lt; 返回公告列表</a>
        
        <div class="notice-detail">
            <h1 class="notice-title">${notice.title}</h1>
            
            <div class="notice-meta">
                <span>发布人: ${notice.publisherId}</span>
                <span>发布时间: ${notice.publishTime}</span>
                <span>状态: ${notice.status == 'published' ? '已发布' : '草稿'}</span>
            </div>
            
            <div class="notice-content">
                ${notice.content}
            </div>
            
            <div class="actions">
                <a href="/notice/edit?id=${notice.id}" class="btn btn-edit">编辑</a>
                <a href="javascript:void(0);" onclick="deleteNotice(${notice.id})" class="btn btn-delete">删除</a>
            </div>
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