package com.ssm.controller;

import com.ssm.entity.PracticeActivity;
import com.ssm.entity.StudentActivity;
import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.PracticeActivityService;
import com.ssm.service.StudentActivityService;
import com.ssm.service.StudentService;
import com.ssm.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 学生参与活动控制器
 */
@Controller
@RequestMapping("studentActivity")
public class StudentActivityController {

    @Autowired
    private StudentActivityService studentActivityService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private PracticeActivityService practiceActivityService;

    /**
     * 学生报名活动（只有招募中的活动可以报名）
     */
    @RequestMapping(value = "register", method = {org.springframework.web.bind.annotation.RequestMethod.GET, org.springframework.web.bind.annotation.RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> register(@RequestParam("activityId") Integer activityId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }
            
            if (!"student".equals(user.getRole())) {
                result.put("success", false);
                result.put("message", "只有学生可以报名");
                return result;
            }

            // 获取学生ID
            com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
            if (student == null) {
                result.put("success", false);
                result.put("message", "学生信息不存在，请联系管理员");
                return result;
            }
            
            // 检查活动是否为招募中状态
            PracticeActivity activity = practiceActivityService.findById(activityId);
            if (activity == null) {
                result.put("success", false);
                result.put("message", "活动不存在");
                return result;
            }
            if (!"recruiting".equals(activity.getStatus())) {
                result.put("success", false);
                result.put("message", "只有招募中的活动可以报名");
                return result;
            }

            boolean success = studentActivityService.registerActivity(student.getId(), activityId);
            result.put("success", success);
            result.put("message", success ? "报名成功，请等待教师审核" : "报名失败，可能已报名或活动不可报名");
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
            return result;
        }
    }

    /**
     * 学生取消报名（退选，只有待审核状态可以退选）
     */
    @RequestMapping("cancel")
    @ResponseBody
    public Map<String, Object> cancel(@RequestParam("activityId") Integer activityId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        // 获取学生ID
        com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            result.put("success", false);
            result.put("message", "学生信息不存在");
            return result;
        }

        boolean success = studentActivityService.cancelRegistration(student.getId(), activityId);
        result.put("success", success);
        result.put("message", success ? "退选成功" : "退选失败，只有待审核状态才能退选");
        return result;
    }

    /**
     * 学生改选活动（先退选再报名）
     */
    @RequestMapping("change")
    @ResponseBody
    public Map<String, Object> change(@RequestParam("oldActivityId") Integer oldActivityId,
                                       @RequestParam("newActivityId") Integer newActivityId,
                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        // 获取学生ID
        com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            result.put("success", false);
            result.put("message", "学生信息不存在");
            return result;
        }

        // 先退选旧活动
        boolean cancelSuccess = studentActivityService.cancelRegistration(student.getId(), oldActivityId);
        if (!cancelSuccess) {
            result.put("success", false);
            result.put("message", "退选旧活动失败");
            return result;
        }

        // 再报名新活动
        boolean registerSuccess = studentActivityService.registerActivity(student.getId(), newActivityId);
        result.put("success", registerSuccess);
        result.put("message", registerSuccess ? "改选成功" : "改选失败，新活动报名失败");
        return result;
    }

    /**
     * 查询学生参与的活动列表
     */
    @RequestMapping("myActivities")
    public String myActivities(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            return "redirect:/login";
        }

        // 获取学生ID
        com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("error", "学生信息不存在");
            return "studentActivity/list";
        }

        List<StudentActivity> activities = studentActivityService.findByStudentIdWithActivity(student.getId());
        model.addAttribute("activities", activities);
        return "studentActivity/list";
    }
    
    /**
     * 教师审核通过学生报名
     */
    @RequestMapping("approve")
    @ResponseBody
    public Map<String, Object> approve(@RequestParam("id") Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        
        if (!"teacher".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有教师和管理员可以审核");
            return result;
        }
        
        boolean success = studentActivityService.updateStatusById(id, 1); // 1=已通过
        result.put("success", success);
        result.put("message", success ? "审核通过" : "操作失败");
        return result;
    }
    
    /**
     * 教师拒绝学生报名
     */
    @RequestMapping("reject")
    @ResponseBody
    public Map<String, Object> reject(@RequestParam("id") Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        
        if (!"teacher".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有教师和管理员可以审核");
            return result;
        }
        
        boolean success = studentActivityService.updateStatusById(id, 2); // 2=已拒绝
        result.put("success", success);
        result.put("message", success ? "已拒绝" : "操作失败");
        return result;
    }

    /**
     * 查询活动的报名学生列表（教师/管理员使用）
     */
    @RequestMapping("list")
    public String list(@RequestParam(value = "activityId", required = false) Integer activityId, 
                       Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        // 教师或管理员查看报名管理
        if ("teacher".equals(user.getRole()) || "admin".equals(user.getRole())) {
            List<StudentActivity> allActivities = new ArrayList<>();
            List<PracticeActivity> teacherActivities = null;
            
            if ("teacher".equals(user.getRole())) {
                // 获取教师负责的活动
                Teacher teacher = teacherService.findByUserId(user.getUserId());
                if (teacher != null) {
                    teacherActivities = practiceActivityService.findByTeacherId(teacher.getId());
                }
            } else {
                // 管理员可以看到所有活动
                teacherActivities = practiceActivityService.findAll();
            }
            
            if (activityId != null) {
                // 查询特定活动的报名学生（带学生详细信息）
                allActivities = studentActivityService.findByActivityIdWithStudent(activityId);
                model.addAttribute("activityId", activityId);
                // 获取活动信息
                PracticeActivity activity = practiceActivityService.findById(activityId);
                model.addAttribute("currentActivity", activity);
            } else if (teacherActivities != null && !teacherActivities.isEmpty()) {
                // 默认显示第一个活动的报名情况
                activityId = teacherActivities.get(0).getId();
                allActivities = studentActivityService.findByActivityIdWithStudent(activityId);
                model.addAttribute("activityId", activityId);
                PracticeActivity activity = practiceActivityService.findById(activityId);
                model.addAttribute("currentActivity", activity);
            }
            
            model.addAttribute("activities", allActivities);
            model.addAttribute("teacherActivities", teacherActivities);
            model.addAttribute("isTeacher", true);
            return "studentActivity/teacherList";
        }
        
        // 学生查看自己的活动
        return "redirect:/studentActivity/myActivities";
    }
}