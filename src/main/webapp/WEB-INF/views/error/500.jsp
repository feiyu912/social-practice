<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>服务器内部错误 - 学生社会实践管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-container {
            text-align: center;
            padding: 40px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .error-code {
            font-size: 72px;
            font-weight: bold;
            color: #ff4d4f;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        .error-description {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }
        .back-button {
            padding: 10px 20px;
            background-color: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-message">服务器内部错误</div>
        <div class="error-description">抱歉，服务器出现了内部错误，请稍后再试。</div>
        <a href="javascript:history.back()" class="back-button">返回上一页</a>
    </div>
</body>
</html>