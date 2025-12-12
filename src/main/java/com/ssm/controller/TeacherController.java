package com.ssm.controller;

import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.TeacherService;
import com.ssm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Date;

@Controller
@RequestMapping(value="teacher")
public class TeacherController {

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private UserService userService;

    @RequestMapping(value="list")
    public String list(@RequestParam(value = "searchKey", required = false) String searchKey,
                       Model model) {
        List<Teacher> teachers;
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            teachers = teacherService.searchByKeyword(searchKey.trim());
        } else {
            teachers = teacherService.findAll();
        }
        model.addAttribute("teachers", teachers);
        model.addAttribute("searchKey", searchKey);
        return "teacher/list";
    }

    @RequestMapping(value="add", method = RequestMethod.GET)
    public String add() {
        return "teacher/add";
    }

    /**
     * 处理添加教师的POST请求
     */
    @RequestMapping(value="add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("teacherId") String teacherNumber,
                        @RequestParam("name") String name,
                        @RequestParam(value = "gender", required = false, defaultValue = "男") String genderStr,
                        @RequestParam(value = "department", required = false) String department,
                        @RequestParam(value = "position", required = false) String position,
                        @RequestParam(value = "phone", required = false) String phone,
                        @RequestParam(value = "email", required = false) String email,
                        Model model) {
        // 检查工号是否已存在
        if (teacherService.isTeacherNumberExists(teacherNumber)) {
            model.addAttribute("errorMsg", "工号已存在，请使用其他工号");
            return "teacher/add";
        }

        // 首先创建用户账号
        User user = new User();
        user.setUsername(teacherNumber); // 使用工号作为用户名
        user.setPassword("123456"); // 默认密码
        user.setName(name);
        user.setRole("teacher");
        user.setStatus(1);
        user.setPhone(phone);
        user.setEmail(email);
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        
        boolean userSuccess = userService.addUser(user);
        if (!userSuccess) {
            model.addAttribute("errorMsg", "创建用户账号失败");
            return "teacher/add";
        }

        // 创建教师信息
        Teacher teacher = new Teacher();
        teacher.setTeacherNumber(teacherNumber);
        teacher.setRealName(name);
        teacher.setGender("男".equals(genderStr) ? 1 : 0);
        teacher.setDepartment(department);
        teacher.setPosition(position);
        teacher.setPhone(phone);
        teacher.setEmail(email);
        teacher.setUserId(user.getUserId());

        boolean success = teacherService.addTeacher(teacher);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "添加教师失败，请重试");
            return "teacher/add";
        }
    }

    @RequestMapping(value="edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id) {
        Teacher teacher = teacherService.findById(id);
        model.addAttribute("teacher", teacher);
        return "teacher/edit";
    }

    /**
     * 处理编辑教师的POST请求
     */
    @RequestMapping(value="edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam(value = "teacherName", required = false) String teacherName,
                         @RequestParam(value = "gender", required = false, defaultValue = "男") String genderStr,
                         @RequestParam(value = "department", required = false) String department,
                         @RequestParam(value = "position", required = false) String position,
                         @RequestParam(value = "phone", required = false) String phone,
                         @RequestParam(value = "email", required = false) String email,
                         Model model) {
        Teacher teacher = teacherService.findById(id);
        if (teacher == null) {
            return "redirect:list";
        }

        // 更新教师信息
        if (teacherName != null) {
            teacher.setRealName(teacherName);
        }
        teacher.setGender("男".equals(genderStr) ? 1 : 0);
        teacher.setDepartment(department);
        teacher.setPosition(position);
        teacher.setPhone(phone);
        teacher.setEmail(email);

        boolean success = teacherService.updateTeacher(teacher);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "更新教师信息失败，请重试");
            model.addAttribute("teacher", teacher);
            return "teacher/edit";
        }
    }

    @RequestMapping(value="view")
    public String view(Model model, Integer id) {
        Teacher teacher = teacherService.findById(id);
        model.addAttribute("teacher", teacher);
        return "teacher/view";
    }

    @RequestMapping(value="delete")
    public String delete(Integer id) {
        if (id != null) {
            teacherService.deleteTeacher(id);
        }
        return "redirect:list";
    }
}
