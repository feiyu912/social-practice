<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的日常任务 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .header { background-color: #1890ff; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid white; border-radius: 4px; }
        .content { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .page-title { font-size: 24px; margin-bottom: 20px; color: #333; }
        
        .task-section { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 20px; }
        .task-header { background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%); color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .task-header h3 { margin: 0; }
        .btn-add { padding: 8px 16px; background: rgba(255,255,255,0.2); color: white; border: 1px solid white; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-add:hover { background: rgba(255,255,255,0.3); }
        
        .task-list { padding: 20px; }
        .task-item { border: 1px solid #e8e8e8; border-radius: 8px; padding: 15px; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
        .task-item:hover { border-color: #1890ff; box-shadow: 0 2px 8px rgba(24,144,255,0.1); }
        .task-info { flex: 1; }
        .task-title { font-weight: bold; color: #333; margin-bottom: 5px; }
        .task-meta { font-size: 12px; color: #999; display: flex; gap: 15px; }
        .task-actions { display: flex; gap: 8px; }
        
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .btn-complete { background: #52c41a; color: white; }
        .btn-complete:hover { background: #73d13d; }
        .btn-delete { background: #ff4d4f; color: white; }
        .btn-delete:hover { background: #ff7875; }
        
        .priority-high { border-left: 4px solid #ff4d4f; }
        .priority-medium { border-left: 4px solid #faad14; }
        .priority-low { border-left: 4px solid #52c41a; }
        
        .status-badge { padding: 2px 10px; border-radius: 10px; font-size: 12px; }
        .status-pending { background: #fff7e6; color: #fa8c16; }
        .status-completed { background: #f6ffed; color: #52c41a; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state .icon { font-size: 48px; margin-bottom: 15px; }
        
        /* 模态框样式 */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; }
        .modal-content { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; width: 500px; max-width: 90%; }
        .modal-title { font-size: 18px; margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; color: #333; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #d9d9d9; border-radius: 4px; }
        .form-group textarea { height: 100px; resize: vertical; }
        .modal-actions { text-align: right; margin-top: 20px; }
        .modal-actions .btn { padding: 8px 20px; margin-left: 10px; }
        .btn-cancel { background: #f0f0f0; color: #666; }
        .btn-submit { background: #1890ff; color: white; }
    </style>
</head>
<body>
    <div class="header">
        <h1>我的日常任务</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">日常任务管理</h2>
        
        <div class="task-section">
            <div class="task-header">
                <h3>我的任务列表</h3>
                <button class="btn-add" onclick="showAddModal()">➕ 添加任务</button>
            </div>
            
            <div class="task-list">
                <c:choose>
                    <c:when test="${empty tasks}">
                        <div class="empty-state">
                            <div class="icon">📝</div>
                            <p>暂无任务，点击上方“添加任务”开始记录</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${tasks}" var="task">
                            <div class="task-item 
                                <c:choose>
                                    <c:when test="${task.priority >= 4}">priority-high</c:when>
                                    <c:when test="${task.priority >= 2}">priority-medium</c:when>
                                    <c:otherwise>priority-low</c:otherwise>
                                </c:choose>
                            ">
                                <div class="task-info">
                                    <div class="task-title">${task.title}</div>
                                    <div class="task-meta">
                                        <span>📅 <fmt:formatDate value="${task.taskDate}" pattern="yyyy-MM-dd"/></span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${task.priority >= 4}">🔴 高优先级</c:when>
                                                <c:when test="${task.priority >= 2}">🟡 中优先级</c:when>
                                                <c:otherwise>🟢 低优先级</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${task.activity != null}">
                                            <span>📚 ${task.activity.activityName}</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div style="display:flex;align-items:center;gap:15px;">
                                    <span class="status-badge ${task.status == 'completed' ? 'status-completed' : 'status-pending'}">
                                        ${task.status == 'completed' ? '已完成' : '未完成'}
                                    </span>
                                    <div class="task-actions">
                                        <c:if test="${task.status == 'pending'}">
                                            <button class="btn btn-complete" onclick="completeTask(${task.taskId})">完成</button>
                                        </c:if>
                                        <button class="btn btn-delete" onclick="deleteTask(${task.taskId})">删除</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- 添加任务模态框 -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">添加日常任务</h3>
            <form id="addForm">
                <div class="form-group">
                    <label>关联活动 *</label>
                    <select name="activityId" required>
                        <option value="">请选择活动</option>
                        <c:forEach items="${activities}" var="activity">
                            <option value="${activity.id}">${activity.activityName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>任务标题 *</label>
                    <input type="text" name="title" required placeholder="请输入任务标题">
                </div>
                <div class="form-group">
                    <label>任务内容</label>
                    <textarea name="content" placeholder="请输入任务内容..."></textarea>
                </div>
                <div class="form-group">
                    <label>任务日期</label>
                    <input type="date" name="taskDate">
                </div>
                <div class="form-group">
                    <label>优先级</label>
                    <select name="priority">
                        <option value="0">低</option>
                        <option value="2" selected>中</option>
                        <option value="4">高</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="hideModal()">取消</button>
                    <button type="submit" class="btn btn-submit">添加</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }
        
        function hideModal() {
            document.getElementById('addModal').style.display = 'none';
        }
        
        document.getElementById('addForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            var params = new URLSearchParams();
            for (var pair of formData.entries()) {
                params.append(pair[0], pair[1]);
            }
            
            fetch('/dailyTask/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                alert(data.message);
                if (data.success) location.reload();
            })
            .catch(function(err) { alert('添加失败：' + err); });
        });
        
        function completeTask(taskId) {
            if (confirm('确定要标记此任务为已完成吗？')) {
                fetch('/dailyTask/complete?taskId=' + taskId, { method: 'POST' })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    alert(data.message);
                    if (data.success) location.reload();
                })
                .catch(function(err) { alert('操作失败：' + err); });
            }
        }
        
        function deleteTask(taskId) {
            if (confirm('确定要删除此任务吗？')) {
                fetch('/dailyTask/delete?taskId=' + taskId, { method: 'POST' })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    alert(data.message);
                    if (data.success) location.reload();
                })
                .catch(function(err) { alert('删除失败：' + err); });
            }
        }
        
        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) {
                e.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>