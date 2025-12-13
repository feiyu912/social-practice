package com.ssm.controller;

import com.ssm.entity.*;
import com.ssm.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 实践报告控制器
 */
@Controller
@RequestMapping("practiceReport")
public class PracticeReportController {

    @Autowired
    private PracticeReportService practiceReportService;

    @Autowired
    private StudentService studentService;
    
    @Autowired
    private PracticeActivityService practiceActivityService;
    
    @Autowired
    private TeacherService teacherService;
    
    @Autowired
    private StudentActivityService studentActivityService;

    /**
     * 跳转到报告列表页面
     */
    @RequestMapping("list")
    public String reportList(@RequestParam(value = "activityId", required = false) Integer activityId,
                             Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        String role = user.getRole();
        List<PracticeReport> reports = new ArrayList<>();
        List<PracticeActivity> activities = new ArrayList<>();
        
        if ("student".equals(role)) {
            // 学生查看自己的报告
            Student student = studentService.findByUserId(user.getUserId());
            if (student != null) {
                reports = practiceReportService.findByStudentId(student.getId());
                // 获取学生已通过的活动列表
                List<StudentActivity> saList = studentActivityService.findByStudentIdWithActivity(student.getId());
                for (StudentActivity sa : saList) {
                    if (sa.getStatus() != null && sa.getStatus() == 1 && sa.getActivity() != null) {
                        activities.add(sa.getActivity());
                    }
                }
            }
        } else if ("teacher".equals(role)) {
            // 教师查看所负责活动的报告
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null) {
                activities = practiceActivityService.findByTeacherId(teacher.getId());
            }
            if (activityId != null) {
                reports = practiceReportService.findByActivityId(activityId);
            } else if (!activities.isEmpty()) {
                activityId = activities.get(0).getId();
                reports = practiceReportService.findByActivityId(activityId);
            }
        } else {
            // 管理员查看所有报告
            activities = practiceActivityService.findAll();
            if (activityId != null) {
                reports = practiceReportService.findByActivityId(activityId);
            } else if (!activities.isEmpty()) {
                activityId = activities.get(0).getId();
                reports = practiceReportService.findByActivityId(activityId);
            }
        }
        
        // 获取当前活动信息
        if (activityId != null) {
            PracticeActivity currentActivity = practiceActivityService.findById(activityId);
            model.addAttribute("currentActivity", currentActivity);
        }
        
        // 获取学生姓名映射
        Map<Integer, String> studentNames = new HashMap<>();
        for (PracticeReport report : reports) {
            if (report.getStudentId() != null && !studentNames.containsKey(report.getStudentId())) {
                Student stu = studentService.findById(report.getStudentId());
                studentNames.put(report.getStudentId(), stu != null ? stu.getRealName() : "未知");
            }
        }
        
        model.addAttribute("reports", reports);
        model.addAttribute("activities", activities);
        model.addAttribute("activityId", activityId);
        model.addAttribute("studentNames", studentNames);
        model.addAttribute("role", role);
        return "report/list";
    }
    
    /**
     * 跳转到添加报告页面
     */
    @RequestMapping(value = "add", method = RequestMethod.GET)
    public String add(@RequestParam(value = "activityId", required = false) Integer activityId,
                      Model model) {
        model.addAttribute("activityId", activityId);
        return "report/add";
    }

    /**
     * 处理添加报告的POST请求（学生提交报告）
     */
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("activityId") Integer activityId,
                        @RequestParam("title") String title,
                        @RequestParam("content") String content,
                        @RequestParam(value = "attachment", required = false) String attachment,
                        HttpSession session,
                        Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"student".equals(user.getRole())) {
            model.addAttribute("errorMsg", "只有学生可以提交报告");
            return "redirect:list";
        }

        Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("errorMsg", "学生信息不存在");
            return "redirect:list";
        }

        // 检查是否已提交报告
        if (practiceReportService.isReportSubmitted(student.getId(), activityId)) {
            model.addAttribute("errorMsg", "您已经提交过报告");
            return "redirect:list";
        }

        PracticeReport report = new PracticeReport();
        report.setStudentId(student.getId());
        report.setActivityId(activityId);
        report.setTitle(title);
        report.setContent(content);
        report.setAttachment(attachment);
        report.setStatus("pending");
        report.setSubmitTime(new Date());
        report.setUpdateTime(new Date());

        boolean success = practiceReportService.submitReport(report);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "提交报告失败，请重试");
            model.addAttribute("activityId", activityId);
            return "report/add";
        }
    }
    
    /**
     * 跳转到编辑报告页面
     */
    @RequestMapping(value = "edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id) {
        if (id != null) {
            PracticeReport report = practiceReportService.findById(id);
            model.addAttribute("report", report);
        }
        return "report/edit";
    }

    /**
     * 处理编辑报告的POST请求
     */
    @RequestMapping(value = "edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam("title") String title,
                         @RequestParam("content") String content,
                         @RequestParam(value = "attachment", required = false) String attachment,
                         HttpSession session,
                         Model model) {
        User user = (User) session.getAttribute("user");
        PracticeReport report = practiceReportService.findById(id);
        
        if (report == null) {
            return "redirect:list";
        }

        // 检查权限：只有报告作者可以修改
        if (user != null && "student".equals(user.getRole())) {
            Student student = studentService.findByUserId(user.getUserId());
            if (student == null || !student.getId().equals(report.getStudentId())) {
                model.addAttribute("errorMsg", "您只能修改自己的报告");
                model.addAttribute("report", report);
                return "report/edit";
            }
        }

        // 检查状态：只有待审核状态可以修改
        if (!"pending".equals(report.getStatus())) {
            model.addAttribute("errorMsg", "已审核的报告不能修改");
            model.addAttribute("report", report);
            return "report/edit";
        }

        report.setTitle(title);
        report.setContent(content);
        report.setAttachment(attachment);
        report.setUpdateTime(new Date());

        boolean success = practiceReportService.updateReport(report);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "修改报告失败，请重试");
            model.addAttribute("report", report);
            return "report/edit";
        }
    }
    
    /**
     * 查看报告详情
     */
    @RequestMapping("view")
    public String view(Model model, Integer id) {
        if (id != null) {
            PracticeReport report = practiceReportService.findById(id);
            model.addAttribute("report", report);
        }
        return "report/view";
    }
    
    /**
     * 删除报告
     */
    @RequestMapping("delete")
    public String delete(Integer id) {
        if (id != null) {
            practiceReportService.deleteReport(id);
        }
        return "redirect:list";
    }
    
    /**
     * 教师审核报告（通过/拒绝）
     */
    @RequestMapping("review")
    @ResponseBody
    public Map<String, Object> review(@RequestParam("id") Integer id,
                                       @RequestParam("status") String status,
                                       @RequestParam(value = "feedback", required = false) String feedback,
                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        
        if (!"teacher".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有教师和管理员可以审核报告");
            return result;
        }
        
        PracticeReport report = practiceReportService.findById(id);
        if (report == null) {
            result.put("success", false);
            result.put("message", "报告不存在");
            return result;
        }
        
        report.setStatus(status);
        report.setFeedback(feedback);
        report.setUpdateTime(new Date());
        
        boolean success = practiceReportService.updateReport(report);
        result.put("success", success);
        result.put("message", success ? "审核成功" : "审核失败");
        return result;
    }
}