-- 学生社会实践管理系统数据库脚本
-- 包含完整表结构和初始测试数据
-- 创建数据库
CREATE DATABASE IF NOT EXISTS student_practice DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE student_practice;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码（加密存储）',
  `role` VARCHAR(20) NOT NULL COMMENT '角色（student/teacher/admin）',
  `status` TINYINT(4) DEFAULT 1 COMMENT '用户状态(1-正常,0-禁用)',
  `name` VARCHAR(50) NOT NULL COMMENT '真实姓名',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 学生表
CREATE TABLE IF NOT EXISTS `student` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户表ID',
  `student_id` VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
  `class_name` VARCHAR(50) NOT NULL COMMENT '班级',
  `phone` VARCHAR(20) COMMENT '手机号',
  `email` VARCHAR(50) COMMENT '邮箱',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- 教师表
CREATE TABLE IF NOT EXISTS `teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户表ID',
  `teacher_id` VARCHAR(20) NOT NULL UNIQUE COMMENT '工号',
  `department` VARCHAR(50) NOT NULL COMMENT '部门',
  `phone` VARCHAR(20) COMMENT '手机号',
  `email` VARCHAR(50) COMMENT '邮箱',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';

-- 社会实践活动表
CREATE TABLE IF NOT EXISTS `practice_activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '标题',
  `description` TEXT COMMENT '描述',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `end_time` DATETIME NOT NULL COMMENT '结束时间',
  `location` VARCHAR(100) COMMENT '地点',
  `quota` INT(11) NOT NULL DEFAULT 0 COMMENT '名额',
  `current_count` INT(11) NOT NULL DEFAULT 0 COMMENT '当前报名人数',
  `status` VARCHAR(20) NOT NULL DEFAULT 'recruiting' COMMENT '状态（recruiting/ongoing/finished）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='社会实践活动表';

-- 活动-教师关联表
CREATE TABLE IF NOT EXISTS `activity_teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '教师ID',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_activity_teacher` (`activity_id`, `teacher_id`) -- 确保一个教师在一个活动中只出现一次
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动-教师关联表';

-- 小组表
CREATE TABLE IF NOT EXISTS `student_group` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '小组ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_name` VARCHAR(50) NOT NULL COMMENT '小组名称',
  `leader_id` INT(11) NOT NULL COMMENT '组长ID',
  `member_count` INT(11) NOT NULL DEFAULT 1 COMMENT '成员数量',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`leader_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_group_activity` (`activity_id`, `group_name`) -- 确保一个活动中的小组名称唯一
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组表';

-- 学生报名记录表
CREATE TABLE IF NOT EXISTS `student_signup` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `signup_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `status` VARCHAR(20) NOT NULL DEFAULT 'signed_up' COMMENT '状态（signed_up/completed/cancelled）',
  `group_id` INT(11) COMMENT '小组ID（可为null）',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`group_id`) REFERENCES `student_group` (`id`) ON DELETE SET NULL,
  UNIQUE KEY `unique_student_activity` (`student_id`, `activity_id`) -- 确保一个学生在一个活动中只能报名一次
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生报名记录表';

-- 学生活动关联表
CREATE TABLE IF NOT EXISTS `student_activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_id` INT(11) DEFAULT NULL COMMENT '小组ID',
  `status` TINYINT(4) DEFAULT 0 COMMENT '状态(0:待审核,1:已通过,2:已拒绝)',
  `join_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_activity` (`student_id`,`activity_id`),
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生活动关联表';

-- 成绩表
CREATE TABLE IF NOT EXISTS `score` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '评分教师ID',
  `score_value` DECIMAL(5,2) NOT NULL COMMENT '分数',
  `comment` TEXT COMMENT '评语',
  `score_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_score_record` (`student_id`, `activity_id`, `teacher_id`) -- 确保一个教师对一个学生在一个活动中只能评分一次
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩表';

-- 实践报告表
CREATE TABLE IF NOT EXISTS `practice_report` (
  `report_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '报告ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '报告标题',
  `content` TEXT COMMENT '报告内容',
  `attachment` VARCHAR(200) COMMENT '附件路径',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态（pending/reviewed）',
  `feedback` TEXT COMMENT '教师反馈',
  `submit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`report_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_report` (`student_id`, `activity_id`) -- 确保一个学生在一个活动中只能提交一次报告
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实践报告表';

-- 日常记录表
CREATE TABLE IF NOT EXISTS `daily_record` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `record_date` DATE NOT NULL COMMENT '记录日期',
  `content` TEXT NOT NULL COMMENT '内容',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_daily_record` (`student_id`, `activity_id`, `record_date`) -- 确保一个学生在一个活动中一天只能记录一次
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日常记录表';

-- 插入初始数据
-- 1. 创建管理员用户
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`) VALUES
('admin', '123456', 'admin', 1, '系统管理员');

-- 2. 创建一些示例数据
-- 2.1 教师用户
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`) VALUES
('teacher1', '123456', 'teacher', 1, '张老师'),
('teacher2', '123456', 'teacher', 1, '李老师');

-- 2.2 学生用户
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`) VALUES
('student1', '123456', 'student', 1, '学生A'),
('student2', '123456', 'student', 1, '学生B'),
('student3', '123456', 'student', 1, '学生C');

-- 2.3 教师信息
INSERT INTO `teacher` (`user_id`, `teacher_id`, `department`, `phone`, `email`) VALUES
(2, 'T001', '计算机系', '13800138001', 'zhang@example.com'),
(3, 'T002', '电子系', '13800138002', 'li@example.com');

-- 2.4 学生信息
INSERT INTO `student` (`user_id`, `student_id`, `class_name`, `phone`, `email`) VALUES
(4, '2021001', '计算机科学与技术1班', '13900139001', 'student1@example.com'),
(5, '2021002', '计算机科学与技术1班', '13900139002', 'student2@example.com'),
(6, '2021003', '软件工程2班', '13900139003', 'student3@example.com');

-- 2.5 创建一个示例活动
INSERT INTO `practice_activity` (`title`, `description`, `start_time`, `end_time`, `location`, `quota`, `status`) VALUES
('暑期社会实践活动', '本次活动旨在培养学生的社会责任感和实践能力，让学生深入了解社会，提高解决实际问题的能力。', '2025-07-01 08:00:00', '2025-08-31 18:00:00', '北京市海淀区', 30, 'recruiting');

-- 2.6 关联教师和活动
INSERT INTO `activity_teacher` (`activity_id`, `teacher_id`) VALUES
(1, 1),
(1, 2);

-- 2.7 学生报名
INSERT INTO `student_activity` (`student_id`, `activity_id`, `status`, `join_time`, `update_time`) VALUES
(1, 1, 0, NOW(), NOW()),
(2, 1, 0, NOW(), NOW());

-- 2.8 创建小组
INSERT INTO `student_group` (`activity_id`, `group_name`, `leader_id`) VALUES
(1, '第一小组', 1);

-- 2.9 更新学生报名记录的小组信息
UPDATE `student_activity` SET `group_id` = 1 WHERE `student_id` IN (1, 2);

-- 2.10 更新小组人数
UPDATE `student_group` SET `member_count` = 2 WHERE `id` = 1;

-- 2.11 更新活动当前报名人数
UPDATE `practice_activity` SET `current_count` = 2 WHERE `id` = 1;

-- 2.12 添加一些实践报告数据
INSERT INTO `practice_report` (`student_id`, `activity_id`, `title`, `content`, `attachment`, `status`, `feedback`, `submit_time`, `update_time`) VALUES
(1, 1, '暑期社会实践报告', '本次实践活动让我收获颇丰...', 'report_1.pdf', 'pending', NULL, NOW(), NOW()),
(2, 1, '社会实践心得', '通过这次活动，我学到了很多...', 'report_2.pdf', 'reviewed', '报告内容详实，观察仔细', NOW(), NOW());

-- 3. 添加缺失的表结构定义

-- 3.1 日常任务表
CREATE TABLE IF NOT EXISTS `daily_task` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `title` VARCHAR(255) NOT NULL COMMENT '任务标题',
  `content` TEXT COMMENT '任务内容',
  `task_date` DATE NOT NULL COMMENT '任务日期',
  `status` TINYINT(4) DEFAULT 0 COMMENT '状态(0:未完成,1:已完成)',
  `priority` TINYINT(4) DEFAULT 0 COMMENT '优先级(0-5)',
  `completed_time` DATETIME DEFAULT NULL COMMENT '完成时间',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_task_date` (`task_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日常任务表';

-- 3.2 成绩信息表
CREATE TABLE IF NOT EXISTS `grade_info` (
  `grade_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '教师ID',
  `score` DECIMAL(5,2) NOT NULL COMMENT '分数',
  `comment` TEXT COMMENT '评语',
  `grade_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`grade_id`),
  UNIQUE KEY `uk_student_activity` (`student_id`,`activity_id`),
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩信息表';

-- 3.3 小组信息表
CREATE TABLE IF NOT EXISTS `group_info` (
  `group_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '小组ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_name` VARCHAR(255) NOT NULL COMMENT '小组名称',
  `leader_id` INT(11) NOT NULL COMMENT '组长ID',
  `member_count` INT(11) DEFAULT 0 COMMENT '成员数量',
  `status` TINYINT(4) DEFAULT 0 COMMENT '状态(0:未开始,1:进行中,2:已完成)',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`),
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_leader_id` (`leader_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组信息表';

-- 3.4 公告表
CREATE TABLE IF NOT EXISTS `notice` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` VARCHAR(255) NOT NULL COMMENT '标题',
  `content` TEXT COMMENT '内容',
  `publisher_id` INT(11) COMMENT '发布者ID',
  `publish_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `expiry_time` DATETIME DEFAULT NULL COMMENT '过期时间',
  `status` VARCHAR(20) DEFAULT 'draft' COMMENT '状态(draft/published/expired)',
  PRIMARY KEY (`id`),
  KEY `idx_publisher_id` (`publisher_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';