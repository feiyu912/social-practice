-- ============================================================
-- 学生社会实践管理系统 - 完整数据库脚本
-- 版本: v2.0
-- 创建时间: 2025-12-13
-- 数据库名称: student_practice
-- 字符集: utf8mb4
-- 说明: 包含表结构、视图、初始数据和测试数据
-- ============================================================
-- 临时关闭安全更新
SET SQL_SAFE_UPDATES = 0;
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
  `gender` VARCHAR(10) COMMENT '性别',
  `department` VARCHAR(50) COMMENT '所属院系',
  `position` VARCHAR(50) COMMENT '职务',
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
  `title` VARCHAR(200) COMMENT '任务标题',
  `content` TEXT COMMENT '任务内容',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态(pending:待处理/completed:已完成)',
  `priority` INT(11) DEFAULT 0 COMMENT '优先级(0-5)',
  `completed_time` DATETIME DEFAULT NULL COMMENT '完成时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
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
  `expiry_time` DATETIME DEFAULT NULL COMMENT '公告过期时间',
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
INSERT INTO `teacher` (`user_id`, `teacher_id`, `real_name`, `gender`, `department`, `position`, `phone`, `email`) 
SELECT u.id, CONCAT('T', LPAD(u.id, 4, '0')), u.name, 
       CASE WHEN u.id % 3 = 0 THEN '女' ELSE '男' END,
       '计算机学院',
       CASE WHEN u.id <= 2 THEN '副教授' ELSE '讲师' END,
       u.phone, u.email 
FROM `user` u 
WHERE u.role = 'teacher'
ON DUPLICATE KEY UPDATE `real_name` = VALUES(`real_name`), `gender` = VALUES(`gender`), `department` = VALUES(`department`), `position` = VALUES(`position`);

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
       CONCAT('2025', LPAD(u.id, 4, '0')), 
       u.name,
       CASE WHEN u.id % 3 = 0 THEN '女' ELSE '男' END,
       CASE WHEN u.id % 2 = 0 THEN '软件工程2025级1班' ELSE '软件工程2025级2班' END, 
       u.phone, 
       u.email 
FROM `user` u 
WHERE u.role = 'student'
ON DUPLICATE KEY UPDATE `real_name` = VALUES(`real_name`), `gender` = VALUES(`gender`), `class_name` = VALUES(`class_name`);

-- ============================================================
-- 第四部分: 测试数据
-- ============================================================

-- ============================================================
-- 1. 实践活动测试数据（根据当前时间动态生成）
-- ============================================================
-- 注意：以下数据使用 DATE_ADD/DATE_SUB 函数，确保活动时间始终相对于当前时间有效

INSERT INTO `practice_activity` (`title`, `activity_name`, `description`, `start_time`, `end_time`, `location`, `quota`, `current_count`, `status`) VALUES
-- 招募中的活动（已开始，未结束）
('暑期三下乡社会实践', '暑期三下乡', '前往农村开展支教、调研、志愿服务等活动，了解基层社会发展状况', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 12 DAY), '云南省大理市', 30, 0, 'recruiting'),
('企业参观实习', '企业参观', '参观科技企业，了解企业运营模式和技术发展趋势', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 20 DAY), '杭州市滨江区', 50, 0, 'recruiting'),
('社区志愿服务', '社区服务', '走进社区开展志愿服务活动，关爱老年人和儿童', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 25 DAY), '本市各社区', 100, 0, 'recruiting'),
('科技创新实践', '科技创新', '参与科技创新项目，培养创新思维和实践能力', DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 30 DAY), '学校创新实验室', 20, 0, 'recruiting'),
('环保公益行动', '环保公益', '开展环境保护宣传和垃圾分类实践活动', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 13 DAY), '城市公园及社区', 60, 0, 'recruiting'),
('乡村振兴调研', '乡村振兴', '深入乡村了解振兴政策实施情况和农业发展', DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 22 DAY), '周边乡镇', 35, 0, 'recruiting'),

-- 进行中的活动（已开始，未结束，但停止招募）
('法律援助实践', '法律援助', '为社区居民提供法律咨询和援助服务', DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), '社区法律服务中心', 15, 5, 'ongoing'),

-- 已结束的活动
('红色教育实践', '红色教育', '参观红色革命圣地，接受爱国主义教育', DATE_SUB(NOW(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 15 DAY), '井冈山革命根据地', 40, 10, 'finished'),
('文化遗产调研', '文化调研', '调研当地非物质文化遗产，撰写调研报告', DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 25 DAY), '古城镇历史街区', 25, 8, 'finished')
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`);

-- ============================================================
-- 2. 活动-教师关联数据
-- ============================================================
INSERT IGNORE INTO `activity_teacher` (`activity_id`, `teacher_id`) VALUES
(1, 1), (1, 2),       -- 暑期三下乡: 张老师、李老师
(2, 1),               -- 企业参观: 张老师
(3, 1), (3, 2), (3, 3), -- 社区服务: 张老师、李老师、王老师
(4, 1), (4, 3),       -- 科技创新: 张老师、王老师
(5, 2), (5, 4),       -- 环保公益: 李老师、赵老师
(6, 4), (6, 5),       -- 乡村振兴: 赵老师、刘老师
(7, 3), (7, 5),       -- 法律援助: 王老师、刘老师
(8, 2),               -- 红色教育: 李老师
(9, 1), (9, 2), (9, 3); -- 文化调研: 张老师、李老师、王老师

-- ============================================================
-- 3. 学生报名数据（只保留已结束活动的历史数据）
-- ============================================================
INSERT IGNORE INTO `student_activity` (`student_id`, `activity_id`, `status`, `join_time`) VALUES
-- 红色教育 (活动8)
(1, 8, 1, DATE_SUB(NOW(), INTERVAL 35 DAY)),
(2, 8, 1, DATE_SUB(NOW(), INTERVAL 34 DAY)),
(3, 8, 1, DATE_SUB(NOW(), INTERVAL 33 DAY)),
(10, 8, 1, DATE_SUB(NOW(), INTERVAL 32 DAY)),
-- 文化调研 (活动9)
(5, 9, 1, DATE_SUB(NOW(), INTERVAL 50 DAY)),
(6, 9, 1, DATE_SUB(NOW(), INTERVAL 49 DAY)),
(10, 9, 1, DATE_SUB(NOW(), INTERVAL 48 DAY)),
(11, 9, 1, DATE_SUB(NOW(), INTERVAL 47 DAY)),
(15, 9, 1, DATE_SUB(NOW(), INTERVAL 46 DAY)),
-- 法律援助 (活动7 - 进行中，已有一些审核通过的学生）
(4, 7, 1, DATE_SUB(NOW(), INTERVAL 12 DAY)),
(5, 7, 1, DATE_SUB(NOW(), INTERVAL 11 DAY)),
(6, 7, 1, DATE_SUB(NOW(), INTERVAL 11 DAY)),
(7, 7, 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(8, 7, 0, DATE_SUB(NOW(), INTERVAL 1 DAY));  -- 有一个待审核

-- 更新活动当前报名人数
UPDATE `practice_activity` pa SET current_count = (
    SELECT COUNT(*) FROM student_activity WHERE activity_id = pa.id AND status = 1
);

-- ============================================================
-- 4. 小组数据（只保留已结束活动和进行中活动的小组）
-- ============================================================
INSERT IGNORE INTO `group_info` (`activity_id`, `group_name`, `leader_id`, `member_count`, `status`) VALUES
(8, '红色足迹探寻队', 1, 4, 2),  -- 红色教育，已完成
(9, '非遗传承调研组', 5, 3, 2),  -- 文化调研，已完成
(9, '历史探秘小队', 10, 2, 2), -- 文化调研，已完成
(7, '法律服务小组', 4, 4, 1);   -- 法律援助，进行中

-- 更新学生活动的小组关联
UPDATE student_activity SET group_id = 1 WHERE student_id IN (1, 2, 3, 10) AND activity_id = 8;  -- 红色教育
UPDATE student_activity SET group_id = 2 WHERE student_id IN (5, 6, 11) AND activity_id = 9;  -- 文化调研
UPDATE student_activity SET group_id = 3 WHERE student_id IN (10, 15) AND activity_id = 9;  -- 文化调研
UPDATE student_activity SET group_id = 4 WHERE student_id IN (4, 5, 6, 7) AND activity_id = 7;  -- 法律援助

-- ============================================================
-- 5. 日常任务数据（保留已结束活动和进行中活动的任务记录）
-- ============================================================
INSERT IGNORE INTO `daily_task` (`student_id`, `activity_id`, `task_date`, `title`, `content`, `status`, `priority`, `completed_time`) VALUES
-- 红色教育活动（已结束）
(1, 8, DATE_SUB(NOW(), INTERVAL 28 DAY), '井冈山革命博物馆参观', '参观井冈山革命博物馆，深入了解革命历史，感受先烈的奉献精神。', 'completed', 5, DATE_SUB(NOW(), INTERVAL 28 DAY)),
(1, 8, DATE_SUB(NOW(), INTERVAL 27 DAY), '革命遗址徒步走访', '徒步走访革命遗址，实地体验红军长征的艰辛历程。', 'completed', 5, DATE_SUB(NOW(), INTERVAL 27 DAY)),
(2, 8, DATE_SUB(NOW(), INTERVAL 28 DAY), '聆听革命故事', '聆听老红军后代讲述革命故事，深受触动，撰写心得体会。', 'completed', 4, DATE_SUB(NOW(), INTERVAL 28 DAY)),
(3, 8, DATE_SUB(NOW(), INTERVAL 27 DAY), '红色主题演讲', '参与红色主题演讲活动，分享学习心得，与同学们交流感想。', 'completed', 3, DATE_SUB(NOW(), INTERVAL 27 DAY)),

-- 文化调研活动（已结束）
(5, 9, DATE_SUB(NOW(), INTERVAL 40 DAY), '传统手工艺调研', '走访当地老艺人，记录传统手工艺制作流程。', 'completed', 4, DATE_SUB(NOW(), INTERVAL 40 DAY)),
(6, 9, DATE_SUB(NOW(), INTERVAL 39 DAY), '非遗纪录片拍摄', '拍摄非遗文化纪录片素材，采访传承人。', 'completed', 4, DATE_SUB(NOW(), INTERVAL 39 DAY)),

-- 法律援助活动（进行中）
(4, 7, DATE_SUB(NOW(), INTERVAL 8 DAY), '法律咨询服务', '为社区居民提供法律咨询，解答法律疑问。', 'completed', 4, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(5, 7, DATE_SUB(NOW(), INTERVAL 7 DAY), '法律文书起草', '协助居民起草法律文书，学习法律实务技能。', 'completed', 3, DATE_SUB(NOW(), INTERVAL 7 DAY)),
(6, 7, DATE_SUB(NOW(), INTERVAL 5 DAY), '法律宣传活动', '在社区开展法律知识宣传活动。', 'completed', 3, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(4, 7, DATE_SUB(NOW(), INTERVAL 2 DAY), '案例分析学习', '分析典型法律案例，提升法律应用能力。', 'completed', 4, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(7, 7, DATE_ADD(NOW(), INTERVAL 1 DAY), '社区调解工作', '计划参与社区矛盾调解工作。', 'pending', 3, NULL);

-- ============================================================
-- 6. 实践报告数据（只保留已结束活动的报告）
-- ============================================================
INSERT IGNORE INTO `practice_report` (`student_id`, `activity_id`, `title`, `content`, `attachment`, `status`, `feedback`, `submit_time`) VALUES
-- 红色教育活动报告
(1, 8, '井冈山红色之旅感悟', '通过这次红色教育实践活动，我深刻感受到了革命先辈们的伟大精神。在井冈山革命博物馆，我看到了许多珍贵的历史文物和照片...', '/uploads/reports/student1_activity8.pdf', 'reviewed', '报告内容充实，感悟深刻，能够将理论与实践相结合。建议今后继续深入学习党史。评分：92分', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(2, 8, '传承红色基因 牢记使命担当', '这次井冈山之行让我受益匪浅。通过聆听老红军后代讲述的革命故事，我深刻理解了什么是"坚定信念、艰苦奋斗"的井冈山精神...', NULL, 'reviewed', '文章立意高远，表达流畅，展现了良好的思想觉悟。期待你在今后的学习中继续保持这种积极向上的态度。评分：88分', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(3, 8, '红色文化与当代青年责任', '本次红色教育实践让我对革命历史有了更深入的了解。通过实地考察和亲身体验，我认识到红色文化的重要价值...', '/uploads/reports/student3_activity8.docx', 'reviewed', '分析有深度，结构清晰，能够独立思考问题。建议加强文献引用的规范性。评分：85分', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(10, 8, '革命精神的时代价值探究', '本报告以井冈山革命精神为研究对象，探讨其在新时代的价值意义...', NULL, 'pending', NULL, DATE_SUB(NOW(), INTERVAL 10 DAY)),

-- 文化调研活动报告
(5, 9, '传统手工艺的困境与出路', '通过对古城镇传统手工艺的实地调研，我发现许多珍贵的非遗技艺正面临失传的困境...', '/uploads/reports/student5_activity9.pdf', 'reviewed', '调研扎实，建议具有可操作性。报告体现了较强的问题意识和解决能力。评分：90分', DATE_SUB(NOW(), INTERVAL 23 DAY)),
(6, 9, '古建筑保护现状调查报告', '本报告聚焦于历史街区古建筑的保护现状，通过实地走访和问卷调查，收集了大量第一手资料...', '/uploads/reports/student6_activity9.pdf', 'reviewed', '数据详实，分析到位，对策建议有针对性。继续保持这种严谨的研究态度！评分：93分', DATE_SUB(NOW(), INTERVAL 22 DAY)),
(11, 9, '非物质文化遗产传承人口述史', '本报告以口述历史的形式，记录了三位非遗传承人的人生经历和技艺传承故事...', NULL, 'reviewed', '切入点新颖，记录生动感人。建议今后可以考虑制作成视频纪录片形式传播。评分：87分', DATE_SUB(NOW(), INTERVAL 21 DAY));

-- ============================================================
-- 7. 成绩数据（多教师评分，只保留已结束活动）
-- ============================================================
INSERT IGNORE INTO `grade_info` (`student_id`, `activity_id`, `teacher_id`, `score`, `comment`, `grade_time`) VALUES
-- 红色教育实践 (活动8 - 李老师评分)
(1, 8, 2, 92, '表现优秀，积极参与各项活动，心得体会深刻。', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(2, 8, 2, 88, '态度认真，能够主动思考，报告质量较高。', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(3, 8, 2, 85, '参与度高，有独立见解，需进一步提升表达能力。', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(10, 8, 2, 82, '基本完成任务，建议更加深入思考。', DATE_SUB(NOW(), INTERVAL 13 DAY)),

-- 文化遗产调研 (活动9 - 多教师评分)
-- 张老师评分
(5, 9, 1, 90, '调研认真细致，报告质量高。', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(6, 9, 1, 94, '数据分析能力强，建议切实可行。', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(10, 9, 1, 86, '参与积极，团队协作能力好。', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(11, 9, 1, 88, '采访技巧好，记录完整。', DATE_SUB(NOW(), INTERVAL 20 DAY)),
(15, 9, 1, 84, '态度认真，需提升分析深度。', DATE_SUB(NOW(), INTERVAL 20 DAY)),
-- 李老师评分
(5, 9, 2, 88, '研究方法得当，结论有说服力。', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(6, 9, 2, 92, '专业素养高，报告规范。', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(10, 9, 2, 85, '基础扎实，可进一步深化。', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(11, 9, 2, 86, '口述史记录生动真实。', DATE_SUB(NOW(), INTERVAL 19 DAY)),
(15, 9, 2, 83, '完成基本任务，表现中规中矩。', DATE_SUB(NOW(), INTERVAL 19 DAY)),
-- 王老师评分
(5, 9, 3, 91, '对非遗保护有独到见解。', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(6, 9, 3, 95, '综合表现突出，是本次活动的优秀代表。', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(10, 9, 3, 87, '团队贡献大，协调能力强。', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(11, 9, 3, 89, '文字功底好，报告可读性强。', DATE_SUB(NOW(), INTERVAL 18 DAY)),
(15, 9, 3, 85, '认真负责，有进步空间。', DATE_SUB(NOW(), INTERVAL 18 DAY));

-- ============================================================
-- 8. 公告数据（使用动态时间）
-- ============================================================
INSERT IGNORE INTO `notice` (`title`, `content`, `publisher_id`, `status`, `publish_time`) VALUES
('2025年暑期社会实践活动报名通知', '各位同学：\n\n2025年暑期社会实践活动现已开始报名！本次活动包括"暑期三下乡"、"企业参观实习"等多个项目，欢迎同学们积极参与。\n\n报名截止时间：2025年6月15日\n报名方式：登录系统在线报名\n\n如有疑问，请联系学工办。', 1, 'published', DATE_SUB(NOW(), INTERVAL 10 DAY)),
('关于提交社会实践报告的通知', '各位同学：\n\n请参与已结束社会实践活动的同学于活动结束后两周内提交实践报告。报告应包含实践过程记录、心得体会、收获总结等内容。\n\n未按时提交报告者，将影响最终成绩评定。', 1, 'published', DATE_SUB(NOW(), INTERVAL 8 DAY)),
('社会实践安全须知', '各位同学：\n\n为确保社会实践活动的顺利进行，请各位同学注意以下安全事项：\n\n1. 外出实践时务必结伴而行\n2. 保持手机通讯畅通\n3. 遵守活动纪律和作息时间\n4. 注意人身财产安全\n5. 如遇紧急情况及时联系带队老师', 1, 'published', DATE_SUB(NOW(), INTERVAL 5 DAY)),
('优秀实践团队表彰通知', '经评审，以下团队被评为2025年度优秀社会实践团队：\n\n1. 红色足迹探寻队（红色教育实践）\n2. 非遗传承调研组（文化遗产调研）\n\n请获奖团队成员于本周五下午3点到学工办领取荣誉证书。', 1, 'published', DATE_SUB(NOW(), INTERVAL 25 DAY)),
('科技创新实践项目启动公告', '各位同学：\n\n2025年科技创新实践项目现已启动！本次活动聚焦人工智能、大数据等前沿技术，由计算机学院多位教授担任导师。\n\n项目时间：2025年8月1日-8月31日\n地点：学校创新实验室\n名额：20人', 1, 'published', DATE_ADD(NOW(), INTERVAL 2 DAY));

-- ============================================================
-- 9. 系统日志数据（使用动态时间）
-- ============================================================
INSERT IGNORE INTO `system_log` (`user_id`, `username`, `operation`, `method`, `params`, `ip`, `create_time`) VALUES
(1, 'admin', '用户登录', 'POST /user/login', 'username=admin', '127.0.0.1', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 'admin', '访问管理员首页', 'GET /index', NULL, '127.0.0.1', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 'admin', '发布公告', 'POST /notice/add', 'title=2025年暑期社会实践活动报名通知', '127.0.0.1', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(2, 'teacher1', '用户登录', 'POST /user/login', 'username=teacher1', '192.168.1.101', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 'teacher1', '创建实践活动', 'POST /activity/add', 'title=暑期三下乡社会实践', '192.168.1.101', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(6, 'student1', '用户登录', 'POST /user/login', 'username=student1', '192.168.1.201', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(6, 'student1', '报名活动', 'POST /studentActivity/register', 'activityId=1', '192.168.1.201', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 'teacher1', '审核报名', 'POST /studentActivity/approve', 'id=1', '192.168.1.101', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'teacher2', '评定成绩', 'POST /grade/doGrade', 'studentId=1&activityId=8&score=92', '192.168.1.102', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(7, 'student2', '创建小组', 'POST /group/create', 'activityId=1&groupName=阳光支教队', '192.168.1.202', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(6, 'student1', '提交实践报告', 'POST /practiceReport/submit', 'activityId=8', '192.168.1.201', DATE_SUB(NOW(), INTERVAL 13 DAY));


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

-- 恢复安全更新模式（建议）
SET SQL_SAFE_UPDATES = 1;