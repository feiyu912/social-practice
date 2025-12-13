package com.ssm.interceptor;

import com.ssm.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 权限拦截器
 * 实现基于角色的访问控制（RBAC）
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // 允许访问的公共路径
        if (path.startsWith("/login") || path.startsWith("/user/login") || 
            path.startsWith("/user/logout") || path.startsWith("/user/register") ||
            path.startsWith("/static/") || path.startsWith("/css/") || 
            path.startsWith("/js/") || path.startsWith("/images/") ||
            path.equals("/") || path.equals("/index")) {
            return true;
        }
        
        // 未登录用户重定向到登录页
        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }
        
        String role = user.getRole();
        
        // 根据角色和路径进行权限控制
        if (role == null) {
            response.sendRedirect(contextPath + "/login");
            return false;
        }
        
        // 学生权限控制
        if ("student".equals(role)) {
            // 学生可以访问的路径
            if (path.startsWith("/student/") && !path.startsWith("/student/add") && 
                !path.startsWith("/student/edit") && !path.startsWith("/student/delete")) {
                return true;
            }
            if (path.startsWith("/activity/list") || path.startsWith("/activity/view") || path.startsWith("/activity/student_list")) {
                return true;
            }
            if (path.startsWith("/studentActivity/")) {
                return true;
            }
            if (path.startsWith("/practiceReport/") || path.startsWith("/report/")) {
                return true;
            }
            if (path.startsWith("/dailyTask/")) {
                return true;
            }
            if (path.startsWith("/grade/view") || path.startsWith("/gradeInfo/view") || path.startsWith("/grade/myGrades")) {
                return true;
            }
            if (path.startsWith("/group/")) {
                return true;
            }
            // 学生可以查看公告
            if (path.startsWith("/notice/view") || path.startsWith("/notice/list")) {
                return true;
            }
            // 学生可以退出登录
            if (path.equals("/user/logout")) {
                return true;
            }
            // 学生不能访问其他管理功能
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问此页面");
            return false;
        }
        
        // 教师权限控制
        if ("teacher".equals(role)) {
            // 教师可以访问的路径
            if (path.startsWith("/activity/")) {
                // 检查是否是自己的活动（在Controller中进一步验证）
                return true;
            }
            if (path.startsWith("/studentActivity/")) {
                return true;
            }
            if (path.startsWith("/practiceReport/") || path.startsWith("/report/")) {
                return true;
            }
            if (path.startsWith("/grade/") || path.startsWith("/gradeInfo/")) {
                return true;
            }
            if (path.startsWith("/dailyTask/")) {
                return true;
            }
            if (path.startsWith("/group/")) {
                return true;
            }
            if (path.startsWith("/teacher/view") || path.startsWith("/teacher/edit") || path.startsWith("/teacher/index")) {
                // 教师只能查看和编辑自己的信息
                return true;
            }
            // 教师可以查看公告
            if (path.startsWith("/notice/view") || path.startsWith("/notice/list")) {
                return true;
            }
            // 教师不能访问学生和用户管理（但允许退出登录）
            if (path.startsWith("/student/") || 
                (path.startsWith("/user/") && !path.equals("/user/logout")) || 
                path.startsWith("/admin/") || path.startsWith("/systemLog/")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问此页面");
                return false;
            }
            return true;
        }
        
        // 管理员权限控制
        if ("admin".equals(role)) {
            // 管理员可以访问所有路径
            return true;
        }
        
        // 未知角色，拒绝访问
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问此页面");
        return false;
    }
}

