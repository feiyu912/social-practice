# 数据库设计文档

## 📋 目录

- [数据库概述](#数据库概述)
- [数据表结构](#数据表结构)
- [视图设计](#视图设计)
- [索引设计](#索引设计)
- [数据关系图](#数据关系图)
- [测试数据说明](#测试数据说明)

---

## 数据库概述

### 基本信息

- **数据库名称**: `student_practice`
- **字符集**: `utf8mb4`
- **排序规则**: `utf8mb4_unicode_ci`
- **引擎**: InnoDB
- **数据表数量**: 12张
- **视图数量**: 2个

### 设计原则

1. **规范化设计**: 符合第三范式（3NF），避免数据冗余
2. **外键约束**: 使用外键保证数据一致性，级联删除相关数据
3. **索引优化**: 为常用查询字段创建索引，提升查询性能
4. **字段命名**: 采用下划线命名法（snake_case），清晰易懂
5. **时间戳**: 所有表都包含创建时间和更新时间字段

---

## 数据表结构

### 1. user - 用户表

用于存储所有用户的基本登录信息。

```sql
CREATE TABLE `user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `email` VARCHAR(100) COMMENT '邮箱',
  `phone` VARCHAR(20) COMMENT '手机号码',
  `role` VARCHAR(20) NOT NULL DEFAULT 'student' COMMENT '角色(admin/teacher/student)',
  `status` TINYINT(4) NOT NULL DEFAULT 1 COMMENT '状态(0:禁用,1:启用)',
  `name` VARCHAR(50) COMMENT '真实姓名',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
```

**字段说明**：
- `id`: 自增主键
- `username`: 登录用户名，唯一约束
- `password`: 密码（建议加密存储，当前为明文）
- `role`: 用户角色（admin/teacher/student）
- `status`: 账号状态（0禁用，1启用）

**索引**：
- PRIMARY KEY: `id`
- UNIQUE KEY: `username`
- INDEX: `role`, `status`

---

### 2. teacher - 教师表

存储教师的扩展信息。

```sql
CREATE TABLE `teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户ID',
  `teacher_id` VARCHAR(20) COMMENT '教师工号',
  `real_name` VARCHAR(50) COMMENT '真实姓名',
  `department` VARCHAR(50) COMMENT '所属院系',
  `phone` VARCHAR(20) COMMENT '联系电话',
  `email` VARCHAR(100) COMMENT '电子邮箱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_teacher_id` (`teacher_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';
```

**字段说明**：
- `user_id`: 关联user表，一对一关系
- `teacher_id`: 教师工号，唯一约束
- `department`: 所属院系

**外键**：
- `user_id` → `user.id` (CASCADE DELETE)

---

### 3. student - 学生表

存储学生的扩展信息。

```sql
CREATE TABLE `student` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户ID',
  `student_id` VARCHAR(20) COMMENT '学号',
  `real_name` VARCHAR(50) COMMENT '真实姓名',
  `gender` VARCHAR(10) COMMENT '性别',
  `class_name` VARCHAR(50) COMMENT '班级',
  `phone` VARCHAR(20) COMMENT '联系电话',
  `email` VARCHAR(100) COMMENT '电子邮箱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_student_id` (`student_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';
```

**字段说明**：
- `user_id`: 关联user表，一对一关系
- `student_id`: 学号，唯一约束
- `gender`: 性别
- `class_name`: 班级

**外键**：
- `user_id` → `user.id` (CASCADE DELETE)

---

### 4. practice_activity - 实践活动表

存储所有社会实践活动信息。

```sql
CREATE TABLE `practice_activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '活动标题',
  `activity_name` VARCHAR(100) COMMENT '活动名称',
  `description` TEXT COMMENT '活动描述',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `end_time` DATETIME NOT NULL COMMENT '结束时间',
  `location` VARCHAR(100) COMMENT '活动地点',
  `quota` INT(11) NOT NULL DEFAULT 0 COMMENT '名额限制',
  `current_count` INT(11) NOT NULL DEFAULT 0 COMMENT '当前报名人数',
  `status` VARCHAR(20) NOT NULL DEFAULT 'recruiting' COMMENT '状态(recruiting/ongoing/finished)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实践活动表';
```

**字段说明**：
- `quota`: 招募最大人数
- `current_count`: 当前已通过审核的报名人数
- `status`: 活动状态
  - `recruiting`: 招募中
  - `ongoing`: 进行中
  - `finished`: 已结束

**索引**：
- INDEX: `status`, `start_time`, `end_time`

---

### 5. activity_teacher - 活动教师关联表

存储活动与教师的多对多关联关系。

```sql
CREATE TABLE `activity_teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '教师ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_teacher` (`activity_id`, `teacher_id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动-教师关联表';
```

**字段说明**：
- 联合唯一约束：一个活动的一个教师只能有一条记录
- 支持一个活动由多位教师负责

**外键**：
- `activity_id` → `practice_activity.id` (CASCADE DELETE)
- `teacher_id` → `teacher.id` (CASCADE DELETE)

---

### 6. student_activity - 学生报名表

存储学生活动报名信息。

```sql
CREATE TABLE `student_activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_id` INT(11) COMMENT '小组ID',
  `status` TINYINT(4) NOT NULL DEFAULT 0 COMMENT '状态(0:待审核,1:已通过,2:已拒绝)',
  `join_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_activity` (`student_id`, `activity_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生活动报名表';
```

**字段说明**：
- `status`: 报名状态
  - `0`: 待审核
  - `1`: 已通过
  - `2`: 已拒绝
- `group_id`: 关联小组ID（可为空）

**约束**：
- 一个学生对同一活动只能报名一次（联合唯一约束）

**索引**：
- INDEX: `activity_id`, `status`

---

### 7. group_info - 小组信息表

存储学生实践小组信息。

```sql
CREATE TABLE `group_info` (
  `group_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '小组ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_name` VARCHAR(255) NOT NULL COMMENT '小组名称',
  `leader_id` INT(11) NOT NULL COMMENT '组长ID(学生ID)',
  `member_count` INT(11) DEFAULT 1 COMMENT '成员数量',
  `max_members` INT(11) DEFAULT 10 COMMENT '最大成员数',
  `status` TINYINT(4) DEFAULT 0 COMMENT '状态(0:未开始,1:进行中,2:已完成)',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `uk_activity_group` (`activity_id`, `group_name`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`leader_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组信息表';
```

**字段说明**：
- `leader_id`: 组长（学生ID）
- `member_count`: 当前成员数
- `max_members`: 最大成员数（默认10人）

**约束**：
- 同一活动中的小组名称唯一

**索引**：
- INDEX: `leader_id`

---

### 8. daily_task - 日常任务表

存储学生提交的日常任务记录。

```sql
CREATE TABLE `daily_task` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `task_date` DATE NOT NULL COMMENT '任务日期',
  `content` TEXT COMMENT '任务内容',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态(pending/completed)',
  `submit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日常任务表';
```

**字段说明**：
- `task_date`: 任务对应的日期
- `status`: 任务状态
  - `pending`: 待处理
  - `completed`: 已完成

**索引**：
- INDEX: `student_id`, `activity_id`, `status`

---

### 9. practice_report - 实践报告表

存储学生提交的实践报告。

```sql
CREATE TABLE `practice_report` (
  `report_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '报告ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '报告标题',
  `content` TEXT COMMENT '报告内容',
  `attachment` VARCHAR(200) COMMENT '附件路径',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态(pending/reviewed)',
  `feedback` TEXT COMMENT '教师反馈',
  `submit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `uk_student_activity_report` (`student_id`, `activity_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实践报告表';
```

**字段说明**：
- `attachment`: 上传的附件文件路径
- `status`: 审核状态
  - `pending`: 待审核
  - `reviewed`: 已审核
- `feedback`: 教师的反馈意见

**约束**：
- 一个学生对一个活动只能提交一份报告

**索引**：
- INDEX: `status`

---

### 10. grade_info - 成绩信息表

存储教师对学生的评分信息（支持多教师评分）。

```sql
CREATE TABLE `grade_info` (
  `grade_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '评分教师ID',
  `score` DECIMAL(5,2) DEFAULT 0 COMMENT '分数',
  `comment` TEXT COMMENT '评语',
  `grade_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`grade_id`),
  UNIQUE KEY `uk_student_activity_teacher` (`student_id`, `activity_id`, `teacher_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩信息表';
```

**字段说明**：
- `score`: 分数（0-100，保留两位小数）
- `comment`: 教师评语

**约束**：
- 联合唯一约束：一个教师对同一学生的同一活动只能评分一次
- 支持多个教师对同一学生评分

**索引**：
- INDEX: `activity_id`, `teacher_id`

---

### 11. notice - 公告表

存储系统公告信息。

```sql
CREATE TABLE `notice` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` VARCHAR(100) NOT NULL COMMENT '公告标题',
  `content` TEXT COMMENT '公告内容',
  `publisher_id` INT(11) NOT NULL COMMENT '发布者ID',
  `status` VARCHAR(20) DEFAULT 'draft' COMMENT '状态(draft/published)',
  `publish_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`publisher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';
```

**字段说明**：
- `publisher_id`: 发布者用户ID（通常是管理员）
- `status`: 公告状态
  - `draft`: 草稿
  - `published`: 已发布
- `publish_time`: 发布时间

**索引**：
- INDEX: `status`, `publish_time`

---

### 12. system_log - 系统日志表

记录用户操作日志。

```sql
CREATE TABLE `system_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` INT(11) COMMENT '操作用户ID',
  `username` VARCHAR(50) COMMENT '操作用户名',
  `operation` VARCHAR(100) NOT NULL COMMENT '操作描述',
  `method` VARCHAR(200) COMMENT '请求方法',
  `params` TEXT COMMENT '请求参数',
  `ip` VARCHAR(50) COMMENT 'IP地址',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';
```

**字段说明**：
- `operation`: 操作描述（如"用户登录"、"创建活动"等）
- `method`: HTTP请求方法和路径
- `params`: 请求参数（JSON格式）
- `ip`: 客户端IP地址

**索引**：
- INDEX: `user_id`, `create_time`

---

## 视图设计

### 1. v_student_grade_summary - 学生成绩汇总视图

用于查询学生的综合成绩（多教师评分取平均）。

```sql
CREATE OR REPLACE VIEW `v_student_grade_summary` AS
SELECT 
    sa.student_id,
    sa.activity_id,
    s.student_id AS student_number,
    s.real_name AS student_name,
    pa.title AS activity_name,
    COUNT(gi.grade_id) AS teacher_count,           -- 评分教师数量
    AVG(gi.score) AS avg_score,                    -- 平均分
    MIN(gi.score) AS min_score,                    -- 最低分
    MAX(gi.score) AS max_score,                    -- 最高分
    GROUP_CONCAT(DISTINCT CONCAT(t.real_name, ':', gi.score) SEPARATOR '; ') AS teacher_scores,
    sa.status AS registration_status
FROM student_activity sa
JOIN student s ON sa.student_id = s.id
JOIN practice_activity pa ON sa.activity_id = pa.id
LEFT JOIN grade_info gi ON sa.student_id = gi.student_id AND sa.activity_id = gi.activity_id
LEFT JOIN teacher t ON gi.teacher_id = t.id
WHERE sa.status = 1  -- 只统计审核通过的学生
GROUP BY sa.student_id, sa.activity_id, s.student_id, s.real_name, pa.title, sa.status;
```

**用途**：
- 显示学生的平均成绩
- 显示各教师的评分详情
- 用于成绩查询和统计分析

**示例查询**：
```sql
-- 查询某个学生的所有成绩
SELECT * FROM v_student_grade_summary WHERE student_id = 1;

-- 查询某个活动的所有学生成绩
SELECT * FROM v_student_grade_summary WHERE activity_id = 1 ORDER BY avg_score DESC;
```

---

### 2. v_activity_statistics - 活动参与统计视图

用于统计活动的参与情况。

```sql
CREATE OR REPLACE VIEW `v_activity_statistics` AS
SELECT 
    pa.id AS activity_id,
    pa.title AS activity_name,
    pa.status,
    pa.quota AS max_participants,
    (SELECT COUNT(*) FROM student_activity WHERE activity_id = pa.id AND status = 1) AS approved_count,
    (SELECT COUNT(*) FROM student_activity WHERE activity_id = pa.id AND status = 0) AS pending_count,
    (SELECT COUNT(*) FROM student_activity WHERE activity_id = pa.id AND status = 2) AS rejected_count,
    (SELECT COUNT(*) FROM group_info WHERE activity_id = pa.id) AS group_count,
    (SELECT COUNT(*) FROM practice_report WHERE activity_id = pa.id) AS report_count,
    (SELECT COUNT(*) FROM practice_report WHERE activity_id = pa.id AND status = 'reviewed') AS reviewed_report_count,
    (SELECT GROUP_CONCAT(t.real_name SEPARATOR ', ') 
     FROM activity_teacher at 
     JOIN teacher t ON at.teacher_id = t.id 
     WHERE at.activity_id = pa.id) AS responsible_teachers
FROM practice_activity pa;
```

**用途**：
- 统计活动报名情况
- 统计活动小组数量
- 统计报告提交和审核情况
- 显示负责教师

**示例查询**：
```sql
-- 查询所有活动的统计信息
SELECT * FROM v_activity_statistics;

-- 查询报名人数超过20的活动
SELECT * FROM v_activity_statistics WHERE approved_count > 20;
```

---

## 索引设计

### 主键索引
所有表都有自增主键 `id` 或相应的主键字段。

### 唯一索引
- `user.username`: 用户名唯一
- `teacher.user_id`: 用户ID唯一
- `teacher.teacher_id`: 教师工号唯一
- `student.user_id`: 用户ID唯一
- `student.student_id`: 学号唯一
- `activity_teacher.(activity_id, teacher_id)`: 活动-教师联合唯一
- `student_activity.(student_id, activity_id)`: 学生-活动联合唯一
- `group_info.(activity_id, group_name)`: 活动-小组名联合唯一
- `practice_report.(student_id, activity_id)`: 学生-活动联合唯一
- `grade_info.(student_id, activity_id, teacher_id)`: 三者联合唯一

### 普通索引
- `user.role`: 角色查询
- `user.status`: 状态查询
- `practice_activity.status`: 活动状态查询
- `practice_activity.start_time`: 时间范围查询
- `practice_activity.end_time`: 时间范围查询
- `student_activity.activity_id`: 活动报名查询
- `student_activity.status`: 报名状态查询
- `group_info.leader_id`: 组长查询
- `daily_task.student_id`: 学生任务查询
- `daily_task.activity_id`: 活动任务查询
- `daily_task.status`: 任务状态查询
- `practice_report.status`: 报告状态查询
- `grade_info.activity_id`: 活动成绩查询
- `grade_info.teacher_id`: 教师评分查询
- `notice.status`: 公告状态查询
- `notice.publish_time`: 发布时间查询
- `system_log.user_id`: 用户日志查询
- `system_log.create_time`: 时间范围查询

---

## 数据关系图

```
user (1) ----< (1) teacher
  |
  +---- (1) ----< (1) student
  |
  +---- (1) ----< (*) notice

practice_activity (*) ----< (*) activity_teacher ----< (*) teacher
       |
       +---- (1) ----< (*) student_activity ----< (*) student
       |                         |
       |                         +---- (*) ----< (1) group_info
       |
       +---- (1) ----< (*) daily_task ----< (*) student
       |
       +---- (1) ----< (*) practice_report ----< (*) student
       |
       +---- (1) ----< (*) grade_info ----< (*) student
                              |
                              +---- (*) ----< (*) teacher
```

**关系说明**：
- `1:1` - 一对一关系（user ↔ teacher, user ↔ student）
- `1:*` - 一对多关系（activity ↔ student_activity）
- `*:*` - 多对多关系（activity ↔ teacher，通过activity_teacher表关联）

---

## 测试数据说明

### 用户数据（21个）
- **管理员**: 1个（admin）
- **教师**: 5个（teacher1-5）
- **学生**: 15个（student1-15）

### 活动数据（9个）
1. 暑期三下乡社会实践（招募中）
2. 企业参观实习（招募中）
3. 社区志愿服务（进行中）
4. 红色教育实践（已结束）
5. 科技创新实践（招募中）
6. 环保公益行动（进行中）
7. 文化遗产调研（已结束）
8. 乡村振兴调研（招募中）
9. 法律援助实践（进行中）

### 报名数据（28条）
- 已通过审核: 22条
- 待审核: 4条
- 已拒绝: 2条

### 小组数据（8个）
- 活动1: 1个小组
- 活动3: 2个小组
- 活动4: 1个小组
- 活动5: 1个小组
- 活动6: 1个小组
- 活动7: 2个小组

### 日常任务数据（15条）
涵盖多个活动的学生任务提交记录。

### 实践报告数据（11份）
- 已审核: 7份
- 待审核: 4份

### 成绩数据（19条）
- 活动4（红色教育）: 4条成绩（单教师评分）
- 活动7（文化调研）: 15条成绩（三教师评分，每个学生3条）

**多教师评分示例**：
```
学生: 小张（student_id=5）
活动: 文化遗产调研（activity_id=7）
评分:
  - 张老师: 90分
  - 李老师: 88分  
  - 王老师: 91分
平均分: (90+88+91)/3 = 89.67分
```

### 公告数据（5条）
所有公告均为已发布状态，包括：
- 暑期实践报名通知
- 报告提交通知
- 安全须知
- 优秀团队表彰
- 科技创新项目启动

### 系统日志数据（11条）
记录了用户登录、创建活动、报名、审核、评分等操作。

---

## SQL脚本说明

### db_sql.sql

完整的数据库脚本，包含：
1. 创建数据库
2. 创建所有表结构
3. 创建视图
4. 插入初始管理员账号
5. 插入测试用户数据
6. 插入测试业务数据

**使用方法**：
```bash
mysql -u root -p < db_sql.sql
```

或在MySQL客户端中：
```sql
SOURCE /path/to/db_sql.sql;
```

执行后将自动创建完整的数据库和测试数据。

---

## 数据库优化建议

### 1. 性能优化

- **使用连接池**: 已配置Druid连接池，合理设置连接数
- **索引优化**: 为常用查询字段创建索引
- **分页查询**: 大数据量查询使用LIMIT分页
- **避免SELECT ***: 只查询需要的字段

### 2. 安全建议

- **密码加密**: 使用BCrypt等算法加密密码
- **SQL注入防护**: 使用MyBatis的#{} 而不是 ${}
- **数据备份**: 定期备份数据库
- **权限控制**: 限制数据库用户权限

### 3. 维护建议

- **定期清理日志**: system_log表定期清理旧数据
- **监控慢查询**: 开启慢查询日志，优化慢SQL
- **数据归档**: 已结束的活动数据定期归档
- **索引维护**: 定期OPTIMIZE TABLE优化表

---

## 常用查询示例

### 查询学生的所有活动
```sql
SELECT 
    s.student_id,
    s.real_name,
    pa.title AS activity_name,
    sa.status,
    sa.join_time
FROM student s
JOIN student_activity sa ON s.id = sa.student_id
JOIN practice_activity pa ON sa.activity_id = pa.id
WHERE s.id = 1
ORDER BY sa.join_time DESC;
```

### 查询活动的所有教师
```sql
SELECT 
    pa.title AS activity_name,
    t.teacher_id,
    t.real_name,
    t.department
FROM practice_activity pa
JOIN activity_teacher at ON pa.id = at.activity_id
JOIN teacher t ON at.teacher_id = t.id
WHERE pa.id = 1;
```

### 查询学生的平均成绩
```sql
SELECT * FROM v_student_grade_summary
WHERE student_id = 1
ORDER BY activity_id DESC;
```

### 查询待审核的报名
```sql
SELECT 
    sa.id,
    s.student_id,
    s.real_name,
    pa.title AS activity_name,
    sa.join_time
FROM student_activity sa
JOIN student s ON sa.student_id = s.id
JOIN practice_activity pa ON sa.activity_id = pa.id
WHERE sa.status = 0
ORDER BY sa.join_time DESC;
```

### 统计各活动报名情况
```sql
SELECT * FROM v_activity_statistics
ORDER BY approved_count DESC;
```

---

## 附录

### 数据字典下载

完整的数据字典Excel文件请联系管理员获取。

### ER图

详细的ER图请查看项目文档目录中的 `database_er_diagram.png` 文件。

---

**文档版本**: v2.0  
**更新时间**: 2024-12-13  
**维护人**: 系统管理员
