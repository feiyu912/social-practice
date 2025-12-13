# 学生社会实践管理系统 - 项目报告

## 一、采用的技术和框架

### 1.1 后端技术栈
| 技术 | 版本 | 说明 |
|------|------|------|
| Java | JDK 11 | 编程语言 |
| Spring Framework | 5.2.9.RELEASE | IoC容器和AOP框架 |
| Spring MVC | 5.2.9.RELEASE | Web MVC框架 |
| MyBatis | 3.5.6 | ORM持久层框架 |
| MySQL | 8.0.33 | 关系型数据库 |
| Druid | 1.2.8 | 数据库连接池 |
| Log4j | 1.2.17 | 日志框架 |
| JSTL | 1.2 | JSP标准标签库 |

### 1.2 前端技术栈
| 技术 | 说明 |
|------|------|
| JSP | Java Server Pages动态页面技术 |
| HTML5/CSS3 | 页面结构和样式 |
| JavaScript | 前端交互逻辑 |
| Fetch API | 异步请求处理 |

### 1.3 项目架构
```
项目采用典型的SSM（Spring + Spring MVC + MyBatis）三层架构：

┌─────────────────────────────────────────────────────────┐
│                    表现层 (Presentation)                  │
│  JSP页面 + JavaScript + CSS                             │
├─────────────────────────────────────────────────────────┤
│                    控制层 (Controller)                    │
│  Spring MVC Controller处理HTTP请求                       │
├─────────────────────────────────────────────────────────┤
│                    业务层 (Service)                       │
│  Service接口 + ServiceImpl实现类                         │
├─────────────────────────────────────────────────────────┤
│                    持久层 (DAO)                           │
│  MyBatis Mapper接口 + XML映射文件                        │
├─────────────────────────────────────────────────────────┤
│                    数据库 (Database)                      │
│  MySQL 8.0                                              │
└─────────────────────────────────────────────────────────┘
```

---

## 二、实现的主要功能

### 2.1 系统功能模块

#### 2.1.1 用户管理模块
- **用户注册**：支持学生和教师自主注册，填写基本信息
- **用户登录**：基于Session的身份认证
- **权限控制**：基于角色的访问控制（RBAC），区分学生、教师、管理员三种角色
- **个人信息管理**：查看和修改个人信息

#### 2.1.2 教师功能模块
- **发布活动**：创建新的社会实践活动，设置活动详情
- **活动管理**：编辑、删除自己负责的活动
- **报名审核**：审核学生的活动报名申请（通过/拒绝）
- **成绩评定**：为参与活动的学生评分，支持多教师评分取平均
- **日常管理**：查看学生提交的日常任务
- **报告审核**：审核学生提交的实践报告

#### 2.1.3 学生功能模块
- **活动浏览**：查看所有可报名的社会实践活动
- **活动报名**：报名参加招募中的活动
- **改选/退选**：待审核状态可以退选或改选活动
- **小组管理**：创建小组或加入已有小组
- **日常任务**：填写和提交日常任务完成情况
- **实践报告**：提交实践报告，查看教师反馈
- **成绩查询**：查看各项活动的成绩和教师评语

#### 2.1.4 管理员功能模块
- **用户管理**：管理学生和教师信息
- **活动管理**：管理所有社会实践活动
- **数据导入**：批量导入学生和教师名单（CSV格式）
- **成绩导出**：导出活动成绩单
- **公告管理**：发布系统公告
- **系统日志**：查看系统操作日志

### 2.2 特色功能

1. **多教师负责活动**：一个活动可由多位教师共同负责管理
2. **多教师评分取平均**：多位教师可分别给学生评分，最终成绩取平均值
3. **小组协作**：学生可组建小组，支持小组评分
4. **报名审核机制**：学生报名需教师审核，保证活动质量
5. **拖拽上传**：支持拖拽文件进行批量导入

---

## 三、数据库设计

### 3.1 数据库表结构

#### 核心表（14张表）

| 序号 | 表名 | 说明 | 主要字段 |
|------|------|------|----------|
| 1 | user | 用户表 | id, username, password, role, name, status |
| 2 | teacher | 教师表 | id, user_id, teacher_id, department |
| 3 | student | 学生表 | id, user_id, student_id, class_name |
| 4 | practice_activity | 实践活动表 | id, title, description, start_time, end_time, quota, status |
| 5 | activity_teacher | 活动-教师关联表 | id, activity_id, teacher_id |
| 6 | student_activity | 学生活动报名表 | id, student_id, activity_id, group_id, status |
| 7 | group_info | 小组信息表 | group_id, activity_id, group_name, leader_id |
| 8 | daily_task | 日常任务表 | id, student_id, activity_id, content, status |
| 9 | practice_report | 实践报告表 | report_id, student_id, activity_id, title, content, status |
| 10 | grade_info | 成绩信息表 | grade_id, student_id, activity_id, teacher_id, score |
| 11 | notice | 公告表 | id, title, content, publisher_id, status |
| 12 | system_log | 系统日志表 | id, user_id, operation, create_time |

#### 视图

| 视图名 | 说明 |
|--------|------|
| v_student_grade_summary | 学生成绩汇总视图（多教师评分取平均） |
| v_activity_statistics | 活动参与统计视图 |

### 3.2 ER图关系说明

```
User (1) ──── (1) Teacher     用户与教师一对一
User (1) ──── (1) Student     用户与学生一对一

PracticeActivity (N) ──── (N) Teacher     活动与教师多对多（通过activity_teacher）
PracticeActivity (1) ──── (N) StudentActivity     活动与报名一对多
Student (1) ──── (N) StudentActivity     学生与报名一对多

StudentActivity (N) ──── (1) GroupInfo     报名与小组多对一
GradeInfo (N) ──── (1) Student     成绩与学生多对一
GradeInfo (N) ──── (1) Teacher     成绩与教师多对一（支持多教师评分）
```

---

## 四、核心源代码注释说明

### 4.1 权限控制拦截器（AuthInterceptor.java）

```java
package com.ssm.interceptor;

/**
 * 权限拦截器 - 实现基于角色的访问控制（RBAC）
 * 
 * 设计思路：
 * 1. 拦截所有HTTP请求，在Controller处理之前进行权限验证
 * 2. 根据用户角色（student/teacher/admin）控制可访问的URL路径
 * 3. 未登录用户自动重定向到登录页面
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, 
                            HttpServletResponse response, 
                            Object handler) throws Exception {
        // 获取当前会话中的用户信息
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 获取请求路径
        String requestURI = request.getRequestURI();
        String path = requestURI.substring(request.getContextPath().length());
        
        // 白名单：允许未登录访问的路径
        if (path.startsWith("/login") || path.startsWith("/user/login") || 
            path.startsWith("/user/register") || path.startsWith("/static/")) {
            return true;  // 放行
        }
        
        // 未登录检查
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;  // 拦截
        }
        
        String role = user.getRole();
        
        // 学生权限控制：只能访问活动浏览、报名、日常任务、报告等功能
        if ("student".equals(role)) {
            if (path.startsWith("/activity/list") || 
                path.startsWith("/studentActivity/") ||
                path.startsWith("/dailyTask/") ||
                path.startsWith("/group/")) {
                return true;
            }
            // 禁止访问管理功能
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        // 教师权限控制：可以管理自己负责的活动
        if ("teacher".equals(role)) {
            if (path.startsWith("/activity/") || 
                path.startsWith("/grade/") ||
                path.startsWith("/practiceReport/")) {
                return true;  // 具体权限在Controller中二次验证
            }
        }
        
        // 管理员：拥有所有权限
        if ("admin".equals(role)) {
            return true;
        }
        
        return false;
    }
}
```

### 4.2 多教师评分服务实现（GradeInfoServiceImpl.java）

```java
package com.ssm.service.impl;

/**
 * 成绩信息服务实现类
 * 
 * 核心特性：
 * 1. 支持多教师对同一学生的同一活动分别评分
 * 2. 自动计算多位教师评分的平均值
 * 3. 支持小组批量评分功能
 */
@Service
@Transactional
public class GradeInfoServiceImpl implements GradeInfoService {

    @Autowired
    private GradeInfoDAO gradeInfoDAO;
    
    @Autowired
    private StudentActivityDAO studentActivityDAO;

    /**
     * 检查某教师是否已对该学生的该活动评分
     * 关键设计：允许多教师评分，但同一教师只能评分一次
     */
    @Override
    public boolean hasGradeByTeacher(Integer studentId, Integer activityId, 
                                     Integer teacherId) {
        return gradeInfoDAO.findByStudentAndActivityAndTeacher(
            studentId, activityId, teacherId) != null;
    }

    /**
     * 获取某学生在某活动的平均成绩
     * 核心算法：查询所有教师的评分，计算算术平均值
     */
    @Override
    public Double getAverageScoreByStudentAndActivity(Integer studentId, 
                                                       Integer activityId) {
        return gradeInfoDAO.getAverageScoreByStudentAndActivity(studentId, activityId);
    }

    /**
     * 小组批量评分功能
     * 业务逻辑：
     * 1. 获取小组所有成员ID
     * 2. 遍历每个成员，检查是否已被该教师评分
     * 3. 未评分的成员自动添加评分记录
     */
    @Override
    public int gradeGroup(Integer groupId, Integer activityId, 
                          Integer teacherId, Double score, String comment) {
        // 获取小组所有成员
        List<Integer> members = studentActivityDAO.findByGroupId(groupId);
        if (members == null || members.isEmpty()) {
            return 0;
        }

        int count = 0;
        Date now = new Date();
        
        for (Integer studentId : members) {
            // 避免重复评分
            if (!hasGradeByTeacher(studentId, activityId, teacherId)) {
                GradeInfo gradeInfo = new GradeInfo();
                gradeInfo.setStudentId(studentId);
                gradeInfo.setActivityId(activityId);
                gradeInfo.setTeacherId(teacherId);
                gradeInfo.setScore(score);
                gradeInfo.setComment(comment);
                gradeInfo.setGradeTime(now);

                if (gradeInfoDAO.insert(gradeInfo) > 0) {
                    count++;
                }
            }
        }
        return count;
    }
}
```

### 4.3 活动教师自动关联（ActivityController.java）

```java
/**
 * 处理添加活动的POST请求
 * 
 * 关键逻辑：教师创建活动时，自动将该教师添加为活动负责人
 * 这样教师创建的活动会自动出现在"我的活动"列表中
 */
@RequestMapping(value = "add", method = RequestMethod.POST)
public String doAdd(@RequestParam("activityName") String activityName,
                   /* 其他参数... */
                   HttpSession session, Model model) {
    // 权限检查
    if (!permissionUtils.isTeacher(session) && !permissionUtils.isAdmin(session)) {
        return "error/403";
    }

    // 创建活动对象并设置属性
    PracticeActivity activity = new PracticeActivity();
    activity.setActivityName(activityName);
    // ... 设置其他属性

    // 保存活动到数据库
    boolean success = practiceActivityService.addActivity(activity);
    
    if (success) {
        // 关键步骤：如果是教师创建的活动，自动关联该教师
        User user = (User) session.getAttribute("user");
        if (user != null && "teacher".equals(user.getRole())) {
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null && activity.getId() != null) {
                // 创建活动-教师关联记录
                ActivityTeacher at = new ActivityTeacher();
                at.setActivityId(activity.getId());
                at.setTeacherId(teacher.getId());
                activityTeacherDAO.insert(at);
            }
        }
        return "redirect:list";
    }
    return "activity/add";
}
```

### 4.4 MyBatis多教师查询映射（PracticeActivityMapper.xml）

```xml
<!-- 
    查询活动并关联所有负责教师
    技术要点：
    1. 使用子查询获取活动的所有负责教师姓名
    2. GROUP_CONCAT函数将多个教师姓名合并为逗号分隔的字符串
    3. 通过activity_teacher关联表实现多对多关系
-->
<select id="findById" parameterType="Integer" resultMap="PracticeActivityResultMap">
    SELECT pa.*, 
           <!-- 子查询：获取所有负责教师的姓名 -->
           (SELECT GROUP_CONCAT(u.name) 
            FROM activity_teacher at 
            JOIN teacher t ON at.teacher_id = t.id 
            JOIN user u ON t.user_id = u.id 
            WHERE at.activity_id = pa.id) as responsible_person
    FROM practice_activity pa 
    WHERE pa.id = #{activityId}
</select>

<!-- 
    查询教师负责的所有活动
    通过activity_teacher中间表关联查询
-->
<select id="findByTeacherId" resultMap="PracticeActivityResultMap">
    SELECT pa.*, 
           (SELECT GROUP_CONCAT(u.name) 
            FROM activity_teacher at2 
            JOIN teacher t ON at2.teacher_id = t.id 
            JOIN user u ON t.user_id = u.id 
            WHERE at2.activity_id = pa.id) as responsible_person
    FROM practice_activity pa
    JOIN activity_teacher at ON pa.id = at.activity_id
    WHERE at.teacher_id = #{teacherId}
    ORDER BY pa.create_time DESC 
    LIMIT #{offset}, #{limit}
</select>
```

---

## 五、运行结果展示

### 5.1 登录页面
- 支持学生、教师、管理员三种角色登录
- 提供用户注册入口
- 测试账号：admin/teacher1/student1，密码统一为123456

### 5.2 管理员首页
- 显示系统统计数据（学生总数、教师总数、活动总数）
- 功能卡片快速导航到各管理模块
- 左侧菜单包含完整的管理功能入口

### 5.3 教师首页
- 显示负责的活动数、待审核报告数、待评定成绩数
- 快速访问活动发布、报名管理、成绩评定等功能

### 5.4 学生首页
- 显示已报名活动数、待完成任务数、已提交报告数
- 快速访问活动浏览、小组管理、日常任务等功能

### 5.5 活动管理
- 活动列表展示：名称、类型、时间、负责人、名额、状态
- 支持搜索和筛选功能
- 教师只能看到自己负责的活动

### 5.6 成绩管理
- 支持多教师评分，显示各教师评分详情
- 自动计算平均分
- 成绩导出为CSV格式

---

## 六、项目总结

### 6.1 项目成果

1. **完整的功能实现**
   - 实现了用户管理、活动管理、报名审核、成绩评定等核心功能
   - 支持学生、教师、管理员三种角色的差异化功能

2. **良好的技术架构**
   - 采用成熟的SSM框架，代码结构清晰
   - 分层设计，Controller、Service、DAO职责明确
   - 使用拦截器实现统一的权限控制

3. **特色功能亮点**
   - 多教师负责活动，多教师评分取平均
   - 学生小组协作功能
   - 批量导入导出功能

4. **用户体验优化**
   - 根据不同角色展示不同界面和功能
   - 响应式表单验证和错误提示
   - 拖拽文件上传功能

### 6.2 存在的不足

1. **安全性方面**
   - 密码未加密存储，生产环境需使用BCrypt等加密算法
   - 缺少CSRF防护机制
   - 未实现验证码功能

2. **功能完善度**
   - 文件上传功能未完全实现（如报告附件）
   - 缺少消息通知功能
   - 未实现数据统计图表展示

3. **性能优化**
   - 未实现分页查询的缓存机制
   - 部分复杂查询可进一步优化

4. **前端技术**
   - 采用传统JSP，可考虑升级为Vue.js或React
   - CSS样式分散在各页面，可提取为公共样式文件

### 6.3 改进建议

1. 引入Spring Security实现更完善的安全控制
2. 使用Redis缓存提升系统性能
3. 前后端分离，采用RESTful API设计
4. 增加数据统计和可视化图表
5. 实现邮件/短信通知功能
6. 添加操作日志详细记录

---

## 附录：项目目录结构

```
SocialPractice/
├── src/main/
│   ├── java/com/ssm/
│   │   ├── controller/          # 控制器层
│   │   ├── service/             # 业务逻辑层
│   │   │   └── impl/           # 服务实现类
│   │   ├── dao/                 # 数据访问层接口
│   │   ├── entity/              # 实体类
│   │   ├── interceptor/         # 拦截器
│   │   ├── utils/               # 工具类
│   │   └── Application.java     # 启动类
│   ├── resources/
│   │   ├── mapper/              # MyBatis映射文件
│   │   ├── applicationContext.xml
│   │   ├── springmvc.xml
│   │   └── mybatis-config.xml
│   └── webapp/
│       └── WEB-INF/
│           ├── views/           # JSP视图
│           └── web.xml
├── db_schema.sql               # 数据库脚本
├── pom.xml                     # Maven配置
└── PROJECT_REPORT.md           # 项目报告
```

---

**报告完成时间：2024年12月**
