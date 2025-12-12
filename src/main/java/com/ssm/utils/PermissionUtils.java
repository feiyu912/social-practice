package com.ssm.utils;

import com.ssm.dao.ActivityTeacherDAO;
import com.ssm.entity.User;
import com.ssm.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;

/**
 * 权限工具类
 * 用于检查用户权限
 */
@Component
public class PermissionUtils {

    @Autowired
    private ActivityTeacherDAO activityTeacherDAO;

    @Autowired
    private TeacherService teacherService;

    /**
     * 检查教师是否是活动的负责人
     * @param session HTTP会话
     * @param activityId 活动ID
     * @return 是否是负责人
     */
    public boolean isTeacherResponsibleForActivity(HttpSession session, Integer activityId) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"teacher".equals(user.getRole())) {
            return false;
        }

        // 获取教师ID
        com.ssm.entity.Teacher teacher = teacherService.findByUserId(user.getUserId());
        if (teacher == null) {
            return false;
        }

        // 检查教师是否是活动负责人
        return activityTeacherDAO.checkTeacherInActivity(activityId, teacher.getId()) > 0;
    }

    /**
     * 检查用户是否是管理员
     * @param session HTTP会话
     * @return 是否是管理员
     */
    public boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "admin".equals(user.getRole());
    }

    /**
     * 检查用户是否是教师
     * @param session HTTP会话
     * @return 是否是教师
     */
    public boolean isTeacher(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "teacher".equals(user.getRole());
    }

    /**
     * 检查用户是否是学生
     * @param session HTTP会话
     * @return 是否是学生
     */
    public boolean isStudent(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "student".equals(user.getRole());
    }
}

