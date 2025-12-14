package com.ssm.controller;

import com.ssm.entity.*;
import com.ssm.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

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
    
    @Autowired
    private StudentActivityService studentActivityService;
    
    @Autowired
    private TeacherService teacherService;

    /**
     * 学生查看自己的任务列表
     */
    @RequestMapping("myTasks")
    public String myTasks(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            return "redirect:/login";
        }

        Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("error", "学生信息不存在");
            return "dailyTask/list";
        }

        List<DailyTask> tasks = dailyTaskService.findByStudentId(student.getId());
        model.addAttribute("tasks", tasks);
        
        // 获取学生已通过的活动列表，用于添加任务时选择
        List<PracticeActivity> activities = new ArrayList<>();
        List<StudentActivity> saList = studentActivityService.findByStudentIdWithActivity(student.getId());
        for (StudentActivity sa : saList) {
            if (sa.getStatus() != null && sa.getStatus() == 1 && sa.getActivity() != null) {
                activities.add(sa.getActivity());
            }
        }
        model.addAttribute("activities", activities);
        
        return "dailyTask/list";
    }

    /**
     * 学生添加任务
     */
    @RequestMapping("add")
    @ResponseBody
    public Map<String, Object> add(@RequestParam("title") String title,
                                   @RequestParam("content") String content,
                                   @RequestParam(value = "activityId", required = false) Integer activityId,
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

            Student student = studentService.findByUserId(user.getUserId());
            if (student == null) {
                result.put("success", false);
                result.put("message", "学生信息不存在");
                return result;
            }

            // 验证 activityId 不能为空
            if (activityId == null) {
                result.put("success", false);
                result.put("message", "请选择关联活动");
                return result;
            }

            DailyTask task = new DailyTask();
            task.setStudentId(student.getId());
            task.setActivityId(activityId);
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

            DailyTask task = dailyTaskService.findById(taskId);
            if (task == null) {
                result.put("success", false);
                result.put("message", "任务不存在");
                return result;
            }

            Student student = studentService.findByUserId(user.getUserId());
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
     * 教师查看学生的任务（改进版，支持活动选择）
     */
    @RequestMapping("list")
    public String list(@RequestParam(value = "activityId", required = false) Integer activityId,
                       Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        String role = user.getRole();
        List<PracticeActivity> activities = new ArrayList<>();
        List<Map<String, Object>> studentTasks = new ArrayList<>();
        
        if ("teacher".equals(role)) {
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null) {
                activities = practiceActivityService.findByTeacherId(teacher.getId());
            }
        } else if ("admin".equals(role)) {
            activities = practiceActivityService.findAll();
        } else if ("student".equals(role)) {
            return "redirect:/dailyTask/myTasks";
        }
        
        // 如果选择了活动，获取该活动下所有学生的任务
        if (activityId != null) {
            PracticeActivity currentActivity = practiceActivityService.findById(activityId);
            model.addAttribute("currentActivity", currentActivity);
            
            // 获取该活动的已通过学生
            List<StudentActivity> saList = studentActivityService.findByActivityIdWithStudent(activityId);
            for (StudentActivity sa : saList) {
                if (sa.getStatus() != null && sa.getStatus() == 1 && sa.getStudent() != null) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("student", sa.getStudent());
                    // 获取该学生的任务
                    List<DailyTask> tasks = dailyTaskService.findByStudentIdAndActivityId(sa.getStudent().getId(), activityId);
                    item.put("tasks", tasks);
                    item.put("taskCount", tasks.size());
                    long completedCount = tasks.stream().filter(t -> "completed".equals(t.getStatus())).count();
                    item.put("completedCount", completedCount);
                    studentTasks.add(item);
                }
            }
        } else if (!activities.isEmpty()) {
            // 默认选择第一个活动
            activityId = activities.get(0).getId();
            return "redirect:/dailyTask/list?activityId=" + activityId;
        }
        
        model.addAttribute("activities", activities);
        model.addAttribute("activityId", activityId);
        model.addAttribute("studentTasks", studentTasks);
        model.addAttribute("role", role);
        return "dailyTask/teacherList";
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