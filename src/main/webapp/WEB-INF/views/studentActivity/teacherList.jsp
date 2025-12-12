<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>报名管理 - 学生社会实践管理系统</title>
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
            background-color: #52c41a;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header a {
            color: white;
            text-decoration: none;
        }
        .content {
            padding: 20px;
        }
        .filter-bar {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .filter-bar select {
            padding: 8px 12px;
            border: 1px solid #d9d9d9;
            border-radius: 4px;
            font-size: 14px;
            min-width: 200px;
        }
        .filter-bar label {
            margin-right: 10px;
            font-weight: bold;
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
        }
        .btn {
            padding: 4px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            margin-right: 5px;
        }
        .btn-approve {
            background-color: #52c41a;
            color: white;
        }
        .btn-approve:hover {
            background-color: #73d13d;
        }
        .btn-reject {
            background-color: #ff4d4f;
            color: white;
        }
        .btn-reject:hover {
            background-color: #ff7875;
        }
        .status-pending {
            color: #faad14;
            font-weight: bold;
        }
        .status-approved {
            color: #52c41a;
            font-weight: bold;
        }
        .status-rejected {
            color: #ff4d4f;
            font-weight: bold;
        }
        .activity-info {
            background-color: #e6f7ff;
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #1890ff;
        }
        .activity-info h3 {
            margin: 0 0 5px 0;
            color: #1890ff;
        }
        .activity-info span {
            color: #666;
            font-size: 14px;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        .stat-item {
            padding: 10px 20px;
            background-color: #fafafa;
            border-radius: 4px;
        }
        .stat-item .number {
            font-size: 24px;
            font-weight: bold;
            color: #1890ff;
        }
        .stat-item .label {
            font-size: 12px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>报名管理</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <!-- 活动筛选 -->
        <div class="filter-bar">
            <label>选择活动：</label>
            <select id="activitySelect" onchange="changeActivity()">
                <c:forEach items="${teacherActivities}" var="act">
                    <option value="${act.id}" ${activityId == act.id ? 'selected' : ''}>${act.activityName}</option>
                </c:forEach>
            </select>
        </div>
        
        <!-- 当前活动信息 -->
        <c:if test="${currentActivity != null}">
            <div class="activity-info">
                <h3>${currentActivity.activityName}</h3>
                <span>状态：
                    <c:choose>
                        <c:when test="${currentActivity.status == 'recruiting'}">招募中</c:when>
                        <c:when test="${currentActivity.status == 'ongoing'}">进行中</c:when>
                        <c:when test="${currentActivity.status == 'finished'}">已结束</c:when>
                        <c:otherwise>${currentActivity.status}</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </c:if>
        
        <!-- 统计信息 -->
        <div class="stats">
            <div class="stat-item">
                <div class="number" id="totalCount">${activities.size()}</div>
                <div class="label">总报名人数</div>
            </div>
            <div class="stat-item">
                <div class="number" id="pendingCount">
                    <c:set var="pending" value="0"/>
                    <c:forEach items="${activities}" var="sa">
                        <c:if test="${sa.status == 0}"><c:set var="pending" value="${pending + 1}"/></c:if>
                    </c:forEach>
                    ${pending}
                </div>
                <div class="label">待审核</div>
            </div>
            <div class="stat-item">
                <div class="number" id="approvedCount">
                    <c:set var="approved" value="0"/>
                    <c:forEach items="${activities}" var="sa">
                        <c:if test="${sa.status == 1}"><c:set var="approved" value="${approved + 1}"/></c:if>
                    </c:forEach>
                    ${approved}
                </div>
                <div class="label">已通过</div>
            </div>
            <div class="stat-item">
                <div class="number" id="rejectedCount">
                    <c:set var="rejected" value="0"/>
                    <c:forEach items="${activities}" var="sa">
                        <c:if test="${sa.status == 2}"><c:set var="rejected" value="${rejected + 1}"/></c:if>
                    </c:forEach>
                    ${rejected}
                </div>
                <div class="label">已拒绝</div>
            </div>
        </div>
        
        <!-- 报名列表 -->
        <div class="table-container">
            <table>
                <tr>
                    <th>学号</th>
                    <th>姓名</th>
                    <th>班级</th>
                    <th>联系电话</th>
                    <th>报名状态</th>
                    <th>报名时间</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty activities}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px; color: #999;">
                                暂无报名记录
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${activities}" var="studentActivity">
                            <tr id="row-${studentActivity.id}">
                                <td>${studentActivity.student.studentNumber}</td>
                                <td>${studentActivity.student.realName}</td>
                                <td>${studentActivity.student.className}</td>
                                <td>${studentActivity.student.phone}</td>
                                <td>
                                    <span id="status-${studentActivity.id}" class="
                                        <c:choose>
                                            <c:when test="${studentActivity.status == 0}">status-pending</c:when>
                                            <c:when test="${studentActivity.status == 1}">status-approved</c:when>
                                            <c:when test="${studentActivity.status == 2}">status-rejected</c:when>
                                        </c:choose>
                                    ">
                                        <c:choose>
                                            <c:when test="${studentActivity.status == 0}">待审核</c:when>
                                            <c:when test="${studentActivity.status == 1}">已通过</c:when>
                                            <c:when test="${studentActivity.status == 2}">已拒绝</c:when>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${studentActivity.joinTime != null}">
                                        <fmt:formatDate value="${studentActivity.joinTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                                <td id="action-${studentActivity.id}">
                                    <c:if test="${studentActivity.status == 0}">
                                        <button class="btn btn-approve" onclick="approveRegistration(${studentActivity.id})">通过</button>
                                        <button class="btn btn-reject" onclick="rejectRegistration(${studentActivity.id})">拒绝</button>
                                    </c:if>
                                    <c:if test="${studentActivity.status == 1}">
                                        <span style="color: #52c41a;">✓ 已审核</span>
                                    </c:if>
                                    <c:if test="${studentActivity.status == 2}">
                                        <span style="color: #ff4d4f;">✗ 已拒绝</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <script>
        function changeActivity() {
            var activityId = document.getElementById('activitySelect').value;
            window.location.href = '/studentActivity/list?activityId=' + activityId;
        }
        
        function approveRegistration(id) {
            if (!confirm('确定要通过该学生的报名申请吗？')) {
                return;
            }
            
            fetch('/studentActivity/approve?id=' + id, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 更新状态显示
                    document.getElementById('status-' + id).className = 'status-approved';
                    document.getElementById('status-' + id).innerText = '已通过';
                    document.getElementById('action-' + id).innerHTML = '<span style="color: #52c41a;">✓ 已审核</span>';
                    alert('审核通过！学生现在可以创建或加入小组了。');
                    location.reload();
                } else {
                    alert(data.message || '操作失败');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请稍后重试');
            });
        }
        
        function rejectRegistration(id) {
            if (!confirm('确定要拒绝该学生的报名申请吗？')) {
                return;
            }
            
            fetch('/studentActivity/reject?id=' + id, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 更新状态显示
                    document.getElementById('status-' + id).className = 'status-rejected';
                    document.getElementById('status-' + id).innerText = '已拒绝';
                    document.getElementById('action-' + id).innerHTML = '<span style="color: #ff4d4f;">✗ 已拒绝</span>';
                    alert('已拒绝该学生的报名申请。');
                    location.reload();
                } else {
                    alert(data.message || '操作失败');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请稍后重试');
            });
        }
    </script>
</body>
</html>