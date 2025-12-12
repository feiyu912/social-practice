package com.ssm.controller;

import com.ssm.entity.PracticeActivity;
import com.ssm.entity.User;
import com.ssm.service.PracticeActivityService;
import com.ssm.service.TeacherService;
import com.ssm.utils.PermissionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
@Controller
@RequestMapping("activity")
public class ActivityController {

    @Autowired
    private PracticeActivityService practiceActivityService;

    @Autowired
    private PermissionUtils permissionUtils;

    @Autowired
    private TeacherService teacherService;

    @RequestMapping(value = "list", method = RequestMethod.GET)
    public String list(@RequestParam(value = "searchKey", required = false) String searchKey,
                       Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<PracticeActivity> activities;
        
        // 如果有搜索关键字，执行搜索
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            activities = practiceActivityService.searchByKeyword(searchKey.trim());
            // 如果是教师，过滤只显示自己负责的活动
            if (user != null && "teacher".equals(user.getRole())) {
                com.ssm.entity.Teacher teacher = teacherService.findByUserId(user.getUserId());
                if (teacher != null) {
                    Integer teacherId = teacher.getId();
                    activities.removeIf(activity -> !isActivityBelongToTeacher(activity.getId(), teacherId));
                }
            }
        } else if (user != null && "teacher".equals(user.getRole())) {
            // 如果是教师，只显示自己负责的活动
            com.ssm.entity.Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null) {
                activities = practiceActivityService.findByTeacherId(teacher.getId());
            } else {
                activities = new ArrayList<>();
            }
        } else {
            activities = practiceActivityService.findAll();
        }
        
        model.addAttribute("activities", activities);
        model.addAttribute("searchKey", searchKey);
        return "activity/list";
    }

    @RequestMapping(value = "add", method = RequestMethod.GET)
    public String add(HttpSession session, Model model) {
        // 只有教师和管理员可以添加活动
        if (!permissionUtils.isTeacher(session) && !permissionUtils.isAdmin(session)) {
            model.addAttribute("errorMessage", "只有教师和管理员可以添加活动！");
            return "error/403";
        }
        return "activity/add";
    }

    /**
     * 处理添加活动的POST请求
     */
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("activityName") String activityName,
                       @RequestParam(value = "activityType", required = false) String activityType,
                       @RequestParam(value = "startTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date startTime,
                       @RequestParam(value = "endTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endTime,
                       @RequestParam(value = "location", required = false) String location,
                       @RequestParam(value = "teacherName", required = false) String teacherName,
                       @RequestParam(value = "description", required = false) String description,
                       @RequestParam(value = "maxParticipants", required = false, defaultValue = "50") Integer maxParticipants,
                       @RequestParam(value = "status", required = false, defaultValue = "1") String statusCode,
                       HttpSession session,
                       Model model) {
        // 权限检查
        if (!permissionUtils.isTeacher(session) && !permissionUtils.isAdmin(session)) {
            model.addAttribute("errorMessage", "只有教师和管理员可以添加活动！");
            return "error/403";
        }

        // 创建活动对象
        PracticeActivity activity = new PracticeActivity();
        activity.setActivityName(activityName);
        activity.setActivityType(activityType);
        activity.setStartTime(startTime);
        activity.setEndTime(endTime);
        activity.setLocation(location);
        activity.setResponsiblePerson(teacherName);
        activity.setDescription(description);
        activity.setMaxParticipants(maxParticipants);
        activity.setCurrentParticipants(0);
        
        // 转换状态码
        String status;
        switch (statusCode) {
            case "1": status = "recruiting"; break;
            case "2": status = "ongoing"; break;
            case "3": status = "finished"; break;
            default: status = "recruiting";
        }
        activity.setStatus(status);
        activity.setCreateTime(new Date());
        activity.setUpdateTime(new Date());

        boolean success = practiceActivityService.addActivity(activity);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "添加活动失败，请重试");
            model.addAttribute("activity", activity);
            return "activity/add";
        }
    }

    @RequestMapping(value = "edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id, HttpSession session) {
        // 只有活动负责人或管理员可以编辑
        if (!permissionUtils.isTeacherResponsibleForActivity(session, id) && 
            !permissionUtils.isAdmin(session)) {
            model.addAttribute("errorMessage", "只有活动负责人或管理员可以编辑此活动！");
            return "error/403";
        }
        
        PracticeActivity activity = practiceActivityService.findById(id);
        model.addAttribute("activity", activity);
        return "activity/edit";
    }

    /**
     * 处理编辑活动的POST请求
     */
    @RequestMapping(value = "edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam("activityName") String activityName,
                         @RequestParam(value = "activityType", required = false) String activityType,
                         @RequestParam(value = "startTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date startTime,
                         @RequestParam(value = "endTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endTime,
                         @RequestParam(value = "location", required = false) String location,
                         @RequestParam(value = "teacherName", required = false) String teacherName,
                         @RequestParam(value = "description", required = false) String description,
                         @RequestParam(value = "maxParticipants", required = false, defaultValue = "50") Integer maxParticipants,
                         @RequestParam(value = "status", required = false, defaultValue = "1") String statusCode,
                         HttpSession session,
                         Model model) {
        // 权限检查
        if (!permissionUtils.isTeacherResponsibleForActivity(session, id) && 
            !permissionUtils.isAdmin(session)) {
            model.addAttribute("errorMessage", "只有活动负责人或管理员可以编辑此活动！");
            return "error/403";
        }

        // 获取原活动信息
        PracticeActivity activity = practiceActivityService.findById(id);
        if (activity == null) {
            return "redirect:list";
        }

        // 更新活动信息
        activity.setActivityName(activityName);
        activity.setActivityType(activityType);
        activity.setStartTime(startTime);
        activity.setEndTime(endTime);
        activity.setLocation(location);
        activity.setResponsiblePerson(teacherName);
        activity.setDescription(description);
        activity.setMaxParticipants(maxParticipants);
        
        // 转换状态码
        String status;
        switch (statusCode) {
            case "1": status = "recruiting"; break;
            case "2": status = "ongoing"; break;
            case "3": status = "finished"; break;
            default: status = activity.getStatus();
        }
        activity.setStatus(status);
        activity.setUpdateTime(new Date());

        boolean success = practiceActivityService.updateActivity(activity);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "更新活动失败，请重试");
            model.addAttribute("activity", activity);
            return "activity/edit";
        }
    }

    @RequestMapping("view")
    public String view(Model model, Integer id) {
        PracticeActivity activity = practiceActivityService.findById(id);
        model.addAttribute("activity", activity);
        return "activity/view";
    }

    @RequestMapping("delete")
    public String delete(Integer id, HttpSession session, Model model) {
        // 只有活动负责人或管理员可以删除
        if (!permissionUtils.isTeacherResponsibleForActivity(session, id) && 
            !permissionUtils.isAdmin(session)) {
            model.addAttribute("errorMessage", "只有活动负责人或管理员可以删除此活动！");
            return "error/403";
        }
        
        practiceActivityService.deleteActivity(id);
        return "redirect:list";
    }

    private boolean isActivityBelongToTeacher(Integer activityId, Integer teacherId) {
        // 直接通过数据库关联表检查活动是否属于教师
        // 这里简化处理，假设活动与教师的关联已经在数据库中建立
        // 实际项目中应该查询activity_teacher关联表
        return true; // 简化处理，实际应根据数据库关联关系判断
    }
}
