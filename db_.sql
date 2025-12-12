-- 清空旧数据（按顺序删除以避免外键约束）
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE student_activity;
TRUNCATE TABLE student_group;
TRUNCATE TABLE practice_report;
TRUNCATE TABLE daily_task;
TRUNCATE TABLE score;
TRUNCATE TABLE grade_info;
TRUNCATE TABLE activity_teacher;
TRUNCATE TABLE practice_activity;
TRUNCATE TABLE student;
TRUNCATE TABLE teacher;
TRUNCATE TABLE user;
TRUNCATE TABLE notice;
SET FOREIGN_KEY_CHECKS = 1;

-- ========== 1. 用户数据 ==========
INSERT INTO `user` (`id`, `username`, `password`, `role`, `status`, `name`) VALUES
(1, 'admin', '123456', 'admin', 1, '系统管理员'),
(2, 'teacher1', '123456', 'teacher', 1, '张老师'),
(3, 'teacher2', '123456', 'teacher', 1, '李老师'),
(4, 'student1', '123456', 'student', 1, '学生A'),
(5, 'student2', '123456', 'student', 1, '学生B'),
(6, 'student3', '123456', 'student', 1, '学生C');

-- ========== 2. 教师数据 ==========
INSERT INTO `teacher` (`id`, `user_id`, `teacher_id`, `department`, `phone`, `email`) VALUES
(1, 2, 'T001', '计算机系', '13800138001', 'zhang@example.com'),
(2, 3, 'T002', '电子系', '13800138002', 'li@example.com');

-- ========== 3. 学生数据 ==========
INSERT INTO `student` (`id`, `user_id`, `student_id`, `class_name`, `phone`, `email`) VALUES
(1, 4, '2021001', '计算机科学与技术1班', '13900139001', 'student1@example.com'),
(2, 5, '2021002', '计算机科学与技术1班', '13900139002', 'student2@example.com'),
(3, 6, '2021003', '软件工程2班', '13900139003', 'student3@example.com');

-- ========== 4. 实践活动数据 ==========
INSERT INTO `practice_activity` (`id`, `title`, `description`, `start_time`, `end_time`, `location`, `quota`, `current_count`, `status`) VALUES
(1, '暑期社会实践活动', '本次活动旨在培养学生的社会责任感和实践能力', '2025-07-01 08:00:00', '2025-08-31 18:00:00', '北京市海淀区', 30, 2, 'recruiting'),
(2, '社区志愿服务', '参与社区志愿服务，帮助有需要的居民', '2025-06-01 09:00:00', '2025-06-30 17:00:00', '北京市朝阳区', 20, 0, 'recruiting');

-- ========== 5. 活动-教师关联 ==========
INSERT INTO `activity_teacher` (`activity_id`, `teacher_id`) VALUES
(1, 1),
(1, 2),
(2, 1);

-- ========== 6. 学生活动报名 ==========
INSERT INTO `student_activity` (`id`, `student_id`, `activity_id`, `group_id`, `status`, `join_time`, `update_time`) VALUES
(1, 1, 1, NULL, 0, NOW(), NOW()),
(2, 2, 1, NULL, 0, NOW(), NOW());

-- ========== 7. 学生小组 ==========
INSERT INTO `student_group` (`id`, `activity_id`, `group_name`, `leader_id`, `member_count`) VALUES
(1, 1, '第一小组', 1, 2);

-- 更新学生的小组
UPDATE `student_activity` SET `group_id` = 1 WHERE `student_id` IN (1, 2) AND `activity_id` = 1;

-- ========== 8. 实践报告 ==========
INSERT INTO `practice_report` (`student_id`, `activity_id`, `title`, `content`, `status`, `submit_time`, `update_time`) VALUES
(1, 1, '暑期实践报告', '本次实践活动让我收获颇丰...', 'pending', NOW(), NOW()),
(2, 1, '社会实践心得', '通过这次活动，我学到了很多...', 'reviewed', NOW(), NOW());

-- ========== 9. 公告 ==========
INSERT INTO `notice` (`id`, `title`, `content`, `publisher_id`, `status`, `publish_time`) VALUES
(1, '关于暑期社会实践活动的通知', '各位同学：暑期社会实践活动即将开始，请及时报名参加。', 1, 'published', NOW()),
(2, '社区志愿服务招募', '现招募志愿者参与社区服务活动，欢迎踊跃报名。', 2, 'published', NOW());