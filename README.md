# 学生社会实践管理系统

## 项目简介

学生社会实践管理系统是一个基于 SSM（Spring + Spring MVC + MyBatis）架构开发的 Web 应用系统，旨在帮助高校管理学生的社会实践活动。系统支持管理员、教师、学生三种角色，实现了活动发布、报名审核、小组管理、任务跟踪、报告提交、成绩评定等完整的业务流程。

## 技术栈

| 技术组件 | 版本 | 说明 |
|---------|------|------|
| Java | 11 | 开发语言 |
| Spring | 5.2.9.RELEASE | IoC容器、事务管理 |
| Spring MVC | 5.2.9.RELEASE | Web MVC框架 |
| MyBatis | 3.5.6 | ORM持久层框架 |
| MyBatis-Spring | 1.3.2 | 框架整合 |
| MySQL | 8.0.33 | 数据库 |
| Druid | 1.2.8 | 数据库连接池 |
| Tomcat | 9.0.50 (内嵌) | Web服务器 |
| JSP + JSTL | 1.2.6 | 视图层 |
| Jackson | 2.12.3 | JSON处理 |
| Log4j | 1.2.17 | 日志框架 |

## 系统功能

### 角色权限

| 角色 | 权限说明 |
|------|---------|
| 管理员 (admin) | 用户管理、活动管理、公告管理、系统配置、数据导入导出 |
| 教师 (teacher) | 发布活动、审核报名、查看学生任务、审核报告、成绩评定 |
| 学生 (student) | 浏览活动、报名参加、创建/加入小组、提交日常任务、提交报告、查看成绩 |

### 核心功能模块

1. 用户管理：用户注册、登录、角色权限控制
2. 活动管理：活动发布、编辑、删除、状态管理（招募中/进行中/已结束）
3. 报名管理：学生报名、教师审核（通过/拒绝）
4. 小组管理：创建小组、加入小组、退出小组（仅审核通过的学生可操作）
5. 日常任务：任务提交、任务查看
6. 实践报告：报告提交、教师审核、反馈
7. 成绩评定：教师评分、成绩查询
8. 公告管理：公告发布、查看

## 环境要求

- JDK: 11 或更高版本
- MySQL: 8.0 或更高版本
- Maven: 3.6 或更高版本
- 操作系统: Windows / Linux / macOS

## 快速开始

### 1. 克隆项目

```bash
git clone <项目地址>
cd SocialPractice
```

### 2. 配置数据库

#### 2.1 创建数据库

使用 MySQL 客户端连接数据库，执行以下命令创建数据库：

```sql
CREATE DATABASE IF NOT EXISTS student_practice 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;
```

#### 2.2 导入表结构和测试数据

项目根目录下的 `db_schema.sql` 文件包含测试数据。在导入前请确保数据库表结构已创建。

```bash
mysql -u root -p student_practice < db_schema.sql
```

#### 2.3 修改数据库配置

编辑 `src/main/resources/jdbc.properties` 文件，配置数据库连接信息：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/student_practice?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
jdbc.username=root
jdbc.password=你的密码
```

### 3. 编译项目

```bash
mvn clean compile
```

### 4. 运行项目

```bash
mvn exec:java -Dexec.mainClass=com.ssm.Application
```

### 5. 访问系统

打开浏览器，访问：http://localhost:8080

## 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |
| 教师 | teacher1 | 123456 |
| 教师 | teacher2 | 123456 |
| 学生 | student1 | 123456 |
| 学生 | student2 | 123456 |
| 学生 | student3 | 123456 |

## 项目结构

```
SocialPractice/
├── src/
│   └── main/
│       ├── java/com/ssm/
│       │   ├── Application.java          # 应用启动入口
│       │   ├── controller/               # 控制器层
│       │   │   ├── UserController.java
│       │   │   ├── ActivityController.java
│       │   │   ├── StudentActivityController.java
│       │   │   ├── GroupController.java
│       │   │   ├── DailyTaskController.java
│       │   │   ├── PracticeReportController.java
│       │   │   ├── GradeController.java
│       │   │   ├── NoticeController.java
│       │   │   └── ...
│       │   ├── service/                  # 服务层接口
│       │   │   └── impl/                 # 服务层实现
│       │   ├── dao/                      # 数据访问层接口
│       │   ├── entity/                   # 实体类
│       │   ├── interceptor/              # 拦截器
│       │   └── utils/                    # 工具类
│       ├── resources/
│       │   ├── applicationContext.xml    # Spring配置
│       │   ├── springmvc.xml             # Spring MVC配置
│       │   ├── mybatis-config.xml        # MyBatis配置
│       │   ├── jdbc.properties           # 数据库配置
│       │   ├── log4j.properties          # 日志配置
│       │   └── mapper/                   # MyBatis映射文件
│       └── webapp/
│           └── WEB-INF/views/            # JSP视图
│               ├── admin/                # 管理员视图
│               ├── teacher/              # 教师视图
│               ├── student/              # 学生视图
│               ├── activity/             # 活动相关视图
│               ├── group/                # 小组相关视图
│               └── ...
├── db_schema.sql                                # 数据库测试数据
├── pom.xml                               # Maven配置
└── README.md                             # 项目说明
```

## 业务流程

### 学生报名与小组创建流程

```
1. 学生浏览活动列表
       ↓
2. 选择"招募中"状态的活动点击报名
       ↓
3. 报名状态变为"待审核"
       ↓
4. 教师在"报名管理"中审核
       ↓
   ┌─────┴─────┐
   ↓           ↓
通过(status=1)  拒绝(status=2)
   ↓
5. 学生进入"小组管理"
       ↓
6. 选择已通过审核的活动
       ↓
7. 创建新小组 或 加入已有小组
```

## API 接口说明

### 用户相关
- `POST /user/login` - 用户登录
- `POST /user/register` - 用户注册
- `GET /user/logout` - 用户登出

### 活动相关
- `GET /activity/list` - 活动列表
- `POST /activity/add` - 添加活动
- `POST /activity/edit` - 编辑活动
- `POST /activity/delete` - 删除活动

### 报名相关
- `POST /studentActivity/register` - 学生报名
- `POST /studentActivity/cancel` - 取消报名
- `POST /studentActivity/approve` - 审核通过
- `POST /studentActivity/reject` - 审核拒绝
- `GET /studentActivity/myActivities` - 我的活动

### 小组相关
- `GET /group/manage` - 小组管理页面
- `POST /group/create` - 创建小组
- `POST /group/join` - 加入小组
- `POST /group/leave` - 退出小组
- `POST /group/delete` - 解散小组

## 常见问题

### Q1: 启动时报错 "Table 'xxx' doesn't exist"
解决方案：请确保已正确导入数据库表结构和测试数据。

### Q2: 数据库连接失败
解决方案：
1. 检查 MySQL 服务是否启动
2. 检查 `jdbc.properties` 中的用户名和密码是否正确
3. 检查数据库名称是否为 `student_practice`

### Q3: 端口 8080 被占用
解决方案：
1. 关闭占用 8080 端口的程序
2. 或修改 `Application.java` 中的端口配置

### Q4: 学生无法创建小组
解决方案：学生必须先报名活动，并且教师审核通过后才能创建或加入小组。

## 开发说明

### 添加新功能
1. 在 `entity` 包下创建实体类
2. 在 `dao` 包下创建 DAO 接口
3. 在 `mapper` 目录下创建对应的 XML 映射文件
4. 在 `service` 包下创建服务接口和实现类
5. 在 `controller` 包下创建控制器
6. 在 `views` 目录下创建 JSP 视图

### 代码规范
- 遵循阿里巴巴 Java 开发规范
- Controller 层只做请求转发，业务逻辑放在 Service 层
- 使用事务注解 `@Transactional` 管理数据库事务

## 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| v1.0.0 | 2025-12 | 初始版本，实现基础功能 |

