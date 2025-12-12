package com.ssm.controller;

import com.ssm.entity.DailyTask;
import com.ssm.entity.PracticeActivity;
import com.ssm.entity.User;
import com.ssm.service.DailyTaskService;
import com.ssm.service.PracticeActivityService;
import com.ssm.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 日常任务管理控制器
 */
@Controller
@RequestMapping("dailyTask")
public class DailyTaskController {

    @Autowired
    private DailyTaskService dailyTaskService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private PracticeActivityService practiceActivityService;

    /**
     * 学生查看自己的任务列表
     */
    @RequestMapping("myTasks")
    public String myTasks(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            return "redirect:/login";
        }

        // 获取学生ID
        com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("error", "学生信息不存在");
            return "dailyTask/list";
        }

        List<DailyTask> tasks = dailyTaskService.findByStudentId(student.getId());
        model.addAttribute("tasks", tasks);
        return "dailyTask/list";
    }

    /**
     * 学生添加任务
     */
    @RequestMapping("add")
    @ResponseBody
    public Map<String, Object> add(@RequestParam("title") String title,
                                   @RequestParam("content") String content,
                                   @RequestParam(value = "taskDate", required = false) String taskDateStr,
                                   @RequestParam(value = "priority", required = false) Integer priority,
                                   HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        try {
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

            DailyTask task = new DailyTask();
            task.setStudentId(student.getId());
            task.setTitle(title);
            task.setContent(content);
            task.setPriority(priority != null ? priority : 0);

            // 解析日期
            Date taskDate;
            if (taskDateStr != null && !taskDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                taskDate = sdf.parse(taskDateStr);
            } else {
                taskDate = new Date(); // 默认为今天
            }
            task.setTaskDate(taskDate);

            boolean success = dailyTaskService.addTask(task);
            result.put("success", success);
            result.put("message", success ? "添加成功" : "添加失败");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "添加失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 学生完成任务
     */
    @RequestMapping("complete")
    @ResponseBody
    public Map<String, Object> complete(@RequestParam("taskId") Integer taskId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        try {
            if (user == null || !"student".equals(user.getRole())) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 检查任务是否属于当前学生
            DailyTask task = dailyTaskService.findById(taskId);
            if (task == null) {
                result.put("success", false);
                result.put("message", "任务不存在");
                return result;
            }

            com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
            if (student == null || !student.getId().equals(task.getStudentId())) {
                result.put("success", false);
                result.put("message", "没有权限操作此任务");
                return result;
            }

            boolean success = dailyTaskService.completeTask(taskId);
            result.put("success", success);
            result.put("message", success ? "任务已完成" : "操作失败");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 教师查看学生的任务（按活动）
     */
    @RequestMapping("viewByActivity")
    public String viewByActivity(@RequestParam(value = "activityId", required = false) Integer activityId,
                                 @RequestParam(value = "studentId", required = false) Integer studentId,
                                 Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!"teacher".equals(user.getRole()) && !"admin".equals(user.getRole()))) {
            return "redirect:/login";
        }

        // 如果没有提供activityId，显示活动列表供选择
        if (activityId == null) {
            List<PracticeActivity> activities = practiceActivityService.findAll();
            model.addAttribute("activities", activities);
            return "dailyTask/selectActivity";
        }

        // 根据活动ID和学生ID查询任务
        // 这里需要根据活动ID和学生ID查询任务
        // 简化处理，实际应该关联查询
        List<DailyTask> tasks;
        if (studentId != null) {
            // 查询特定学生的任务
            tasks = dailyTaskService.findByStudentId(studentId);
        } else {
            // 如果没有指定学生，先显示空列表
            // 实际应该根据活动ID查询该活动下所有学生的任务
            tasks = new java.util.ArrayList<>();
        }
        
        PracticeActivity activity = practiceActivityService.findById(activityId);
        model.addAttribute("activityId", activityId);
        model.addAttribute("activity", activity);
        model.addAttribute("studentId", studentId);
        model.addAttribute("tasks", tasks);
        return "dailyTask/view";
    }

    /**
     * 教师查看学生的任务（按活动）- 支持viewByActivitys URL
     */
    @RequestMapping("viewByActivitys")
    public String viewByActivitys(@RequestParam(value = "activityId", required = false) Integer activityId,
                                  @RequestParam(value = "studentId", required = false) Integer studentId,
                                  Model model, HttpSession session) {
        // 重定向到viewByActivity方法
        return viewByActivity(activityId, studentId, model, session);
    }

    /**
     * 删除任务
     */
    @RequestMapping("delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam("taskId") Integer taskId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        try {
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 检查权限
            DailyTask task = dailyTaskService.findById(taskId);
            if (task == null) {
                result.put("success", false);
                result.put("message", "任务不存在");
                return result;
            }

            boolean hasPermission = false;
            if ("admin".equals(user.getRole())) {
                hasPermission = true;
            } else if ("student".equals(user.getRole())) {
                com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
                if (student != null && student.getId().equals(task.getStudentId())) {
                    hasPermission = true;
                }
            }

            if (!hasPermission) {
                result.put("success", false);
                result.put("message", "没有权限删除此任务");
                return result;
            }

            boolean success = dailyTaskService.deleteTask(taskId);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除失败：" + e.getMessage());
        }
        return result;
    }
}