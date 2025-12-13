package com.ssm.interceptor;

import com.ssm.entity.SystemLog;
import com.ssm.entity.User;
import com.ssm.service.SystemLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * 系统日志拦截器
 * 记录用户的操作行为
 */
public class LogInterceptor implements HandlerInterceptor {

    @Autowired
    private SystemLogService systemLogService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String requestURI = request.getRequestURI();
        String method = request.getMethod();
        
        // 忽略静态资源和某些频繁请求
        if (requestURI.contains("/static/") || requestURI.contains("/css/") || 
            requestURI.contains("/js/") || requestURI.contains("/images/") ||
            requestURI.endsWith(".css") || requestURI.endsWith(".js") ||
            requestURI.endsWith(".png") || requestURI.endsWith(".jpg") ||
            requestURI.endsWith(".ico")) {
            return true;
        }
        
        // 只记录已登录用户的操作
        if (user != null) {
            try {
                SystemLog log = new SystemLog();
                log.setUserId(user.getUserId());
                log.setUsername(user.getUsername());
                log.setOperation(getOperationDesc(requestURI, method));
                log.setMethod(method + " " + requestURI);
                log.setParams(getRequestParams(request));
                log.setIp(getClientIp(request));
                log.setCreateTime(new Date());
                
                systemLogService.addLog(log);
            } catch (Exception e) {
                // 日志记录失败不应该影响正常请求
                e.printStackTrace();
            }
        }
        
        return true;
    }
    
    /**
     * 根据请求路径生成操作描述
     */
    private String getOperationDesc(String uri, String method) {
        // 登录相关
        if (uri.contains("/login")) {
            return "用户登录";
        }
        if (uri.contains("/logout")) {
            return "用户登出";
        }
        
        // 学生管理
        if (uri.contains("/student/")) {
            if (uri.contains("/add") || uri.contains("/doAdd")) return "添加学生";
            if (uri.contains("/edit") || uri.contains("/doEdit")) return "编辑学生";
            if (uri.contains("/delete")) return "删除学生";
            if (uri.contains("/list")) return "查看学生列表";
            if (uri.contains("/view")) return "查看学生详情";
        }
        
        // 教师管理
        if (uri.contains("/teacher/")) {
            if (uri.contains("/add") || uri.contains("/doAdd")) return "添加教师";
            if (uri.contains("/edit") || uri.contains("/doEdit")) return "编辑教师";
            if (uri.contains("/delete")) return "删除教师";
            if (uri.contains("/list")) return "查看教师列表";
            if (uri.contains("/view")) return "查看教师详情";
        }
        
        // 活动管理
        if (uri.contains("/activity/")) {
            if (uri.contains("/add") || uri.contains("/doAdd")) return "创建活动";
            if (uri.contains("/edit") || uri.contains("/doEdit")) return "编辑活动";
            if (uri.contains("/delete")) return "删除活动";
            if (uri.contains("/list")) return "查看活动列表";
            if (uri.contains("/view")) return "查看活动详情";
            if (uri.contains("/myActivities")) return "查看我的活动";
        }
        
        // 报名管理
        if (uri.contains("/studentActivity/")) {
            if (uri.contains("/apply") || uri.contains("/join")) return "报名活动";
            if (uri.contains("/approve")) return "审核通过报名";
            if (uri.contains("/reject")) return "拒绝报名";
            if (uri.contains("/quit")) return "退出活动";
            if (uri.contains("/list")) return "查看报名列表";
        }
        
        // 成绩管理
        if (uri.contains("/grade/") || uri.contains("/gradeInfo/")) {
            if (uri.contains("/doGrade") || uri.contains("/add")) return "评定成绩";
            if (uri.contains("/update")) return "修改成绩";
            if (uri.contains("/list")) return "查看成绩列表";
            if (uri.contains("/view")) return "查看成绩详情";
        }
        
        // 日常任务
        if (uri.contains("/dailyTask/")) {
            if (uri.contains("/add") || uri.contains("/submit")) return "提交日常任务";
            if (uri.contains("/edit")) return "编辑日常任务";
            if (uri.contains("/list")) return "查看日常任务";
        }
        
        // 实践报告
        if (uri.contains("/practiceReport/") || uri.contains("/report/")) {
            if (uri.contains("/submit") || uri.contains("/add")) return "提交实践报告";
            if (uri.contains("/review")) return "审核实践报告";
            if (uri.contains("/list")) return "查看实践报告";
        }
        
        // 小组管理
        if (uri.contains("/group/")) {
            if (uri.contains("/create")) return "创建小组";
            if (uri.contains("/join")) return "加入小组";
            if (uri.contains("/leave") || uri.contains("/quit")) return "退出小组";
            if (uri.contains("/dissolve") || uri.contains("/delete")) return "解散小组";
            if (uri.contains("/list")) return "查看小组列表";
        }
        
        // 公告管理
        if (uri.contains("/notice/")) {
            if (uri.contains("/add") || uri.contains("/publish")) return "发布公告";
            if (uri.contains("/edit")) return "编辑公告";
            if (uri.contains("/delete")) return "删除公告";
            if (uri.contains("/list")) return "查看公告列表";
        }
        
        // 系统日志
        if (uri.contains("/systemLog/")) {
            if (uri.contains("/list")) return "查看系统日志";
            if (uri.contains("/delete")) return "删除日志";
        }
        
        // 首页
        if (uri.contains("/index") || uri.equals("/")) {
            return "访问首页";
        }
        
        // 导入导出
        if (uri.contains("/importExport/")) {
            if (uri.contains("/import")) return "导入数据";
            if (uri.contains("/export")) return "导出数据";
        }
        
        return method + " " + uri;
    }
    
    /**
     * 获取请求参数（简化处理）
     */
    private String getRequestParams(HttpServletRequest request) {
        String queryString = request.getQueryString();
        if (queryString != null && queryString.length() > 200) {
            return queryString.substring(0, 200) + "...";
        }
        return queryString;
    }
    
    /**
     * 获取客户端真实IP
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理时取第一个IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
