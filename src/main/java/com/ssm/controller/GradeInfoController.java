package com.ssm.controller;

import com.ssm.entity.GradeInfo;
import com.ssm.entity.Student;
import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.GradeInfoService;
import com.ssm.service.StudentService;
import com.ssm.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Date;
import java.util.List;
import java.util.Map;
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

    /**
     * 跳转到成绩列表页面
     */
    @RequestMapping("list")
    public String gradeList(@RequestParam(value = "activityId", required = false) Integer activityId,
                            Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<GradeInfo> grades = new java.util.ArrayList<>();
        String role = user.getRole();

        if (activityId != null) {
            if ("teacher".equals(role)) {
                Teacher teacher = teacherService.findByUserId(user.getUserId());
                if (teacher != null) {
                    grades = gradeInfoService.findByTeacherId(teacher.getId())
                            .stream()
                            .filter(g -> activityId.equals(g.getActivityId()))
                            .collect(Collectors.toList());
                }
            } else if ("student".equals(role)) {
                Student student = studentService.findByUserId(user.getUserId());
                if (student != null) {
                    grades = gradeInfoService.findAllGradesByStudentAndActivity(student.getId(), activityId);
                }
            } else {
                grades = gradeInfoService.findByActivityId(activityId);
            }
        }

        Map<Integer, String> studentNames = new HashMap<>();
        Map<Integer, String> teacherNames = new HashMap<>();
        for (GradeInfo grade : grades) {
            if (grade.getStudentId() != null && !studentNames.containsKey(grade.getStudentId())) {
                Student stu = studentService.findById(grade.getStudentId());
                studentNames.put(grade.getStudentId(), stu != null ? stu.getRealName() : "-");
            }
            if (grade.getTeacherId() != null && !teacherNames.containsKey(grade.getTeacherId())) {
                Teacher teacher = teacherService.findById(grade.getTeacherId());
                teacherNames.put(grade.getTeacherId(), teacher != null ? teacher.getRealName() : "-");
            }
        }

        model.addAttribute("grades", grades);
        model.addAttribute("activityId", activityId);
        model.addAttribute("studentNames", studentNames);
        model.addAttribute("teacherNames", teacherNames);
        model.addAttribute("role", role);
        return "grade/list";
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
}