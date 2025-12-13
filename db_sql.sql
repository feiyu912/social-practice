-- ============================================================
-- 学生社会实践管理系统 - 完整数据库脚本
-- 版本: v2.0
-- 创建时间: 2024-12-13
-- 数据库名称: student_practice
-- 字符集: utf8mb4
-- 说明: 包含表结构、视图、初始数据和测试数据
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `student_practice` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE `student_practice`;

-- ============================================================
-- 第一部分: 数据表结构定义
-- ============================================================

-- ============================================================
-- 1. 用户表 (user)
-- ============================================================
DROP TABLE IF EXISTS `user`;
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
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================================
-- 2. 教师表 (teacher)
-- ============================================================
DROP TABLE IF EXISTS `teacher`;
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
  KEY `idx_department` (`department`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';

-- ============================================================
-- 3. 学生表 (student)
-- ============================================================
DROP TABLE IF EXISTS `student`;
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
  KEY `idx_class_name` (`class_name`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- ============================================================
-- 4. 实践活动表 (practice_activity)
-- ============================================================
DROP TABLE IF EXISTS `practice_activity`;
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
  `status` VARCHAR(20) NOT NULL DEFAULT 'recruiting' COMMENT '状态(recruiting:招募中/ongoing:进行中/finished:已结束)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实践活动表';

-- ============================================================
-- 5. 活动-教师关联表 (activity_teacher)
-- ============================================================
DROP TABLE IF EXISTS `activity_teacher`;
CREATE TABLE `activity_teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '教师ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_teacher` (`activity_id`, `teacher_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动-教师关联表';

-- ============================================================
-- 6. 学生活动报名表 (student_activity)
-- ============================================================
DROP TABLE IF EXISTS `student_activity`;
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
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生活动报名表';

-- ============================================================
-- 7. 小组信息表 (group_info)
-- ============================================================
DROP TABLE IF EXISTS `group_info`;
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
  KEY `idx_leader_id` (`leader_id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`leader_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组信息表';

-- ============================================================
-- 8. 日常任务表 (daily_task)
-- ============================================================
DROP TABLE IF EXISTS `daily_task`;
CREATE TABLE `daily_task` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `task_date` DATE NOT NULL COMMENT '任务日期',
  `content` TEXT COMMENT '任务内容',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态(pending:待处理/completed:已完成)',
  `submit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日常任务表';

-- ============================================================
-- 9. 实践报告表 (practice_report)
-- ============================================================
DROP TABLE IF EXISTS `practice_report`;
CREATE TABLE `practice_report` (
  `report_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '报告ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '报告标题',
  `content` TEXT COMMENT '报告内容',
  `attachment` VARCHAR(200) COMMENT '附件路径',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态(pending:待审核/reviewed:已审核)',
  `feedback` TEXT COMMENT '教师反馈',
  `submit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `uk_student_activity_report` (`student_id`, `activity_id`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实践报告表';

-- ============================================================
-- 10. 成绩信息表 (grade_info)
-- ============================================================
DROP TABLE IF EXISTS `grade_info`;
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
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩信息表';

-- ============================================================
-- 11. 公告表 (notice)
-- ============================================================
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` VARCHAR(100) NOT NULL COMMENT '公告标题',
  `content` TEXT COMMENT '公告内容',
  `publisher_id` INT(11) NOT NULL COMMENT '发布者ID',
  `status` VARCHAR(20) DEFAULT 'draft' COMMENT '状态(draft:草稿/published:已发布)',
  `publish_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_publish_time` (`publish_time`),
  FOREIGN KEY (`publisher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';

-- ============================================================
-- 12. 系统日志表 (system_log)
-- ============================================================
DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` INT(11) COMMENT '操作用户ID',
  `username` VARCHAR(50) COMMENT '操作用户名',
  `operation` VARCHAR(100) NOT NULL COMMENT '操作描述',
  `method` VARCHAR(200) COMMENT '请求方法',
  `params` TEXT COMMENT '请求参数',
  `ip` VARCHAR(50) COMMENT 'IP地址',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';

-- ============================================================
-- 第二部分: 视图定义
-- ============================================================

-- ============================================================
-- 视图1: 学生成绩汇总视图（多教师评分取平均）
-- ============================================================
DROP VIEW IF EXISTS `v_student_grade_summary`;
CREATE OR REPLACE VIEW `v_student_grade_summary` AS
SELECT 
    sa.student_id,
    sa.activity_id,
    s.student_id AS student_number,
    s.real_name AS student_name,
    pa.title AS activity_name,
    COUNT(gi.grade_id) AS teacher_count,
    AVG(gi.score) AS avg_score,
    MIN(gi.score) AS min_score,
    MAX(gi.score) AS max_score,
    GROUP_CONCAT(DISTINCT CONCAT(t.real_name, ':', gi.score) SEPARATOR '; ') AS teacher_scores,
    sa.status AS registration_status
FROM student_activity sa
JOIN student s ON sa.student_id = s.id
JOIN practice_activity pa ON sa.activity_id = pa.id
LEFT JOIN grade_info gi ON sa.student_id = gi.student_id AND sa.activity_id = gi.activity_id
LEFT JOIN teacher t ON gi.teacher_id = t.id
WHERE sa.status = 1
GROUP BY sa.student_id, sa.activity_id, s.student_id, s.real_name, pa.title, sa.status;

-- ============================================================
-- 视图2: 活动参与统计视图
-- ============================================================
DROP VIEW IF EXISTS `v_activity_statistics`;
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

-- ============================================================
-- 第三部分: 初始化基础数据
-- ============================================================

-- ============================================================
-- 1. 初始化管理员账号
-- ============================================================
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`) VALUES
('admin', '123456', 'admin', 1, '系统管理员')
ON DUPLICATE KEY UPDATE `password` = '123456';

-- ============================================================
-- 2. 初始化教师账号和数据
-- ============================================================
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`, `email`, `phone`) VALUES
('teacher1', '123456', 'teacher', 1, '张老师', 'zhang@school.edu', '13800001001'),
('teacher2', '123456', 'teacher', 1, '李老师', 'li@school.edu', '13800001002'),
('teacher3', '123456', 'teacher', 1, '王老师', 'wang@school.edu', '13800001003'),
('teacher4', '123456', 'teacher', 1, '赵老师', 'zhao@school.edu', '13800001004'),
('teacher5', '123456', 'teacher', 1, '刘老师', 'liu@school.edu', '13800001005')
ON DUPLICATE KEY UPDATE `password` = '123456';

-- 创建教师记录
INSERT INTO `teacher` (`user_id`, `teacher_id`, `real_name`, `department`, `phone`, `email`) 
SELECT u.id, CONCAT('T', LPAD(u.id, 4, '0')), u.name, '计算机学院', u.phone, u.email 
FROM `user` u 
WHERE u.role = 'teacher'
ON DUPLICATE KEY UPDATE `real_name` = VALUES(`real_name`), `department` = VALUES(`department`);

-- ============================================================
-- 3. 初始化学生账号和数据
-- ============================================================
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`, `email`, `phone`) VALUES
('student1', '123456', 'student', 1, '小明', 'xiaoming@stu.edu', '13900001001'),
('student2', '123456', 'student', 1, '小红', 'xiaohong@stu.edu', '13900001002'),
('student3', '123456', 'student', 1, '小李', 'xiaoli@stu.edu', '13900001003'),
('student4', '123456', 'student', 1, '小王', 'xiaowang@stu.edu', '13900001004'),
('student5', '123456', 'student', 1, '小张', 'xiaozhang@stu.edu', '13900001005'),
('student6', '123456', 'student', 1, '小陈', 'xiaochen@stu.edu', '13900001006'),
('student7', '123456', 'student', 1, '小周', 'xiaozhou@stu.edu', '13900001007'),
('student8', '123456', 'student', 1, '小吴', 'xiaowu@stu.edu', '13900001008'),
('student9', '123456', 'student', 1, '小郑', 'xiaozheng@stu.edu', '13900001009'),
('student10', '123456', 'student', 1, '小孙', 'xiaosun@stu.edu', '13900001010'),
('student11', '123456', 'student', 1, '小杨', 'xiaoyang@stu.edu', '13900001011'),
('student12', '123456', 'student', 1, '小黄', 'xiaohuang@stu.edu', '13900001012'),
('student13', '123456', 'student', 1, '小林', 'xiaolin@stu.edu', '13900001013'),
('student14', '123456', 'student', 1, '小何', 'xiaohe@stu.edu', '13900001014'),
('student15', '123456', 'student', 1, '小罗', 'xiaoluo@stu.edu', '13900001015')
ON DUPLICATE KEY UPDATE `password` = '123456';

-- 创建学生记录
INSERT INTO `student` (`user_id`, `student_id`, `real_name`, `gender`, `class_name`, `phone`, `email`)
SELECT u.id, 
       CONCAT('2024', LPAD(u.id, 4, '0')), 
       u.name,
       CASE WHEN u.id % 3 = 0 THEN '女' ELSE '男' END,
       CASE WHEN u.id % 2 = 0 THEN '软件工程2024级1班' ELSE '软件工程2024级2班' END, 
       u.phone, 
       u.email 
FROM `user` u 
WHERE u.role = 'student'
ON DUPLICATE KEY UPDATE `real_name` = VALUES(`real_name`), `gender` = VALUES(`gender`), `class_name` = VALUES(`class_name`);

-- ============================================================
-- 第四部分: 测试数据
-- ============================================================

-- ============================================================
-- 1. 实践活动测试数据
-- ============================================================
INSERT INTO `practice_activity` (`title`, `activity_name`, `description`, `start_time`, `end_time`, `location`, `quota`, `current_count`, `status`) VALUES
('暑期三下乡社会实践', '暑期三下乡', '前往农村开展支教、调研、志愿服务等活动，了解基层社会发展状况', '2024-07-01 08:00:00', '2024-07-15 18:00:00', '云南省大理市', 30, 5, 'recruiting'),
('企业参观实习', '企业参观', '参观科技企业，了解企业运营模式和技术发展趋势', '2024-06-15 09:00:00', '2024-06-15 17:00:00', '杭州市滨江区', 50, 4, 'recruiting'),
('社区志愿服务', '社区服务', '走进社区开展志愿服务活动，关爱老年人和儿童', '2024-05-01 08:00:00', '2024-05-30 18:00:00', '本市各社区', 100, 5, 'ongoing'),
('红色教育实践', '红色教育', '参观红色革命圣地，接受爱国主义教育', '2024-04-01 08:00:00', '2024-04-03 18:00:00', '井冈山革命根据地', 40, 4, 'finished'),
('科技创新实践', '科技创新', '参与科技创新项目，培养创新思维和实践能力', '2024-08-01 09:00:00', '2024-08-31 18:00:00', '学校创新实验室', 20, 3, 'recruiting'),
('环保公益行动', '环保公益', '开展环境保护宣传和垃圾分类实践活动', '2024-09-01 08:00:00', '2024-09-15 17:00:00', '城市公园及社区', 60, 4, 'ongoing'),
('文化遗产调研', '文化调研', '调研当地非物质文化遗产，撰写调研报告', '2024-03-01 08:00:00', '2024-03-20 18:00:00', '古城镇历史街区', 25, 5, 'finished'),
('乡村振兴调研', '乡村振兴', '深入乡村了解振兴政策实施情况和农业发展', '2024-10-01 08:00:00', '2024-10-20 18:00:00', '周边乡镇', 35, 0, 'recruiting'),
('法律援助实践', '法律援助', '为社区居民提供法律咨询和援助服务', '2024-06-01 09:00:00', '2024-06-30 17:00:00', '社区法律服务中心', 15, 0, 'ongoing')
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`);

-- ============================================================
-- 2. 活动-教师关联数据
-- ============================================================
INSERT IGNORE INTO `activity_teacher` (`activity_id`, `teacher_id`) VALUES
(1, 1), (1, 2),       -- 暑期三下乡: 张老师、李老师
(2, 1),               -- 企业参观: 张老师
(3, 1), (3, 2), (3, 3), -- 社区服务: 张老师、李老师、王老师
(4, 2),               -- 红色教育: 李老师
(5, 1), (5, 3),       -- 科技创新: 张老师、王老师
(6, 2), (6, 4),       -- 环保公益: 李老师、赵老师
(7, 1), (7, 2), (7, 3), -- 文化调研: 张老师、李老师、王老师
(8, 4), (8, 5),       -- 乡村振兴: 赵老师、刘老师
(9, 3), (9, 5);       -- 法律援助: 王老师、刘老师

-- ============================================================
-- 3. 学生报名数据
-- ============================================================
INSERT IGNORE INTO `student_activity` (`student_id`, `activity_id`, `status`, `join_time`) VALUES
-- 暑期三下乡 (活动1)
(1, 1, 1, '2024-05-01 10:00:00'),
(2, 1, 1, '2024-05-02 11:30:00'),
(3, 1, 0, '2024-05-03 14:20:00'),
(4, 1, 2, '2024-05-04 09:15:00'),
(5, 1, 0, '2024-05-05 16:40:00'),
-- 企业参观 (活动2)
(1, 2, 1, '2024-05-10 08:30:00'),
(3, 2, 1, '2024-05-11 09:00:00'),
(6, 2, 0, '2024-05-12 10:30:00'),
(7, 2, 1, '2024-05-13 14:00:00'),
-- 社区服务 (活动3)
(2, 3, 1, '2024-04-15 11:00:00'),
(4, 3, 1, '2024-04-16 13:30:00'),
(5, 3, 1, '2024-04-17 09:45:00'),
(8, 3, 1, '2024-04-18 10:20:00'),
(9, 3, 0, '2024-04-19 15:10:00'),
-- 红色教育 (活动4)
(1, 4, 1, '2024-03-01 08:00:00'),
(2, 4, 1, '2024-03-01 08:30:00'),
(3, 4, 1, '2024-03-02 09:00:00'),
(10, 4, 1, '2024-03-02 10:00:00'),
-- 科技创新 (活动5)
(4, 5, 1, '2024-07-01 14:30:00'),
(5, 5, 1, '2024-07-02 09:00:00'),
(6, 5, 1, '2024-07-03 11:20:00'),
-- 环保公益 (活动6)
(7, 6, 1, '2024-08-15 09:00:00'),
(8, 6, 1, '2024-08-16 10:30:00'),
(9, 6, 1, '2024-08-17 14:00:00'),
(13, 6, 1, '2024-08-18 11:00:00'),
-- 文化调研 (活动7)
(5, 7, 1, '2024-02-15 08:30:00'),
(6, 7, 1, '2024-02-16 09:00:00'),
(10, 7, 1, '2024-02-17 10:30:00'),
(11, 7, 1, '2024-02-18 11:00:00'),
(15, 7, 1, '2024-02-19 14:00:00');

-- 更新活动当前报名人数
UPDATE `practice_activity` pa SET current_count = (
    SELECT COUNT(*) FROM student_activity WHERE activity_id = pa.id AND status = 1
);

-- ============================================================
-- 4. 小组数据
-- ============================================================
INSERT IGNORE INTO `group_info` (`activity_id`, `group_name`, `leader_id`, `member_count`, `status`) VALUES
(1, '阳光支教队', 1, 2, 1),
(3, '爱心志愿者小组', 2, 3, 1),
(3, '暖阳服务队', 5, 2, 1),
(4, '红色足迹探寻队', 1, 4, 2),
(5, '创新先锋队', 4, 3, 1),
(6, '绿色卫士小组', 7, 4, 1),
(7, '非遗传承调研组', 5, 3, 2),
(7, '历史探秘小队', 10, 2, 2);

-- 更新学生活动的小组关联
UPDATE student_activity SET group_id = 1 WHERE student_id IN (1, 2) AND activity_id = 1;
UPDATE student_activity SET group_id = 2 WHERE student_id IN (2, 4, 8) AND activity_id = 3;
UPDATE student_activity SET group_id = 3 WHERE student_id = 5 AND activity_id = 3;
UPDATE student_activity SET group_id = 4 WHERE student_id IN (1, 2, 3, 10) AND activity_id = 4;
UPDATE student_activity SET group_id = 5 WHERE student_id IN (4, 5, 6) AND activity_id = 5;
UPDATE student_activity SET group_id = 6 WHERE student_id IN (7, 8, 9, 13) AND activity_id = 6;
UPDATE student_activity SET group_id = 7 WHERE student_id IN (5, 6, 11) AND activity_id = 7;
UPDATE student_activity SET group_id = 8 WHERE student_id IN (10, 15) AND activity_id = 7;

-- ============================================================
-- 5. 日常任务数据
-- ============================================================
INSERT IGNORE INTO `daily_task` (`student_id`, `activity_id`, `task_date`, `content`, `status`, `submit_time`) VALUES
(2, 3, '2024-05-01', '今天前往社区服务中心，帮助老人们整理房间，陪他们聊天，感受到志愿服务的意义。', 'completed', '2024-05-01 18:00:00'),
(2, 3, '2024-05-02', '组织社区儿童开展绘画活动，孩子们很开心，我也学到了如何与孩子沟通。', 'completed', '2024-05-02 17:30:00'),
(4, 3, '2024-05-01', '协助社区工作人员整理档案资料，了解了社区管理的基本流程。', 'completed', '2024-05-01 17:00:00'),
(5, 3, '2024-05-03', '参与社区环境卫生清洁工作，打扫公共区域，居民们非常感谢。', 'completed', '2024-05-03 16:30:00'),
(8, 3, '2024-05-02', '为社区独居老人送餐，了解他们的生活需求，记录反馈信息。', 'completed', '2024-05-02 12:00:00'),
(1, 4, '2024-04-01', '参观井冈山革命博物馆，深入了解革命历史，感受先烈的奉献精神。', 'completed', '2024-04-01 20:00:00'),
(1, 4, '2024-04-02', '徒步走访革命遗址，实地体验红军长征的艰辛历程。', 'completed', '2024-04-02 19:30:00'),
(2, 4, '2024-04-01', '聆听老红军后代讲述革命故事，深受触动，撰写心得体会。', 'completed', '2024-04-01 21:00:00'),
(3, 4, '2024-04-02', '参与红色主题演讲活动，分享学习心得，与同学们交流感想。', 'completed', '2024-04-02 18:00:00'),
(4, 5, '2024-07-10', '学习Python编程基础，完成第一个小程序的编写。', 'completed', '2024-07-10 20:00:00'),
(5, 5, '2024-07-10', '参与机器学习入门培训，了解算法基本原理。', 'completed', '2024-07-10 19:00:00'),
(7, 6, '2024-09-01', '在公园开展垃圾分类宣传活动，向市民发放宣传手册。', 'completed', '2024-09-01 17:00:00'),
(8, 6, '2024-09-02', '组织社区居民参与环保知识竞赛，反响热烈。', 'completed', '2024-09-02 18:30:00'),
(5, 7, '2024-03-05', '走访当地老艺人，记录传统手工艺制作流程。', 'completed', '2024-03-05 17:00:00'),
(6, 7, '2024-03-06', '拍摄非遗文化纪录片素材，采访传承人。', 'completed', '2024-03-06 18:00:00');

-- ============================================================
-- 6. 实践报告数据
-- ============================================================
INSERT IGNORE INTO `practice_report` (`student_id`, `activity_id`, `title`, `content`, `attachment`, `status`, `feedback`, `submit_time`) VALUES
(1, 4, '井冈山红色之旅感悟', '通过这次红色教育实践活动，我深刻感受到了革命先辈们的伟大精神。在井冈山革命博物馆，我看到了许多珍贵的历史文物和照片...', '/uploads/reports/student1_activity4.pdf', 'reviewed', '报告内容充实，感悟深刻，能够将理论与实践相结合。建议今后继续深入学习党史。评分：92分', '2024-04-10 14:00:00'),
(2, 4, '传承红色基因 牢记使命担当', '这次井冈山之行让我受益匪浅。通过聆听老红军后代讲述的革命故事，我深刻理解了什么是"坚定信念、艰苦奋斗"的井冈山精神...', NULL, 'reviewed', '文章立意高远，表达流畅，展现了良好的思想觉悟。期待你在今后的学习中继续保持这种积极向上的态度。评分：88分', '2024-04-11 10:30:00'),
(3, 4, '红色文化与当代青年责任', '本次红色教育实践让我对革命历史有了更深入的了解。通过实地考察和亲身体验，我认识到红色文化的重要价值...', '/uploads/reports/student3_activity4.docx', 'reviewed', '分析有深度，结构清晰，能够独立思考问题。建议加强文献引用的规范性。评分：85分', '2024-04-12 16:00:00'),
(10, 4, '革命精神的时代价值探究', '本报告以井冈山革命精神为研究对象，探讨其在新时代的价值意义...', NULL, 'pending', NULL, '2024-04-13 09:00:00'),
(5, 7, '传统手工艺的困境与出路', '通过对古城镇传统手工艺的实地调研，我发现许多珍贵的非遗技艺正面临失传的困境...', '/uploads/reports/student5_activity7.pdf', 'reviewed', '调研扎实，建议具有可操作性。报告体现了较强的问题意识和解决能力。评分：90分', '2024-03-25 11:00:00'),
(6, 7, '古建筑保护现状调查报告', '本报告聚焦于历史街区古建筑的保护现状，通过实地走访和问卷调查，收集了大量第一手资料...', '/uploads/reports/student6_activity7.pdf', 'reviewed', '数据详实，分析到位，对策建议有针对性。继续保持这种严谨的研究态度！评分：93分', '2024-03-26 14:30:00'),
(11, 7, '非物质文化遗产传承人口述史', '本报告以口述历史的形式，记录了三位非遗传承人的人生经历和技艺传承故事...', NULL, 'reviewed', '切入点新颖，记录生动感人。建议今后可以考虑制作成视频纪录片形式传播。评分：87分', '2024-03-27 10:00:00'),
(2, 3, '社区志愿服务实践总结', '本月参与社区志愿服务活动共计15天，累计服务时长超过60小时...', NULL, 'pending', NULL, '2024-05-28 16:00:00'),
(4, 3, '社区治理与志愿服务调研', '本报告结合社区志愿服务实践，对社区治理模式进行了初步探讨...', '/uploads/reports/student4_activity3.pdf', 'pending', NULL, '2024-05-29 11:00:00');

-- ============================================================
-- 7. 成绩数据（多教师评分）
-- ============================================================
INSERT IGNORE INTO `grade_info` (`student_id`, `activity_id`, `teacher_id`, `score`, `comment`, `grade_time`) VALUES
-- 红色教育实践 (活动4 - 李老师评分)
(1, 4, 2, 92, '表现优秀，积极参与各项活动，心得体会深刻。', '2024-04-15 10:00:00'),
(2, 4, 2, 88, '态度认真，能够主动思考，报告质量较高。', '2024-04-15 10:30:00'),
(3, 4, 2, 85, '参与度高，有独立见解，需进一步提升表达能力。', '2024-04-15 11:00:00'),
(10, 4, 2, 82, '基本完成任务，建议更加深入思考。', '2024-04-15 11:30:00'),
-- 文化遗产调研 (活动7 - 多教师评分)
-- 张老师评分
(5, 7, 1, 90, '调研认真细致，报告质量高。', '2024-03-28 14:00:00'),
(6, 7, 1, 94, '数据分析能力强，建议切实可行。', '2024-03-28 14:30:00'),
(10, 7, 1, 86, '参与积极，团队协作能力好。', '2024-03-28 15:00:00'),
(11, 7, 1, 88, '采访技巧好，记录完整。', '2024-03-28 15:30:00'),
(15, 7, 1, 84, '态度认真，需提升分析深度。', '2024-03-28 16:00:00'),
-- 李老师评分
(5, 7, 2, 88, '研究方法得当，结论有说服力。', '2024-03-29 09:00:00'),
(6, 7, 2, 92, '专业素养高，报告规范。', '2024-03-29 09:30:00'),
(10, 7, 2, 85, '基础扎实，可进一步深化。', '2024-03-29 10:00:00'),
(11, 7, 2, 86, '口述史记录生动真实。', '2024-03-29 10:30:00'),
(15, 7, 2, 83, '完成基本任务，表现中规中矩。', '2024-03-29 11:00:00'),
-- 王老师评分
(5, 7, 3, 91, '对非遗保护有独到见解。', '2024-03-30 14:00:00'),
(6, 7, 3, 95, '综合表现突出，是本次活动的优秀代表。', '2024-03-30 14:30:00'),
(10, 7, 3, 87, '团队贡献大，协调能力强。', '2024-03-30 15:00:00'),
(11, 7, 3, 89, '文字功底好，报告可读性强。', '2024-03-30 15:30:00'),
(15, 7, 3, 85, '认真负责，有进步空间。', '2024-03-30 16:00:00');

-- ============================================================
-- 8. 公告数据
-- ============================================================
INSERT IGNORE INTO `notice` (`title`, `content`, `publisher_id`, `status`, `publish_time`) VALUES
('2024年暑期社会实践活动报名通知', '各位同学：\n\n2024年暑期社会实践活动现已开始报名！本次活动包括"暑期三下乡"、"企业参观实习"等多个项目，欢迎同学们积极参与。\n\n报名截止时间：2024年6月15日\n报名方式：登录系统在线报名\n\n如有疑问，请联系学工办。', 1, 'published', '2024-05-15 09:00:00'),
('关于提交社会实践报告的通知', '各位同学：\n\n请参与已结束社会实践活动的同学于活动结束后两周内提交实践报告。报告应包含实践过程记录、心得体会、收获总结等内容。\n\n未按时提交报告者，将影响最终成绩评定。', 1, 'published', '2024-05-20 10:30:00'),
('社会实践安全须知', '各位同学：\n\n为确保社会实践活动的顺利进行，请各位同学注意以下安全事项：\n\n1. 外出实践时务必结伴而行\n2. 保持手机通讯畅通\n3. 遵守活动纪律和作息时间\n4. 注意人身财产安全\n5. 如遇紧急情况及时联系带队老师', 1, 'published', '2024-06-01 08:00:00'),
('优秀实践团队表彰通知', '经评审，以下团队被评为2024年度优秀社会实践团队：\n\n1. 红色足迹探寻队（红色教育实践）\n2. 非遗传承调研组（文化遗产调研）\n\n请获奖团队成员于本周五下午3点到学工办领取荣誉证书。', 1, 'published', '2024-04-25 14:00:00'),
('科技创新实践项目启动公告', '各位同学：\n\n2024年科技创新实践项目现已启动！本次活动聚焦人工智能、大数据等前沿技术，由计算机学院多位教授担任导师。\n\n项目时间：2024年8月1日-8月31日\n地点：学校创新实验室\n名额：20人', 1, 'published', '2024-07-01 09:00:00');

-- ============================================================
-- 9. 系统日志数据
-- ============================================================
INSERT IGNORE INTO `system_log` (`user_id`, `username`, `operation`, `method`, `params`, `ip`, `create_time`) VALUES
(1, 'admin', '用户登录', 'POST /user/login', 'username=admin', '127.0.0.1', '2024-05-01 08:30:00'),
(1, 'admin', '访问管理员首页', 'GET /index', NULL, '127.0.0.1', '2024-05-01 08:30:15'),
(1, 'admin', '发布公告', 'POST /notice/add', 'title=2024年暑期社会实践活动报名通知', '127.0.0.1', '2024-05-15 09:00:00'),
(2, 'teacher1', '用户登录', 'POST /user/login', 'username=teacher1', '192.168.1.101', '2024-05-16 09:15:00'),
(2, 'teacher1', '创建实践活动', 'POST /activity/add', 'title=暑期三下乡社会实践', '192.168.1.101', '2024-05-16 10:00:00'),
(6, 'student1', '用户登录', 'POST /user/login', 'username=student1', '192.168.1.201', '2024-05-17 14:30:00'),
(6, 'student1', '报名活动', 'POST /studentActivity/register', 'activityId=1', '192.168.1.201', '2024-05-17 14:35:00'),
(2, 'teacher1', '审核报名', 'POST /studentActivity/approve', 'id=1', '192.168.1.101', '2024-05-18 09:00:00'),
(3, 'teacher2', '评定成绩', 'POST /grade/doGrade', 'studentId=1&activityId=4&score=92', '192.168.1.102', '2024-04-15 10:00:00'),
(7, 'student2', '创建小组', 'POST /group/create', 'activityId=1&groupName=阳光支教队', '192.168.1.202', '2024-05-20 10:30:00'),
(6, 'student1', '提交实践报告', 'POST /practiceReport/submit', 'activityId=4', '192.168.1.201', '2024-04-10 14:00:00');

-- ============================================================
-- 完成提示
-- ============================================================
SELECT '========================================' AS '';
SELECT '数据库初始化完成！' AS message;
SELECT '========================================' AS '';
SELECT CONCAT('用户总数: ', COUNT(*)) AS statistics FROM user;
SELECT CONCAT('学生数: ', COUNT(*)) AS statistics FROM student;
SELECT CONCAT('教师数: ', COUNT(*)) AS statistics FROM teacher;
SELECT CONCAT('活动数: ', COUNT(*)) AS statistics FROM practice_activity;
SELECT CONCAT('报名记录: ', COUNT(*)) AS statistics FROM student_activity;
SELECT CONCAT('小组数: ', COUNT(*)) AS statistics FROM group_info;
SELECT CONCAT('日常任务: ', COUNT(*)) AS statistics FROM daily_task;
SELECT CONCAT('实践报告: ', COUNT(*)) AS statistics FROM practice_report;
SELECT CONCAT('成绩记录: ', COUNT(*)) AS statistics FROM grade_info;
SELECT CONCAT('公告数: ', COUNT(*)) AS statistics FROM notice;
SELECT CONCAT('系统日志: ', COUNT(*)) AS statistics FROM system_log;
SELECT '========================================' AS '';
SELECT '测试账号信息：' AS info;
SELECT '管理员: admin / 123456' AS account;
SELECT '教师: teacher1~teacher5 / 123456' AS account;
SELECT '学生: student1~student15 / 123456' AS account;
SELECT '========================================' AS '';
