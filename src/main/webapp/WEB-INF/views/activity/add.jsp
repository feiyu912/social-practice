<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>添加实践活动</title>
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
        .teacher-select {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            max-height: 200px;
            overflow-y: auto;
            background-color: #fafafa;
        }
        .teacher-checkbox {
            display: inline-block;
            margin-right: 15px;
            margin-bottom: 8px;
            cursor: pointer;
            padding: 5px 10px;
            background-color: white;
            border: 1px solid #e8e8e8;
            border-radius: 4px;
        }
        .teacher-checkbox:hover {
            background-color: #f0f0f0;
        }
        .teacher-checkbox input {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>添加实践活动</h2>
        
        <c:if test="${not empty errorMsg}">
            <div class="error-message">${errorMsg}</div>
        </c:if>
        
        <form action="/activity/add" method="post">
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
                       value="${activity.startTime}" required>
            </div>
            
            <div class="form-group">
                <label for="endTime">结束时间:</label>
                <input type="datetime-local" id="endTime" name="endTime"
                       value="${activity.endTime}" required>
            </div>
            
            <div class="form-group">
                <label for="location">活动地点:</label>
                <input type="text" id="location" name="location" 
                       value="${activity.location}" placeholder="请输入活动地点">
            </div>
            
            <div class="form-group">
                <label for="maxParticipants">招募最大人数:</label>
                <input type="number" id="maxParticipants" name="maxParticipants" 
                       value="${activity.maxParticipants != null ? activity.maxParticipants : 50}" 
                       min="1" max="500" placeholder="请输入最大人数">
            </div>
            
            <div class="form-group">
                <label>指导老师 (可多选):</label>
                <div class="teacher-select">
                    <c:forEach items="${teachers}" var="teacher">
                        <label class="teacher-checkbox">
                            <input type="checkbox" name="teacherIds" value="${teacher.id}">
                            ${teacher.realName}
                            <c:if test="${not empty teacher.department}">- ${teacher.department}</c:if>
                        </label>
                    </c:forEach>
                    <c:if test="${empty teachers}">
                        <span style="color:#999;">暂无可选教师</span>
                    </c:if>
                </div>
            </div>
            
            <div class="form-group">
                <label for="description">活动描述:</label>
                <textarea id="description" name="description" placeholder="请输入活动描述">
${activity.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="status">状态:</label>
                <select id="status" name="status">
                    <option value="1" <c:if test="${activity.status == 1}">selected</c:if>>招募中</option>
                    <option value="2" <c:if test="${activity.status == 2}">selected</c:if>>进行中</option>
                    <option value="3" <c:if test="${activity.status == 3}">selected</c:if>>已结束</option>
                </select>
            </div>
            
            <div>
                <button type="submit" class="btn">保存</button>
                <button type="button" class="btn btn-secondary" onclick="window.location.href='/activity/list'">返回列表</button>
            </div>
        </form>
    </div>
</body>
</html>