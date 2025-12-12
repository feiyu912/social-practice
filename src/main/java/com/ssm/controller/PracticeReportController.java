package com.ssm.controller;

import com.ssm.entity.PracticeReport;
import com.ssm.entity.User;
import com.ssm.entity.Student;
import com.ssm.service.PracticeReportService;
import com.ssm.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

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

    /**
     * 跳转到报告列表页面
     */
    @RequestMapping("list")
    public String reportList(@RequestParam(value = "activityId", required = false) Integer activityId,
                             Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<PracticeReport> reports;
        
        if (user != null && "student".equals(user.getRole())) {
            // 学生查看自己的报告
            com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
            if (student != null) {
                reports = practiceReportService.findByStudentId(student.getId());
            } else {
                reports = List.of();
            }
        } else if (user != null && "teacher".equals(user.getRole())) {
            // 教师查看所负责活动的报告
            if (activityId != null) {
                reports = practiceReportService.findByActivityId(activityId);
            } else {
                reports = practiceReportService.findByStatus("pending"); // 待审核的报告
            }
        } else {
            // 管理员查看所有报告
            if (activityId != null) {
                reports = practiceReportService.findByActivityId(activityId);
            } else {
                reports = practiceReportService.findByStatus("pending"); // 默认显示待审核的报告
            }
        }
        
        model.addAttribute("reports", reports);
        model.addAttribute("activityId", activityId);
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
}