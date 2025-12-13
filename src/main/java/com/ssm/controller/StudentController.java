package com.ssm.controller;

import com.ssm.entity.Student;
import com.ssm.entity.User;
import com.ssm.service.StudentService;
import com.ssm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

/**
 * 学生控制器
 */
@Controller
@RequestMapping("student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private UserService userService;

    /**
     * 跳转到学生列表页面
     */
    @RequestMapping("list")
    public String studentList(@RequestParam(value = "searchKey", required = false) String searchKey,
                              Model model) {
        List<Student> students;
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            students = studentService.searchByKeyword(searchKey.trim());
        } else {
            students = studentService.findAll();
        }
        model.addAttribute("students", students);
        model.addAttribute("searchKey", searchKey);
        return "student/list";
    }
    
    /**
     * 跳转到添加学生页面
     */
    @RequestMapping(value = "add", method = RequestMethod.GET)
    public String add() {
        return "student/add";
    }

    /**
     * 处理添加学生的POST请求
     */
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("studentId") String studentNumber,
                        @RequestParam("realName") String realName,
                        @RequestParam(value = "gender", required = false, defaultValue = "男") String gender,
                        @RequestParam(value = "className", required = false) String className,
                        @RequestParam(value = "phone", required = false) String phone,
                        @RequestParam(value = "email", required = false) String email,
                        Model model) {
        // 检查学号是否已存在
        if (studentService.isStudentNumberExists(studentNumber)) {
            model.addAttribute("errorMsg", "学号已存在，请使用其他学号");
            return "student/add";
        }

        // 首先创建用户账号
        User user = new User();
        user.setUsername(studentNumber); // 使用学号作为用户名
        user.setPassword("123456"); // 默认密码
        user.setName(realName);
        user.setRole("student");
        user.setStatus(1);
        user.setPhone(phone);
        user.setEmail(email);
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        
        boolean userSuccess = userService.addUser(user);
        if (!userSuccess) {
            model.addAttribute("errorMsg", "创建用户账号失败");
            return "student/add";
        }

        // 创建学生信息
        Student student = new Student();
        student.setStudentNumber(studentNumber);
        student.setRealName(realName);
        student.setGender(gender);
        student.setClassName(className);
        student.setPhone(phone);
        student.setEmail(email);
        student.setUserId(user.getUserId());

        boolean success = studentService.addStudent(student);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "添加学生失败，请重试");
            return "student/add";
        }
    }
    
    /**
     * 跳转到编辑学生页面
     */
    @RequestMapping(value = "edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id) {
        if (id != null) {
            Student student = studentService.findById(id);
            model.addAttribute("student", student);
        }
        return "student/edit";
    }

    /**
     * 处理编辑学生的POST请求
     */
    @RequestMapping(value = "edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam(value = "studentId", required = false) String studentNumber,
                         @RequestParam(value = "realName", required = false) String realName,
                         @RequestParam(value = "gender", required = false, defaultValue = "男") String gender,
                         @RequestParam(value = "className", required = false) String className,
                         @RequestParam(value = "phone", required = false) String phone,
                         @RequestParam(value = "email", required = false) String email,
                         Model model) {
        Student student = studentService.findById(id);
        if (student == null) {
            return "redirect:list";
        }

        // 更新学生信息
        if (studentNumber != null) {
            student.setStudentNumber(studentNumber);
        }
        if (realName != null) {
            student.setRealName(realName);
        }
        student.setGender(gender);
        student.setClassName(className);
        student.setPhone(phone);
        student.setEmail(email);

        boolean success = studentService.updateStudent(student);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "更新学生信息失败，请重试");
            model.addAttribute("student", student);
            return "student/edit";
        }
    }
    
    /**
     * 查看学生详情
     */
    @RequestMapping("view")
    public String view(Model model, Integer id) {
        if (id != null) {
            Student student = studentService.findById(id);
            model.addAttribute("student", student);
        }
        return "student/view";
    }
    
    /**
     * 删除学生
     */
    @RequestMapping("delete")
    public String delete(Integer id) {
        if (id != null) {
            studentService.deleteStudent(id);
        }
        return "redirect:list";
    }
}