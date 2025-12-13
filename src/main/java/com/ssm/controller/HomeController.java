package com.ssm.controller;

import com.ssm.entity.Notice;
import com.ssm.entity.PracticeActivity;
import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 首页控制器
 */
@Controller
public class HomeController {

    @Autowired
    private UserService userService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private StudentActivityService studentActivityService;

    @Autowired
    private DailyTaskService dailyTaskService;

    @Autowired
    private PracticeReportService practiceReportService;

    @Autowired
    private PracticeActivityService practiceActivityService;

    @Autowired
    private GradeInfoService gradeInfoService;
    
    @Autowired
    private NoticeService noticeService;

    @RequestMapping("/")
    public String index() {
        return "redirect:/index";
    }

    @RequestMapping("/index")
    public String home(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        String role = user.getRole();
        model.addAttribute("user", user);
        
        // 获取最新公告（显示已发布的公告）
        List<Notice> notices = noticeService.findValidNotices();
        if (notices != null && notices.size() > 5) {
            notices = notices.subList(0, 5); // 只显示最新5条
        }
        model.addAttribute("notices", notices);

        if ("admin".equals(role)) {
            // 管理员首页统计数据
            int studentCount = studentService.getStudentCount();
            int teacherCount = teacherService.getTeacherCount();
            int activityCount = practiceActivityService.getActivityCount();

            model.addAttribute("studentCount", studentCount);
            model.addAttribute("teacherCount", teacherCount);
            model.addAttribute("activityCount", activityCount);
            return "admin/index";
        } else if ("teacher".equals(role)) {
            // 教师首页统计数据
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null) {
                // 负责的活动数
                List<PracticeActivity> teacherActivities = practiceActivityService.findByTeacherId(teacher.getId());
                int activityCount = teacherActivities != null ? teacherActivities.size() : 0;

                // 待审核报告数（教师负责的活动中待审核的报告）
                int pendingReportCount = 0;
                if (teacherActivities != null) {
                    for (PracticeActivity activity : teacherActivities) {
                        pendingReportCount += practiceReportService.getReportCountByActivityAndStatus(activity.getId(), "pending");
                    }
                }

                // 待评定成绩数（教师负责的活动中尚未由该教师评分的学生数）
                int pendingGradeCount = 0;
                if (teacherActivities != null) {
                    for (PracticeActivity activity : teacherActivities) {
                        // 获取活动的所有学生数，减去教师已评分的学生数
                        int totalStudents = studentActivityService.getActivityParticipantCount(activity.getId());
                        List<com.ssm.entity.GradeInfo> teacherGrades = gradeInfoService.findByTeacherId(teacher.getId());
                        int gradedCount = 0;
                        if (teacherGrades != null) {
                            for (com.ssm.entity.GradeInfo grade : teacherGrades) {
                                if (activity.getId().equals(grade.getActivityId())) {
                                    gradedCount++;
                                }
                            }
                        }
                        pendingGradeCount += (totalStudents - gradedCount);
                    }
                }
                if (pendingGradeCount < 0) pendingGradeCount = 0;

                model.addAttribute("activityCount", activityCount);
                model.addAttribute("pendingReportCount", pendingReportCount);
                model.addAttribute("pendingGradeCount", pendingGradeCount);
            } else {
                model.addAttribute("activityCount", 0);
                model.addAttribute("pendingReportCount", 0);
                model.addAttribute("pendingGradeCount", 0);
            }
            return "teacher/index";
        } else if ("student".equals(role)) {
            // 学生首页需要统计数据
            com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
            if (student != null) {
                // 获取学生统计数据
                int registeredActivityCount = studentActivityService.getRegisteredActivityCount(student.getId());
                int pendingTaskCount = dailyTaskService.getPendingTaskCount(student.getId());
                int submittedReportCount = practiceReportService.getSubmittedReportCount(student.getId());

                model.addAttribute("registeredActivityCount", registeredActivityCount);
                model.addAttribute("pendingTaskCount", pendingTaskCount);
                model.addAttribute("submittedReportCount", submittedReportCount);
            } else {
                model.addAttribute("registeredActivityCount", 0);
                model.addAttribute("pendingTaskCount", 0);
                model.addAttribute("submittedReportCount", 0);
            }
            return "student/index";
        }

        return "redirect:/login";
    }

    @RequestMapping("/login")
    public String login() {
        return "login";
    }

    @RequestMapping("/register")
    public String register() {
        return "register";
    }
}