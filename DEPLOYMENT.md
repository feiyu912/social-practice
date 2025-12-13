# 部署指南 (Deployment Guide)

本文档详细说明如何部署学生社会实践管理系统。

## 目录
- [环境准备](#环境准备)
- [开发环境部署](#开发环境部署)
- [生产环境部署](#生产环境部署)
- [数据库配置](#数据库配置)
- [常见问题](#常见问题)

---

## 环境准备

### 必需软件

| 软件 | 版本要求 | 下载地址 |
|------|---------|---------|
| JDK | 11 或更高 | https://adoptium.net/ |
| MySQL | 8.0 或更高 | https://dev.mysql.com/downloads/ |
| Maven | 3.6 或更高 | https://maven.apache.org/download.cgi |
| Git | 任意版本 | https://git-scm.com/downloads |

### 验证安装

```bash
# 验证 Java 版本
java -version

# 验证 Maven 版本
mvn -version

# 验证 MySQL 版本
mysql --version
```

---

## 开发环境部署

### 步骤 1: 获取源码

```bash
git clone <项目仓库地址>
cd SocialPractice
```

### 步骤 2: 配置数据库

1. 登录 MySQL：
```bash
mysql -u root -p
```

2. 创建数据库：
```sql
CREATE DATABASE IF NOT EXISTS student_practice 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;
```

3. 导入表结构和初始数据：
```bash
mysql -u root -p student_practice < db_schema.sql
```

### 步骤 3: 修改配置

编辑 `src/main/resources/jdbc.properties`：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/student_practice?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
jdbc.username=root
jdbc.password=你的数据库密码
```

### 步骤 4: 编译运行

```bash
# 编译项目
mvn clean compile

# 运行项目
mvn exec:java -Dexec.mainClass=com.ssm.Application
```

### 步骤 5: 访问系统

打开浏览器访问：http://localhost:8080

---

## 生产环境部署

### 方式一：直接运行 JAR 包

1. 打包项目：
```bash
mvn clean package -DskipTests
```

2. 运行 JAR：
```bash
java -jar target/test_spring_mybatis-1.0-SNAPSHOT.jar
```

### 方式二：使用系统服务（Linux）

1. 创建服务文件 `/etc/systemd/system/social-practice.service`：

```ini
[Unit]
Description=Social Practice Management System
After=network.target mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/social-practice
ExecStart=/usr/bin/java -jar /opt/social-practice/app.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

2. 启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable social-practice
sudo systemctl start social-practice
```

3. 查看状态：
```bash
sudo systemctl status social-practice
```

### 方式三：使用 Docker（推荐）

1. 创建 Dockerfile：
```dockerfile
FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/test_spring_mybatis-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

2. 构建镜像：
```bash
docker build -t social-practice:1.0 .
```

3. 运行容器：
```bash
docker run -d -p 8080:8080 --name social-practice social-practice:1.0
```

---

## 数据库配置

### 生产环境数据库建议

1. **创建专用用户**：
```sql
CREATE USER 'social_practice'@'localhost' IDENTIFIED BY '强密码';
GRANT ALL PRIVILEGES ON student_practice.* TO 'social_practice'@'localhost';
FLUSH PRIVILEGES;
```

2. **配置连接池**（applicationContext.xml）：
```xml
<property name="initialSize" value="5"/>
<property name="minIdle" value="5"/>
<property name="maxActive" value="20"/>
<property name="maxWait" value="60000"/>
```

3. **定期备份**：
```bash
# 每日备份脚本
mysqldump -u root -p student_practice > backup_$(date +%Y%m%d).sql
```

---

## 反向代理配置（Nginx）

如需使用 Nginx 作为反向代理：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 常见问题

### Q1: 端口 8080 被占用

**解决方案**：
- Windows: `netstat -ano | findstr 8080`
- Linux: `lsof -i:8080`

### Q2: 数据库连接失败

**检查项**：
1. MySQL 服务是否启动
2. 用户名密码是否正确
3. 数据库是否存在
4. 防火墙是否开放 3306 端口

### Q3: 编译失败

**解决方案**：
```bash
# 清理并重新下载依赖
mvn clean install -U
```

### Q4: 内存不足

**解决方案**：
```bash
# 增加 JVM 内存
java -Xms512m -Xmx1024m -jar app.jar
```

---

## 日志查看

日志文件位置：项目根目录下的 `logs/` 目录

查看实时日志：
```bash
tail -f logs/app.log
```

---

## 安全建议

1. 修改默认管理员密码
2. 使用 HTTPS 加密传输
3. 定期更新依赖版本
4. 限制数据库远程访问
5. 配置防火墙规则
