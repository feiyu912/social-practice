<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生日常管理 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .header { background-color: #fa8c16; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid white; border-radius: 4px; }
        .content { padding: 20px; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 24px; margin-bottom: 20px; color: #333; }
        
        .activity-selector { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .activity-selector h3 { margin-bottom: 15px; color: #333; }
        .activity-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px; }
        .activity-card { border: 2px solid #e8e8e8; border-radius: 8px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .activity-card:hover { border-color: #fa8c16; background: #fff7e6; }
        .activity-card.selected { border-color: #fa8c16; background: #fff7e6; box-shadow: 0 0 0 3px rgba(250,140,22,0.2); }
        .activity-card h4 { margin-bottom: 8px; color: #333; font-size: 14px; }
        .activity-card p { font-size: 12px; color: #666; margin: 4px 0; }
        
        .student-section { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .student-header { background: linear-gradient(135deg, #fa8c16 0%, #ffa940 100%); color: white; padding: 15px 20px; }
        .student-header h3 { margin: 0; }
        .student-header p { margin: 5px 0 0; opacity: 0.9; font-size: 14px; }
        
        .student-list { padding: 20px; }
        .student-item { border: 1px solid #f0f0f0; border-radius: 8px; margin-bottom: 15px; overflow: hidden; }
        .student-item-header { background: #fafafa; padding: 12px 15px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; }
        .student-item-header:hover { background: #f0f0f0; }
        .student-info { display: flex; align-items: center; gap: 15px; }
        .student-name { font-weight: bold; color: #333; }
        .student-stats { display: flex; gap: 15px; font-size: 13px; }
        .stat-badge { padding: 2px 8px; border-radius: 10px; }
        .stat-total { background: #e6f7ff; color: #1890ff; }
        .stat-completed { background: #f6ffed; color: #52c41a; }
        .stat-pending { background: #fff7e6; color: #fa8c16; }
        
        .student-tasks { display: none; padding: 15px; background: #fafafa; }
        .student-tasks.show { display: block; }
        .task-item { background: white; border: 1px solid #e8e8e8; border-radius: 4px; padding: 10px 15px; margin-bottom: 8px; display: flex; justify-content: space-between; align-items: center; }
        .task-title { font-weight: 500; color: #333; }
        .task-date { font-size: 12px; color: #999; }
        .task-status { padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .status-pending { background: #fff7e6; color: #fa8c16; }
        .status-completed { background: #f6ffed; color: #52c41a; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state .icon { font-size: 48px; margin-bottom: 15px; }
        
        .toggle-icon { transition: transform 0.3s; }
        .toggle-icon.open { transform: rotate(90deg); }
    </style>
</head>
<body>
    <div class="header">
        <h1>学生日常管理</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">查看学生日常任务</h2>
        
        <!-- 活动选择 -->
        <div class="activity-selector">
            <h3>选择实践活动</h3>
            <c:choose>
                <c:when test="${empty activities}">
                    <div class="empty-state">
                        <div class="icon">📚</div>
                        <p>您还没有负责的活动</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="activity-cards">
                        <c:forEach items="${activities}" var="activity">
                            <div class="activity-card ${activityId == activity.id ? 'selected' : ''}" 
                                 onclick="location.href='/dailyTask/list?activityId=${activity.id}'">
                                <h4>${activity.activityName}</h4>
                                <p>地点：${activity.location != null ? activity.location : '未设置'}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 学生任务列表 -->
        <c:if test="${not empty activityId}">
        <div class="student-section">
            <div class="student-header">
                <h3>${currentActivity.activityName} - 学生日常任务</h3>
                <p>点击学生姓名可展开/收起任务列表</p>
            </div>
            
            <div class="student-list">
                <c:choose>
                    <c:when test="${empty studentTasks}">
                        <div class="empty-state">
                            <div class="icon">👥</div>
                            <p>该活动暂无已通过审核的学生</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${studentTasks}" var="item" varStatus="idx">
                            <div class="student-item">
                                <div class="student-item-header" onclick="toggleTasks('tasks-${idx.index}', this)">
                                    <div class="student-info">
                                        <span class="toggle-icon">▶</span>
                                        <span class="student-name">${item.student.realName}</span>
                                        <span style="color:#999;font-size:13px;">${item.student.studentNumber}</span>
                                    </div>
                                    <div class="student-stats">
                                        <span class="stat-badge stat-total">共 ${item.taskCount} 个任务</span>
                                        <span class="stat-badge stat-completed">已完成 ${item.completedCount}</span>
                                        <span class="stat-badge stat-pending">待完成 ${item.taskCount - item.completedCount}</span>
                                    </div>
                                </div>
                                <div class="student-tasks" id="tasks-${idx.index}">
                                    <c:choose>
                                        <c:when test="${empty item.tasks}">
                                            <p style="text-align:center;color:#999;padding:20px;">该学生暂无任务记录</p>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${item.tasks}" var="task">
                                                <div class="task-item">
                                                    <div>
                                                        <div class="task-title">${task.title}</div>
                                                        <div class="task-date">
                                                            <fmt:formatDate value="${task.taskDate}" pattern="yyyy-MM-dd"/>
                                                        </div>
                                                    </div>
                                                    <span class="task-status ${task.status == 'completed' ? 'status-completed' : 'status-pending'}">
                                                        ${task.status == 'completed' ? '已完成' : '未完成'}
                                                    </span>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:if>
    </div>
    
    <script>
        function toggleTasks(taskId, header) {
            var tasksDiv = document.getElementById(taskId);
            var icon = header.querySelector('.toggle-icon');
            if (tasksDiv.classList.contains('show')) {
                tasksDiv.classList.remove('show');
                icon.classList.remove('open');
            } else {
                tasksDiv.classList.add('show');
                icon.classList.add('open');
            }
        }
    </script>
</body>
</html>
