<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>日常任务管理 - 学生社会实践管理系统</title>
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
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 20px;
        }
        .header .user-info {
            font-size: 14px;
        }
        .header .user-info a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            padding: 5px 10px;
            border: 1px solid white;
            border-radius: 4px;
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
        .btn-add {
            padding: 8px 16px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
            cursor: pointer;
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
        .status-pending {
            color: #faad14;
            font-weight: bold;
        }
        .status-completed {
            color: #52c41a;
            font-weight: bold;
        }
        .status-reviewed {
            color: #1890ff;
            font-weight: bold;
        }
        .btn-complete {
            padding: 4px 8px;
            background-color: #52c41a;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            cursor: pointer;
        }
        .btn-delete {
            padding: 4px 8px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            cursor: pointer;
        }
        .priority-high {
            color: #ff4d4f;
            font-weight: bold;
        }
        .priority-medium {
            color: #faad14;
        }
        .priority-low {
            color: #52c41a;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>学生社会实践管理系统 - 日常任务</h1>
        <div class="user-info">
            <span>欢迎您，${sessionScope.user.name}</span>
            <a href="/index">返回首页</a>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>
    
    <div class="content">
        <h2 class="page-title">我的日常任务</h2>
        
        <button class="btn-add" onclick="showAddTaskModal()">添加任务</button>
        
        <div class="table-container">
            <table>
                <tr>
                    <th>任务标题</th>
                    <th>任务日期</th>
                    <th>优先级</th>
                    <th>状态</th>
                    <th>完成时间</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty tasks}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px; color: #999;">
                                暂无任务，点击"添加任务"创建新任务
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${tasks}" var="task">
                            <tr>
                                <td>${task.title}</td>
                                <td><fmt:formatDate value="${task.taskDate}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${task.priority >= 4}">
                                            <span class="priority-high">高</span>
                                        </c:when>
                                        <c:when test="${task.priority >= 2}">
                                            <span class="priority-medium">中</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="priority-low">低</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${task.status == 0}">
                                            <span class="status-pending">未提交</span>
                                        </c:when>
                                        <c:when test="${task.status == 1}">
                                            <span class="status-completed">已提交</span>
                                        </c:when>
                                        <c:when test="${task.status == 2}">
                                            <span class="status-reviewed">已审核</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${task.completedTime != null}">
                                        <fmt:formatDate value="${task.completedTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${task.status == 0}">
                                        <button class="btn-complete" onclick="completeTask(${task.taskId})">完成</button>
                                    </c:if>
                                    <button class="btn-delete" onclick="deleteTask(${task.taskId})">删除</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <!-- 添加任务模态框 -->
    <div id="addTaskModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 1000;">
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: white; padding: 30px; border-radius: 8px; width: 500px;">
            <h3 style="margin-bottom: 20px;">添加日常任务</h3>
            <form id="addTaskForm">
                <div style="margin-bottom: 15px;">
                    <label>任务标题：</label>
                    <input type="text" name="title" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-top: 5px;">
                </div>
                <div style="margin-bottom: 15px;">
                    <label>任务内容：</label>
                    <textarea name="content" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-top: 5px; height: 100px;"></textarea>
                </div>
                <div style="margin-bottom: 15px;">
                    <label>任务日期：</label>
                    <input type="date" name="taskDate" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-top: 5px;">
                </div>
                <div style="margin-bottom: 15px;">
                    <label>优先级：</label>
                    <select name="priority" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-top: 5px;">
                        <option value="0">低</option>
                        <option value="2" selected>中</option>
                        <option value="4">高</option>
                    </select>
                </div>
                <div style="text-align: right;">
                    <button type="button" onclick="hideAddTaskModal()" style="padding: 8px 16px; margin-right: 10px; background-color: #d9d9d9; border: none; border-radius: 4px; cursor: pointer;">取消</button>
                    <button type="submit" style="padding: 8px 16px; background-color: #1890ff; color: white; border: none; border-radius: 4px; cursor: pointer;">提交</button>
                </div>
            </form>
        </div>
    </div>
    
    <script type="text/javascript">
        function showAddTaskModal() {
            document.getElementById('addTaskModal').style.display = 'block';
        }
        
        function hideAddTaskModal() {
            document.getElementById('addTaskModal').style.display = 'none';
        }
        
        document.getElementById('addTaskForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const params = new URLSearchParams();
            for (let [key, value] of formData.entries()) {
                params.append(key, value);
            }
            
            fetch('/dailyTask/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                alert('添加失败：' + error);
            });
        });
        
        function completeTask(taskId) {
            if (confirm('确定要标记此任务为已完成吗？')) {
                fetch('/dailyTask/complete?taskId=' + taskId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert('操作失败：' + error);
                });
            }
        }
        
        function deleteTask(taskId) {
            if (confirm('确定要删除此任务吗？')) {
                fetch('/dailyTask/delete?taskId=' + taskId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert('删除失败：' + error);
                });
            }
        }
    </script>
</body>
</html>


