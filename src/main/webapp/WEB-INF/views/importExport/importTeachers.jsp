<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>导入教师 - 社会实践管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            font-size: 16px;
            opacity: 0.9;
        }

        .content {
            padding: 40px;
        }

        .upload-area {
            border: 3px dashed #2196F3;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            background: #f8f9fa;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .upload-area:hover {
            border-color: #1976D2;
            background: #e3f2fd;
        }

        .upload-area.dragover {
            border-color: #4CAF50;
            background: #e8f5e8;
        }

        .upload-icon {
            font-size: 48px;
            color: #2196F3;
            margin-bottom: 20px;
        }

        .upload-text {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }

        .upload-subtext {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }

        .file-input {
            display: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .format-info {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 5px;
        }

        .format-info h3 {
            color: #1976D2;
            margin-bottom: 10px;
        }

        .format-info ul {
            margin-left: 20px;
            color: #555;
        }

        .format-info li {
            margin-bottom: 5px;
        }

        .progress-area {
            display: none;
            margin-top: 20px;
        }

        .progress-bar {
            width: 100%;
            height: 20px;
            background: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            width: 0%;
            transition: width 0.3s ease;
        }

        .progress-text {
            text-align: center;
            margin-top: 10px;
            color: #666;
        }

        .result-area {
            display: none;
            margin-top: 30px;
            padding: 20px;
            border-radius: 10px;
        }

        .result-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .result-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .error-list {
            max-height: 200px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
        }

        .error-item {
            padding: 5px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .error-item:last-child {
            border-bottom: none;
        }

        .actions {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📥 导入教师名单</h1>
            <p>通过CSV文件批量导入教师信息</p>
        </div>
        
        <div class="content">
            <div class="format-info">
                <h3>文件格式要求</h3>
                <ul>
                    <li>文件格式：CSV（逗号分隔）</li>
                    <li>编码格式：UTF-8</li>
                    <li>必需字段：工号、姓名、性别、部门、职务</li>
                    <li>可选字段：手机号、邮箱</li>
                    <li>示例格式：工号,姓名,性别,部门,职务,手机号,邮箱</li>
                </ul>
            </div>

            <div class="upload-area" id="uploadArea">
                <div class="upload-icon">📁</div>
                <div class="upload-text">点击选择文件或拖拽文件到此处</div>
                <div class="upload-subtext">支持 CSV 文件，最大 5MB</div>
                <input type="file" id="fileInput" class="file-input" accept=".csv" />
                <button class="btn-primary" onclick="document.getElementById('fileInput').click()">选择文件</button>
            </div>

            <div class="progress-area" id="progressArea">
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
                <div class="progress-text" id="progressText">正在上传...</div>
            </div>

            <div class="result-area" id="resultArea">
                <div id="resultContent"></div>
            </div>

            <div class="actions">
                <a href="/index" class="btn-secondary">返回首页</a>
                <a href="/teacher/list" class="btn-secondary">查看教师列表</a>
            </div>
        </div>
    </div>

    <script>
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');
        const progressArea = document.getElementById('progressArea');
        const progressFill = document.getElementById('progressFill');
        const progressText = document.getElementById('progressText');
        const resultArea = document.getElementById('resultArea');
        const resultContent = document.getElementById('resultContent');

        // 拖拽上传
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                handleFile(files[0]);
            }
        });

        // 文件选择
        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleFile(e.target.files[0]);
            }
        });

        function handleFile(file) {
            // 验证文件类型
            if (!file.name.toLowerCase().endsWith('.csv')) {
                alert('请选择CSV文件');
                return;
            }

            // 验证文件大小（5MB）
            if (file.size > 5 * 1024 * 1024) {
                alert('文件大小不能超过5MB');
                return;
            }

            uploadFile(file);
        }

        function uploadFile(file) {
            const formData = new FormData();
            formData.append('file', file);

            // 显示进度条
            uploadArea.style.display = 'none';
            progressArea.style.display = 'block';
            resultArea.style.display = 'none';

            // 模拟进度
            let progress = 0;
            const progressInterval = setInterval(() => {
                progress += Math.random() * 20;
                if (progress > 90) progress = 90;
                progressFill.style.width = progress + '%';
            }, 200);

            fetch('/importExport/importTeachers', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                clearInterval(progressInterval);
                progressFill.style.width = '100%';
                progressText.textContent = '上传完成';

                setTimeout(() => {
                    showResult(data);
                }, 500);
            })
            .catch(error => {
                clearInterval(progressInterval);
                showResult({
                    success: false,
                    message: '上传失败：' + error.message
                });
            });
        }

        function showResult(data) {
            progressArea.style.display = 'none';
            resultArea.style.display = 'block';

            if (data.success) {
                let html = '<div class="result-success">' +
                    '<h3>✅ 导入成功</h3>' +
                    '<p>' + (data.message || '') + '</p>' +
                    '<p>成功导入：' + (data.successCount || 0) + ' 条</p>' +
                    '<p>失败：' + (data.failCount || 0) + ' 条</p>';

                if (data.errors && data.errors.length > 0) {
                    html += '<div class="error-list">' +
                        '<h4>错误详情：</h4>';
                    for (let i = 0; i < data.errors.length; i++) {
                        html += '<div class="error-item">' + data.errors[i] + '</div>';
                    }
                    html += '</div>';
                }

                html += '</div>';
                resultContent.innerHTML = html;
            } else {
                resultContent.innerHTML = '<div class="result-error">' +
                    '<h3>❌ 导入失败</h3>' +
                    '<p>' + (data.message || '未知错误') + '</p>' +
                    '</div>';
            }
        }
    </script>
</body>
</html>