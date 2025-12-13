<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>实践报告管理 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .header { background-color: #722ed1; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid white; border-radius: 4px; }
        .content { padding: 20px; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 24px; margin-bottom: 20px; color: #333; }
        
        .activity-selector { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .activity-selector h3 { margin-bottom: 15px; color: #333; }
        .activity-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px; }
        .activity-card { border: 2px solid #e8e8e8; border-radius: 8px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .activity-card:hover { border-color: #722ed1; background: #f9f0ff; }
        .activity-card.selected { border-color: #722ed1; background: #f9f0ff; box-shadow: 0 0 0 3px rgba(114,46,209,0.2); }
        .activity-card h4 { margin-bottom: 8px; color: #333; font-size: 14px; }
        .activity-card p { font-size: 12px; color: #666; margin: 4px 0; }
        
        .report-section { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .report-header { background: linear-gradient(135deg, #722ed1 0%, #9254de 100%); color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .report-header h3 { margin: 0; }
        .btn-add { padding: 8px 16px; background: rgba(255,255,255,0.2); color: white; border: 1px solid white; border-radius: 4px; text-decoration: none; }
        .btn-add:hover { background: rgba(255,255,255,0.3); }
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        th { background-color: #fafafa; font-weight: 600; color: #333; }
        tr:hover { background-color: #fafafa; }
        
        .status-pending { background: #fff7e6; color: #fa8c16; padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        .status-reviewed { background: #f6ffed; color: #52c41a; padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; text-decoration: none; display: inline-block; }
        .btn-view { background: #1890ff; color: white; }
        .btn-edit { background: #faad14; color: white; margin-left: 5px; }
        .btn-review { background: #52c41a; color: white; margin-left: 5px; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state .icon { font-size: 48px; margin-bottom: 15px; }
        
        .report-content-preview { max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #666; font-size: 13px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>实践报告管理</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">实践报告</h2>
        
        <c:if test="${role == 'student'}">
            <!-- 学生视角：选择活动提交报告 -->
            <div class="activity-selector">
                <h3>选择活动提交报告</h3>
                <c:choose>
                    <c:when test="${empty activities}">
                        <div class="empty-state">
                            <div class="icon">📚</div>
                            <p>您还没有已通过审核的活动，无法提交报告</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-cards">
                            <c:forEach items="${activities}" var="activity">
                                <div class="activity-card" onclick="location.href='/practiceReport/add?activityId=${activity.id}'">
                                    <h4>${activity.activityName}</h4>
                                    <p>地点：${activity.location != null ? activity.location : '未设置'}</p>
                                    <p style="color:#722ed1;">→ 点击提交报告</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <c:if test="${role == 'teacher' || role == 'admin'}">
            <!-- 教师/管理员视角：选择活动查看报告 -->
            <div class="activity-selector">
                <h3>选择活动查看报告</h3>
                <c:choose>
                    <c:when test="${empty activities}">
                        <div class="empty-state">
                            <div class="icon">📚</div>
                            <p>暂无活动</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-cards">
                            <c:forEach items="${activities}" var="activity">
                                <div class="activity-card ${activityId == activity.id ? 'selected' : ''}" 
                                     onclick="location.href='/practiceReport/list?activityId=${activity.id}'">
                                    <h4>${activity.activityName}</h4>
                                    <p>地点：${activity.location != null ? activity.location : '未设置'}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- 报告列表 -->
        <div class="report-section">
            <div class="report-header">
                <h3>
                    <c:choose>
                        <c:when test="${role == 'student'}">我的报告</c:when>
                        <c:otherwise>
                            <c:if test="${currentActivity != null}">${currentActivity.activityName} - </c:if>学生报告列表
                        </c:otherwise>
                    </c:choose>
                </h3>
            </div>
            
            <c:choose>
                <c:when test="${empty reports}">
                    <div class="empty-state">
                        <div class="icon">📄</div>
                        <p>暂无报告记录</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <th>报告标题</th>
                            <c:if test="${role != 'student'}">
                                <th>学生姓名</th>
                            </c:if>
                            <th>内容预览</th>
                            <th>状态</th>
                            <th>提交时间</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${reports}" var="report">
                            <tr>
                                <td>${report.title}</td>
                                <c:if test="${role != 'student'}">
                                    <td>${studentNames[report.studentId]}</td>
                                </c:if>
                                <td><div class="report-content-preview">${report.content}</div></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.status == 'pending'}">
                                            <span class="status-pending">待审核</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-reviewed">已审核</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${report.submitTime != null}">
                                        <fmt:formatDate value="${report.submitTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="/practiceReport/view?id=${report.reportId}" class="btn btn-view">查看</a>
                                    <c:if test="${role == 'student' && report.status == 'pending'}">
                                        <a href="/practiceReport/edit?id=${report.reportId}" class="btn btn-edit">编辑</a>
                                    </c:if>
                                    <c:if test="${(role == 'teacher' || role == 'admin') && report.status == 'pending'}">
                                        <button onclick="reviewReport(${report.reportId}, 'reviewed')" class="btn btn-review">通过</button>
                                        <button onclick="showFeedbackModal(${report.reportId})" class="btn" style="background:#fa8c16;color:white;margin-left:5px;">反馈</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- 反馈弹窗 -->
    <div id="feedbackModal" style="display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:1000;">
        <div style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);background:white;padding:30px;border-radius:8px;width:400px;">
            <h3 style="margin-bottom:20px;">审核报告</h3>
            <input type="hidden" id="feedbackReportId">
            <div style="margin-bottom:15px;">
                <label>反馈意见：</label>
                <textarea id="feedbackContent" style="width:100%;height:100px;margin-top:5px;padding:10px;border:1px solid #ddd;border-radius:4px;" placeholder="请输入反馈意见..."></textarea>
            </div>
            <div style="text-align:right;">
                <button onclick="closeFeedbackModal()" style="padding:8px 16px;background:#ccc;border:none;border-radius:4px;margin-right:10px;cursor:pointer;">取消</button>
                <button onclick="submitFeedback('reviewed')" style="padding:8px 16px;background:#52c41a;color:white;border:none;border-radius:4px;cursor:pointer;">通过</button>
            </div>
        </div>
    </div>
    
    <script>
        function reviewReport(id, status) {
            if (confirm('确定要审核通过该报告吗？')) {
                fetch('/practiceReport/review?id=' + id + '&status=' + status, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                        location.reload();
                    }
                });
            }
        }
        
        function showFeedbackModal(id) {
            document.getElementById('feedbackReportId').value = id;
            document.getElementById('feedbackModal').style.display = 'block';
        }
        
        function closeFeedbackModal() {
            document.getElementById('feedbackModal').style.display = 'none';
        }
        
        function submitFeedback(status) {
            var id = document.getElementById('feedbackReportId').value;
            var feedback = document.getElementById('feedbackContent').value;
            
            fetch('/practiceReport/review?id=' + id + '&status=' + status + '&feedback=' + encodeURIComponent(feedback), {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    location.reload();
                }
            });
        }
    </script>
</body>
</html>