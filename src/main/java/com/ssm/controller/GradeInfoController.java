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
import java.util.stream.Collectors;

/**
 * 成绩信息控制器
 */
@Controller
@RequestMapping("grade")
public class GradeInfoController {

    @Autowired
    private GradeInfoService gradeInfoService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private PracticeActivityService practiceActivityService;

    @Autowired
    private StudentActivityService studentActivityService;

    /**
     * 成绩管理主页面 - 教师/管理员评分
     */
    @RequestMapping("list")
    public String gradeList(@RequestParam(value = "activityId", required = false) Integer activityId,
                            Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        String role = user.getRole();
        List<PracticeActivity> activities = new ArrayList<>();
        
        // 获取可管理的活动列表
        if ("teacher".equals(role)) {
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher != null) {
                activities = practiceActivityService.findByTeacherId(teacher.getId());
            }
        } else if ("admin".equals(role)) {
            activities = practiceActivityService.findAll();
        } else if ("student".equals(role)) {
            // 学生查看自己的成绩
            return "redirect:/grade/view";
        }
        
        model.addAttribute("activities", activities);
        model.addAttribute("role", role);
        
        // 如果选择了活动，获取该活动的学生列表和成绩
        if (activityId != null) {
            PracticeActivity currentActivity = practiceActivityService.findById(activityId);
            model.addAttribute("currentActivity", currentActivity);
            model.addAttribute("activityId", activityId);
            
            // 获取该活动已通过审核的学生列表
            List<StudentActivity> studentActivities = studentActivityService.findByActivityIdWithStudent(activityId);
            // 只保留已通过审核的学生
            studentActivities = studentActivities.stream()
                    .filter(sa -> sa.getStatus() != null && sa.getStatus() == 1)
                    .collect(Collectors.toList());
            
            // 获取每个学生的成绩信息
            List<Map<String, Object>> studentGradeList = new ArrayList<>();
            Teacher currentTeacher = null;
            if ("teacher".equals(role)) {
                currentTeacher = teacherService.findByUserId(user.getUserId());
            }
            
            for (StudentActivity sa : studentActivities) {
                Map<String, Object> item = new HashMap<>();
                Student stu = sa.getStudent();
                item.put("studentActivity", sa);
                item.put("student", stu);
                
                if (stu != null) {
                    // 获取该学生在该活动的所有评分
                    List<GradeInfo> grades = gradeInfoService.findAllGradesByStudentAndActivity(stu.getId(), activityId);
                    item.put("grades", grades);
                    
                    // 计算平均分
                    Double avgScore = gradeInfoService.getAverageScoreByStudentAndActivity(stu.getId(), activityId);
                    item.put("avgScore", avgScore);
                    
                    // 检查当前教师是否已评分
                    if (currentTeacher != null) {
                        boolean hasGraded = gradeInfoService.hasGradeByTeacher(stu.getId(), activityId, currentTeacher.getId());
                        item.put("hasGraded", hasGraded);
                        
                        // 获取当前教师的评分
                        GradeInfo myGrade = gradeInfoService.findByStudentAndActivityAndTeacher(stu.getId(), activityId, currentTeacher.getId());
                        item.put("myGrade", myGrade);
                    }
                }
                studentGradeList.add(item);
            }
            
            model.addAttribute("studentGradeList", studentGradeList);
            model.addAttribute("currentTeacher", currentTeacher);
        }
        
        return "grade/list";
    }
    
    /**
     * AJAX评分接口
     */
    @RequestMapping(value = "doGrade", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> doGrade(@RequestParam("studentId") Integer studentId,
                                        @RequestParam("activityId") Integer activityId,
                                        @RequestParam("score") Double score,
                                        @RequestParam(value = "comment", required = false) String comment,
                                        HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"teacher".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有教师可以评分");
            return result;
        }
        
        Teacher teacher = teacherService.findByUserId(user.getUserId());
        if (teacher == null) {
            result.put("success", false);
            result.put("message", "教师信息不存在");
            return result;
        }
        
        // 检查是否已评分
        if (gradeInfoService.hasGradeByTeacher(studentId, activityId, teacher.getId())) {
            result.put("success", false);
            result.put("message", "您已经对该学生评分，请使用修改功能");
            return result;
        }
        
        GradeInfo gradeInfo = new GradeInfo();
        gradeInfo.setStudentId(studentId);
        gradeInfo.setActivityId(activityId);
        gradeInfo.setTeacherId(teacher.getId());
        gradeInfo.setScore(score);
        gradeInfo.setComment(comment);
        gradeInfo.setGradeTime(new Date());
        gradeInfo.setUpdateTime(new Date());
        
        boolean success = gradeInfoService.addGrade(gradeInfo);
        result.put("success", success);
        result.put("message", success ? "评分成功" : "评分失败");
        return result;
    }
    
    /**
     * AJAX修改评分接口
     */
    @RequestMapping(value = "updateGrade", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updateGrade(@RequestParam("gradeId") Integer gradeId,
                                            @RequestParam("score") Double score,
                                            @RequestParam(value = "comment", required = false) String comment,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }
        
        GradeInfo gradeInfo = gradeInfoService.findById(gradeId);
        if (gradeInfo == null) {
            result.put("success", false);
            result.put("message", "评分记录不存在");
            return result;
        }
        
        // 检查权限
        if ("teacher".equals(user.getRole())) {
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher == null || !teacher.getId().equals(gradeInfo.getTeacherId())) {
                result.put("success", false);
                result.put("message", "您只能修改自己的评分");
                return result;
            }
        } else if (!"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "没有权限");
            return result;
        }
        
        gradeInfo.setScore(score);
        gradeInfo.setComment(comment);
        gradeInfo.setUpdateTime(new Date());
        
        boolean success = gradeInfoService.updateGrade(gradeInfo);
        result.put("success", success);
        result.put("message", success ? "修改成功" : "修改失败");
        return result;
    }
    
    /**
     * 跳转到添加成绩页面
     */
    @RequestMapping(value = "add", method = RequestMethod.GET)
    public String add(@RequestParam(value = "activityId", required = false) Integer activityId,
                      @RequestParam(value = "studentId", required = false) Integer studentId,
                      Model model) {
        model.addAttribute("activityId", activityId);
        model.addAttribute("studentId", studentId);
        return "grade/add";
    }

    /**
     * 处理添加成绩的POST请求（教师评分）
     */
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("activityId") Integer activityId,
                        @RequestParam("studentId") Integer studentId,
                        @RequestParam("score") Double score,
                        @RequestParam(value = "comment", required = false) String comment,
                        HttpSession session,
                        Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"teacher".equals(user.getRole())) {
            model.addAttribute("errorMsg", "只有教师可以评分");
            return "redirect:list?activityId=" + activityId;
        }

        // 获取教师ID
        Teacher teacher = teacherService.findByUserId(user.getUserId());
        if (teacher == null) {
            model.addAttribute("errorMsg", "教师信息不存在");
            return "redirect:list?activityId=" + activityId;
        }

        // 检查是否已评分
        if (gradeInfoService.hasGradeByTeacher(studentId, activityId, teacher.getId())) {
            model.addAttribute("errorMsg", "您已经对该学生评分");
            return "redirect:list?activityId=" + activityId;
        }

        GradeInfo gradeInfo = new GradeInfo();
        gradeInfo.setStudentId(studentId);
        gradeInfo.setActivityId(activityId);
        gradeInfo.setTeacherId(teacher.getId());
        gradeInfo.setScore(score);
        gradeInfo.setComment(comment);
        gradeInfo.setGradeTime(new Date());
        gradeInfo.setUpdateTime(new Date());

        boolean success = gradeInfoService.addGrade(gradeInfo);
        if (success) {
            return "redirect:list?activityId=" + activityId;
        } else {
            model.addAttribute("errorMsg", "评分失败，请重试");
            model.addAttribute("activityId", activityId);
            model.addAttribute("studentId", studentId);
            return "grade/add";
        }
    }
    
    /**
     * 跳转到编辑成绩页面
     */
    @RequestMapping(value = "edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id) {
        if (id != null) {
            GradeInfo grade = gradeInfoService.findById(id);
            model.addAttribute("grade", grade);
        }
        return "grade/edit";
    }

    /**
     * 处理编辑成绩的POST请求
     */
    @RequestMapping(value = "edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam("score") Double score,
                         @RequestParam(value = "comment", required = false) String comment,
                         HttpSession session,
                         Model model) {
        User user = (User) session.getAttribute("user");
        GradeInfo gradeInfo = gradeInfoService.findById(id);
        
        if (gradeInfo == null) {
            return "redirect:list";
        }

        // 检查权限：只有评分教师或管理员可以修改
        if (user != null && "teacher".equals(user.getRole())) {
            Teacher teacher = teacherService.findByUserId(user.getUserId());
            if (teacher == null || !teacher.getId().equals(gradeInfo.getTeacherId())) {
                model.addAttribute("errorMsg", "您只能修改自己的评分");
                model.addAttribute("grade", gradeInfo);
                return "grade/edit";
            }
        }

        gradeInfo.setScore(score);
        gradeInfo.setComment(comment);
        gradeInfo.setUpdateTime(new Date());

        boolean success = gradeInfoService.updateGrade(gradeInfo);
        if (success) {
            return "redirect:list?activityId=" + gradeInfo.getActivityId();
        } else {
            model.addAttribute("errorMsg", "修改评分失败，请重试");
            model.addAttribute("grade", gradeInfo);
            return "grade/edit";
        }
    }
    
    /**
     * 查看成绩详情（学生查看自己的成绩）
     */
    @RequestMapping("view")
    public String view(@RequestParam(value = "activityId", required = false) Integer activityId,
                       Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user != null && "student".equals(user.getRole())) {
            // 学生查看自己的成绩
            com.ssm.entity.Student student = studentService.findByUserId(user.getUserId());
            if (student != null) {
                if (activityId != null) {
                    // 查询该学生在该活动的所有教师评分
                    List<GradeInfo> grades = gradeInfoService.findAllGradesByStudentAndActivity(student.getId(), activityId);
                    // 计算平均分
                    Double avgScore = gradeInfoService.getAverageScoreByStudentAndActivity(student.getId(), activityId);
                    
                    model.addAttribute("grades", grades);
                    model.addAttribute("averageScore", avgScore);
                    model.addAttribute("activityId", activityId);
                } else {
                    // 查看所有活动的成绩
                    List<GradeInfo> grades = gradeInfoService.findByStudentId(student.getId());
                    model.addAttribute("grades", grades);
                }
            }
        }
        
        return "grade/view";
    }
    
    /**
     * 删除成绩
     */
    @RequestMapping("delete")
    public String delete(Integer id) {
        if (id != null) {
            gradeInfoService.deleteGrade(id);
        }
        return "redirect:list";
    }
    
    /**
     * 学生查看我的成绩（已结束活动的成绩）
     */
    @RequestMapping("myGrades")
    public String myGrades(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"student".equals(user.getRole())) {
            return "redirect:/login";
        }
        
        Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("error", "学生信息不存在");
            return "grade/myGrades";
        }
        
        // 获取学生参与的已结束活动
        List<StudentActivity> studentActivities = studentActivityService.findByStudentIdWithActivity(student.getId());
        List<Map<String, Object>> gradeList = new ArrayList<>();
        
        for (StudentActivity sa : studentActivities) {
            // 只显示已结束的活动成绩
            if (sa.getActivity() != null && "finished".equals(sa.getActivity().getStatus()) && sa.getStatus() != null && sa.getStatus() == 1) {
                Map<String, Object> item = new HashMap<>();
                item.put("activity", sa.getActivity());
                
                // 获取该活动的成绩
                List<GradeInfo> grades = gradeInfoService.findAllGradesByStudentAndActivity(student.getId(), sa.getActivityId());
                Double avgScore = gradeInfoService.getAverageScoreByStudentAndActivity(student.getId(), sa.getActivityId());
                
                item.put("grades", grades);
                item.put("avgScore", avgScore != null ? avgScore : 0);
                
                // 收集教师评语
                StringBuilder comments = new StringBuilder();
                for (GradeInfo g : grades) {
                    if (g.getComment() != null && !g.getComment().isEmpty()) {
                        Teacher t = teacherService.findById(g.getTeacherId());
                        if (t != null) {
                            comments.append(t.getRealName()).append(": ").append(g.getComment()).append("; ");
                        }
                    }
                }
                item.put("comments", comments.toString());
                
                gradeList.add(item);
            }
        }
        
        model.addAttribute("gradeList", gradeList);
        model.addAttribute("student", student);
        return "grade/myGrades";
    }
}