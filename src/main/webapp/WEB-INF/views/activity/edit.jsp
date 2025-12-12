<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>编辑实践活动</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 120px;
            resize: vertical;
        }
        .btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #6c757d;
            margin-left: 10px;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .error-message {
            color: #d9534f;
            margin-top: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>编辑实践活动</h2>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/activity/edit" method="post">
            <input type="hidden" name="id" value="${activity.id}">
            
            <div class="form-group">
                <label for="activityName">活动名称:</label>
                <input type="text" id="activityName" name="activityName" 
                       value="${activity.activityName}" placeholder="请输入活动名称" required>
            </div>
            
            <div class="form-group">
                <label for="activityType">活动类型:</label>
                <select id="activityType" name="activityType">
                    <option value="" <c:if test="${empty activity.activityType}">selected</c:if>>请选择活动类型</option>
                    <option value="社会实践" <c:if test="${activity.activityType == '社会实践'}">selected</c:if>>社会实践</option>
                    <option value="科研项目" <c:if test="${activity.activityType == '科研项目'}">selected</c:if>>科研项目</option>
                    <option value="创新创业" <c:if test="${activity.activityType == '创新创业'}">selected</c:if>>创新创业</option>
                    <option value="志愿服务" <c:if test="${activity.activityType == '志愿服务'}">selected</c:if>>志愿服务</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="startTime">开始时间:</label>
                <input type="datetime-local" id="startTime" name="startTime"
                       value="<fmt:formatDate value='${activity.startTime}' pattern='yyyy-MM-dd HH:mm'/>" required>
            </div>
            
            <div class="form-group">
                <label for="endTime">结束时间:</label>
                <input type="datetime-local" id="endTime" name="endTime"
                       value="<fmt:formatDate value='${activity.endTime}' pattern='yyyy-MM-dd HH:mm'/>" required>
            </div>
            
            <div class="form-group">
                <label for="location">活动地点:</label>
                <input type="text" id="location" name="location" 
                       value="${activity.location}" placeholder="请输入活动地点">
            </div>
            
            <div class="form-group">
                <label for="teacherName">指导老师:</label>
                <input type="text" id="teacherName" name="teacherName" 
                       value="${activity.responsiblePerson}" placeholder="请输入指导老师姓名">
            </div>
            
            <div class="form-group">
                <label for="maxParticipants">最大参与人数:</label>
                <input type="number" id="maxParticipants" name="maxParticipants" 
                       value="${activity.maxParticipants != null ? activity.maxParticipants : 50}" placeholder="请输入最大参与人数">
            </div>
            
            <div class="form-group">
                <label for="description">活动描述:</label>
                <textarea id="description" name="description" placeholder="请输入活动描述">${activity.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="status">状态:</label>
                <select id="status" name="status">
                    <option value="1" <c:if test="${activity.status == 'recruiting'}">selected</c:if>>招募中</option>
                    <option value="2" <c:if test="${activity.status == 'ongoing'}">selected</c:if>>进行中</option>
                    <option value="3" <c:if test="${activity.status == 'finished'}">selected</c:if>>已结束</option>
                </select>
            </div>
            
            <div>
                <button type="submit" class="btn">保存修改</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='/activity/list'">返回列表</button>
            </div>
        </form>
    </div>
</body>
</html>
