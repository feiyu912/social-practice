-- ============================================================
-- 学生社会实践管理系统 - 数据库表结构
-- 数据库名称：student_practice
-- 字符集：utf8mb4
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `student_practice` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE `student_practice`;

-- ============================================================
-- 1. 用户表
-- ============================================================
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `role` VARCHAR(20) NOT NULL DEFAULT 'student' COMMENT '角色(admin/teacher/student)',
  `status` TINYINT(4) NOT NULL DEFAULT 1 COMMENT '状态(0:禁用,1:启用)',
  `name` VARCHAR(50) COMMENT '真实姓名',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================================
-- 2. 教师表
-- ============================================================
CREATE TABLE IF NOT EXISTS `teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户ID',
  `teacher_id` VARCHAR(20) COMMENT '教师工号',
  `department` VARCHAR(50) COMMENT '所属院系',
  `phone` VARCHAR(20) COMMENT '联系电话',
  `email` VARCHAR(100) COMMENT '电子邮箱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';

-- ============================================================
-- 3. 学生表
-- ============================================================
CREATE TABLE IF NOT EXISTS `student` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `user_id` INT(11) NOT NULL COMMENT '关联用户ID',
  `student_id` VARCHAR(20) COMMENT '学号',
  `class_name` VARCHAR(50) COMMENT '班级',
  `phone` VARCHAR(20) COMMENT '联系电话',
  `email` VARCHAR(100) COMMENT '电子邮箱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- ============================================================
-- 4. 实践活动表
-- ============================================================
CREATE TABLE IF NOT EXISTS `practice_activity` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '活动标题',
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

-- ============================================================
-- 5. 活动-教师关联表
-- ============================================================
CREATE TABLE IF NOT EXISTS `activity_teacher` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '教师ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_teacher` (`activity_id`, `teacher_id`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动-教师关联表';

-- ============================================================
-- 6. 学生活动报名表
-- ============================================================
CREATE TABLE IF NOT EXISTS `student_activity` (
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

-- ============================================================
-- 7. 学生小组表
-- ============================================================
CREATE TABLE IF NOT EXISTS `student_group` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '小组ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `group_name` VARCHAR(50) NOT NULL COMMENT '小组名称',
  `leader_id` INT(11) NOT NULL COMMENT '组长ID(学生ID)',
  `member_count` INT(11) NOT NULL DEFAULT 1 COMMENT '成员数量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_group` (`activity_id`, `group_name`),
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`leader_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生小组表';

-- ============================================================
-- 8. 小组信息表（扩展）
-- ============================================================
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
  KEY `idx_activity_id` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小组信息表';

-- ============================================================
-- 9. 日常任务表
-- ============================================================
CREATE TABLE IF NOT EXISTS `daily_task` (
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

-- ============================================================
-- 10. 实践报告表
-- ============================================================
CREATE TABLE IF NOT EXISTS `practice_report` (
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

-- ============================================================
-- 11. 成绩表
-- ============================================================
CREATE TABLE IF NOT EXISTS `score` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `teacher_id` INT(11) NOT NULL COMMENT '评分教师ID',
  `score` DECIMAL(5,2) COMMENT '分数',
  `comment` TEXT COMMENT '评语',
  `score_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_activity_teacher` (`student_id`, `activity_id`, `teacher_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩表';

-- ============================================================
-- 12. 成绩信息表（扩展）
-- ============================================================
CREATE TABLE IF NOT EXISTS `grade_info` (
  `grade_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` INT(11) NOT NULL COMMENT '学生ID',
  `activity_id` INT(11) NOT NULL COMMENT '活动ID',
  `performance_score` DECIMAL(5,2) DEFAULT 0 COMMENT '表现分',
  `report_score` DECIMAL(5,2) DEFAULT 0 COMMENT '报告分',
  `total_score` DECIMAL(5,2) DEFAULT 0 COMMENT '总分',
  `grade_level` VARCHAR(10) COMMENT '等级(A/B/C/D/F)',
  `comments` TEXT COMMENT '评语',
  `graded_by` INT(11) COMMENT '评分教师ID',
  `grade_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`grade_id`),
  UNIQUE KEY `uk_student_activity_grade` (`student_id`, `activity_id`),
  FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`activity_id`) REFERENCES `practice_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩信息表';

-- ============================================================
-- 13. 公告表
-- ============================================================
CREATE TABLE IF NOT EXISTS `notice` (
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

-- ============================================================
-- 初始化管理员账号
-- ============================================================
INSERT INTO `user` (`username`, `password`, `role`, `status`, `name`) VALUES
('admin', '123456', 'admin', 1, '系统管理员')
ON DUPLICATE KEY UPDATE `password` = '123456';
