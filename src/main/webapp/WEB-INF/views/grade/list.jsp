<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>成绩评定 - 学生社会实践管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
        .header { background-color: #52c41a; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid white; border-radius: 4px; }
        .content { padding: 20px; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 24px; margin-bottom: 20px; color: #333; }
        .activity-selector { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .activity-selector h3 { margin-bottom: 15px; color: #333; }
        .activity-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 15px; }
        .activity-card { border: 2px solid #e8e8e8; border-radius: 8px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .activity-card:hover { border-color: #52c41a; background: #f6ffed; }
        .activity-card.selected { border-color: #52c41a; background: #f6ffed; box-shadow: 0 0 0 3px rgba(82,196,26,0.2); }
        .activity-card h4 { margin-bottom: 8px; color: #333; }
        .activity-card p { font-size: 13px; color: #666; margin: 4px 0; }
        .activity-card .status { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .status-recruiting { background: #e6f7ff; color: #1890ff; }
        .status-ongoing { background: #fff7e6; color: #fa8c16; }
        .status-finished { background: #f5f5f5; color: #999; }
        
        .student-list { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .student-list-header { background: linear-gradient(135deg, #52c41a 0%, #73d13d 100%); color: white; padding: 15px 20px; }
        .student-list-header h3 { margin: 0; }
        .student-list-header p { margin: 5px 0 0; opacity: 0.9; font-size: 14px; }
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        th { background-color: #fafafa; font-weight: 600; color: #333; }
        tr:hover { background-color: #fafafa; }
        
        .score-input { width: 80px; padding: 6px 10px; border: 1px solid #d9d9d9; border-radius: 4px; text-align: center; }
        .comment-input { width: 150px; padding: 6px 10px; border: 1px solid #d9d9d9; border-radius: 4px; }
        
        .btn { padding: 6px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; transition: all 0.3s; }
        .btn-primary { background: #1890ff; color: white; }
        .btn-primary:hover { background: #40a9ff; }
        .btn-success { background: #52c41a; color: white; }
        .btn-success:hover { background: #73d13d; }
        .btn-warning { background: #faad14; color: white; }
        .btn-warning:hover { background: #ffc53d; }
        .btn-disabled { background: #d9d9d9; color: #999; cursor: not-allowed; }
        
        .score-badge { display: inline-block; padding: 4px 12px; border-radius: 12px; font-weight: bold; }
        .score-high { background: #f6ffed; color: #52c41a; }
        .score-medium { background: #fff7e6; color: #fa8c16; }
        .score-low { background: #fff1f0; color: #ff4d4f; }
        
        .avg-score { font-size: 18px; font-weight: bold; color: #1890ff; }
        .grade-detail { font-size: 12px; color: #999; margin-top: 4px; }
        
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state .icon { font-size: 48px; margin-bottom: 15px; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; }
        .modal-content { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; width: 400px; }
        .modal-title { font-size: 18px; margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; color: #333; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #d9d9d9; border-radius: 4px; }
        .form-group textarea { height: 80px; resize: vertical; }
        .modal-actions { text-align: right; margin-top: 20px; }
        .modal-actions .btn { margin-left: 10px; }
        
        .export-btn { float: right; }
    </style>
</head>
<body>
    <div class="header">
        <h1>成绩评定</h1>
        <a href="/index">返回首页</a>
    </div>
    
    <div class="content">
        <h2 class="page-title">学生成绩评定</h2>
        
        <!-- 步骤1：选择活动 -->
        <div class="activity-selector">
            <h3>第一步：选择实践活动</h3>
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
                                 onclick="selectActivity(${activity.id})">
                                <h4>${activity.activityName}</h4>
                                <p>地点：${activity.location != null ? activity.location : '未设置'}</p>
                                <p>负责人：${activity.responsiblePerson != null ? activity.responsiblePerson : '未指定'}</p>
                                <p>
                                    <span class="status 
                                        <c:choose>
                                            <c:when test="${activity.status == 'recruiting'}">招募中 status-recruiting</c:when>
                                            <c:when test="${activity.status == 'ongoing'}">进行中 status-ongoing</c:when>
                                            <c:otherwise>已结束 status-finished</c:otherwise>
                                        </c:choose>
                                    ">
                                        <c:choose>
                                            <c:when test="${activity.status == 'recruiting'}">招募中</c:when>
                                            <c:when test="${activity.status == 'ongoing'}">进行中</c:when>
                                            <c:otherwise>已结束</c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 步骤2：学生列表和评分 -->
        <c:if test="${not empty activityId}">
        <div class="student-list">
            <div class="student-list-header">
                <h3>第二步：为学生评分 - ${currentActivity.activityName}</h3>
                <p>本系统支持多教师评分，最终成绩取所有教师评分的平均值</p>
            </div>
            
            <c:if test="${role == 'admin'}">
                <div style="padding: 15px; border-bottom: 1px solid #f0f0f0;">
                    <a href="/importExport/exportGrades?activityId=${activityId}" class="btn btn-warning export-btn">导出成绩单</a>
                </div>
            </c:if>
            
            <c:choose>
                <c:when test="${empty studentGradeList}">
                    <div class="empty-state">
                        <div class="icon">👥</div>
                        <p>该活动暂无已通过审核的学生</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <tr>
                            <th>学号</th>
                            <th>姓名</th>
                            <th>班级</th>
                            <th>小组</th>
                            <th>平均分</th>
                            <th>我的评分</th>
                            <th>评分详情</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${studentGradeList}" var="item">
                            <tr>
                                <td>${item.student.studentNumber}</td>
                                <td>${item.student.realName}</td>
                                <td>${item.student.className}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.studentActivity.groupId != null}">小组${item.studentActivity.groupId}</c:when>
                                        <c:otherwise>个人</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.avgScore != null}">
                                            <span class="avg-score">
                                                <fmt:formatNumber value="${item.avgScore}" pattern="#0.0"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise><span style="color:#999;">未评分</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.myGrade != null}">
                                            <span class="score-badge 
                                                <c:choose>
                                                    <c:when test="${item.myGrade.score >= 90}">score-high</c:when>
                                                    <c:when test="${item.myGrade.score >= 60}">score-medium</c:when>
                                                    <c:otherwise>score-low</c:otherwise>
                                                </c:choose>
                                            ">${item.myGrade.score}</span>
                                        </c:when>
                                        <c:otherwise><span style="color:#999;">未评分</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.grades}">
                                            <div class="grade-detail">
                                                共${item.grades.size()}位教师评分
                                            </div>
                                        </c:when>
                                        <c:otherwise><span style="color:#999;">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.hasGraded}">
                                            <button class="btn btn-warning" onclick="showEditModal(${item.myGrade.gradeId}, ${item.myGrade.score}, '${item.myGrade.comment}', '${item.student.realName}')">修改评分</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success" onclick="showGradeModal(${item.student.id}, '${item.student.realName}')">评分</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        </c:if>
    </div>
    
    <!-- 评分弹窗 -->
    <div id="gradeModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">为 <span id="gradeStudentName"></span> 评分</h3>
            <form id="gradeForm">
                <input type="hidden" id="gradeStudentId" name="studentId">
                <input type="hidden" name="activityId" value="${activityId}">
                <div class="form-group">
                    <label>分数（满分100）</label>
                    <input type="number" name="score" min="0" max="100" step="0.1" required placeholder="请输入分数">
                </div>
                <div class="form-group">
                    <label>评语（可选）</label>
                    <textarea name="comment" placeholder="请输入评语..."></textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="hideModal('gradeModal')">取消</button>
                    <button type="submit" class="btn btn-success">提交评分</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 修改评分弹窗 -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">修改 <span id="editStudentName"></span> 的评分</h3>
            <form id="editForm">
                <input type="hidden" id="editGradeId" name="gradeId">
                <div class="form-group">
                    <label>分数（满分100）</label>
                    <input type="number" id="editScore" name="score" min="0" max="100" step="0.1" required>
                </div>
                <div class="form-group">
                    <label>评语（可选）</label>
                    <textarea id="editComment" name="comment"></textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="hideModal('editModal')">取消</button>
                    <button type="submit" class="btn btn-warning">保存修改</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function selectActivity(activityId) {
            window.location.href = '/grade/list?activityId=' + activityId;
        }
        
        function showGradeModal(studentId, studentName) {
            document.getElementById('gradeStudentId').value = studentId;
            document.getElementById('gradeStudentName').textContent = studentName;
            document.getElementById('gradeModal').style.display = 'block';
        }
        
        function showEditModal(gradeId, score, comment, studentName) {
            document.getElementById('editGradeId').value = gradeId;
            document.getElementById('editScore').value = score;
            document.getElementById('editComment').value = comment || '';
            document.getElementById('editStudentName').textContent = studentName;
            document.getElementById('editModal').style.display = 'block';
        }
        
        function hideModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // 评分表单提交
        document.getElementById('gradeForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            var params = new URLSearchParams();
            for (var [key, value] of formData.entries()) {
                params.append(key, value);
            }
            
            fetch('/grade/doGrade', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                alert(data.message);
                if (data.success) {
                    location.reload();
                }
            })
            .catch(function(err) { alert('操作失败：' + err); });
        });
        
        // 修改评分表单提交
        document.getElementById('editForm').addEventListener('submit', function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            var params = new URLSearchParams();
            for (var [key, value] of formData.entries()) {
                params.append(key, value);
            }
            
            fetch('/grade/updateGrade', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                alert(data.message);
                if (data.success) {
                    location.reload();
                }
            })
            .catch(function(err) { alert('操作失败：' + err); });
        });
        
        // 点击弹窗外部关闭
        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) {
                e.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>
