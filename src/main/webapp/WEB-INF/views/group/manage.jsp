<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>小组管理 - 学生社会实践管理系统</title>
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
        }
        .header a {
            color: white;
            text-decoration: none;
        }
        .content {
            padding: 20px;
        }
        .page-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .info-box {
            background-color: #e6f7ff;
            border-left: 4px solid #1890ff;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .info-box.warning {
            background-color: #fff7e6;
            border-left-color: #faad14;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 100%;
            max-width: 400px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #1890ff;
            color: white;
        }
        .btn-success {
            background-color: #52c41a;
            color: white;
        }
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        .table-container {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-top: 20px;
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
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .create-form {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        #availableGroups {
            margin-top: 20px;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>小组管理</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">创建或加入小组</h2>
        
        <c:choose>
            <c:when test="${empty activities}">
                <div class="info-box warning">
                    <strong>提示：</strong>您目前没有已通过审核的活动，无法创建或加入小组。<br>
                    请先报名活动并等待教师审核通过后，再来创建或加入小组。
                </div>
            </c:when>
            <c:otherwise>
                <div class="info-box">
                    <strong>说明：</strong>以下是您已通过报名审核的活动，可以创建新小组或加入已有小组。
                </div>
                
                <div class="create-form">
                    <div class="form-group">
                        <label for="activitySelect">选择活动：</label>
                        <select id="activitySelect" onchange="onActivityChange()">
                            <option value="">请选择活动</option>
                            <c:forEach items="${activities}" var="activity">
                                <option value="${activity.id}">${activity.activityName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div id="groupActions" style="display: none;">
                        <div class="form-group">
                            <label for="groupName">小组名称：</label>
                            <input type="text" id="groupName" placeholder="请输入小组名称">
                        </div>
                        
                        <button class="btn btn-primary" onclick="createGroup()">创建小组</button>
                        <button class="btn btn-success" onclick="loadAvailableGroups()">查看可加入的小组</button>
                    </div>
                </div>
                
                <div id="availableGroups">
                    <h3>可加入的小组</h3>
                    <table id="groupsTable">
                        <tr>
                            <th>小组ID</th>
                            <th>小组名称</th>
                            <th>成员数量</th>
                            <th>操作</th>
                        </tr>
                        <tbody id="groupsBody">
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="table-container">
            <h3>我的小组</h3>
            <table>
                <tr>
                    <th>小组名称</th>
                    <th>活动名称</th>
                    <th>成员数量</th>
                    <th>我的角色</th>
                    <th>操作</th>
                </tr>
                <c:choose>
                    <c:when test="${empty myGroups}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px; color: #999;">
                                暂无小组
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${myGroups}" var="group">
                            <tr>
                                <td>${group.groupName}</td>
                                <td>${group.activity.activityName}</td>
                                <td>${group.memberCount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${group.leaderId == student.id}">
                                            <span style="color: #1890ff; font-weight: bold;">组长</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>成员</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-primary" onclick="viewGroup('${group.groupId}')">查看详情</button>
                                        <c:if test="${group.leaderId == student.id}">
                                            <button class="btn btn-danger" onclick="deleteGroup('${group.groupId}')">解散小组</button>
                                        </c:if>
                                        <c:if test="${group.leaderId != student.id}">
                                            <button class="btn btn-danger" onclick="leaveGroup('${group.groupId}')">退出小组</button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
    
    <script>
        function onActivityChange() {
            var activityId = document.getElementById('activitySelect').value;
            var groupActions = document.getElementById('groupActions');
            var availableGroups = document.getElementById('availableGroups');
            
            if (activityId) {
                groupActions.style.display = 'block';
            } else {
                groupActions.style.display = 'none';
                availableGroups.style.display = 'none';
            }
        }
        
        function createGroup() {
            var activityId = document.getElementById('activitySelect').value;
            var groupName = document.getElementById('groupName').value;
            
            if (!activityId) {
                alert('请选择活动');
                return;
            }
            
            if (!groupName) {
                alert('请输入小组名称');
                return;
            }
            
            fetch('/group/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'activityId=' + encodeURIComponent(activityId) + '&groupName=' + encodeURIComponent(groupName)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                alert(data.message);
                if (data.success) {
                    location.reload();
                }
            })
            .catch(function(error) {
                alert('创建失败：' + error);
            });
        }
        
        function loadAvailableGroups() {
            var activityId = document.getElementById('activitySelect').value;
            if (!activityId) {
                alert('请先选择活动');
                return;
            }
            
            fetch('/group/listJson?activityId=' + activityId)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var tbody = document.getElementById('groupsBody');
                tbody.innerHTML = '';
                
                if (data.groups && data.groups.length > 0) {
                    data.groups.forEach(function(group) {
                        var row = '<tr>' +
                            '<td>' + group.groupId + '</td>' +
                            '<td>' + group.groupName + '</td>' +
                            '<td>' + group.memberCount + '</td>' +
                            '<td><button class="btn btn-success" onclick="joinGroup(' + group.groupId + ', ' + activityId + ')">加入</button></td>' +
                            '</tr>';
                        tbody.innerHTML += row;
                    });
                } else {
                    tbody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: #999;">该活动暂无小组，您可以创建一个</td></tr>';
                }
                
                document.getElementById('availableGroups').style.display = 'block';
            })
            .catch(function(error) {
                alert('加载失败：' + error);
            });
        }
        
        function joinGroup(groupId, activityId) {
            if (!confirm('确定要加入该小组吗？')) {
                return;
            }
            
            fetch('/group/join', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'activityId=' + encodeURIComponent(activityId) + '&groupId=' + encodeURIComponent(groupId)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                alert(data.message);
                if (data.success) {
                    location.reload();
                }
            })
            .catch(function(error) {
                alert('加入失败：' + error);
            });
        }
        
        function viewGroup(groupId) {
            window.location.href = '/group/view?groupId=' + groupId;
        }
        
        function deleteGroup(groupId) {
            if (confirm('确定要解散该小组吗？此操作不可恢复。')) {
                fetch('/group/delete?groupId=' + groupId, {
                    method: 'POST'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    alert(data.message);
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(function(error) {
                    alert('删除失败：' + error);
                });
            }
        }
        
        function leaveGroup(groupId) {
            if (confirm('确定要退出该小组吗？')) {
                fetch('/group/leave?groupId=' + groupId, {
                    method: 'POST'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    alert(data.message);
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(function(error) {
                    alert('退出失败：' + error);
                });
            }
        }
    </script>
</body>
</html>