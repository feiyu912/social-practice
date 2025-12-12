package com.ssm.controller;

import com.ssm.entity.Student;
import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.StudentService;
import com.ssm.service.TeacherService;
import com.ssm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @RequestMapping("list")
    public String list(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/list";
    }

    @RequestMapping("add")
    public String add() {
        return "user/add";
    }

    @RequestMapping("edit")
    public String edit(Model model, Integer id) {
        model.addAttribute("user", userService.findById(id));
        return "user/edit";
    }

    @RequestMapping("view")
    public String view(Model model, Integer id) {
        model.addAttribute("user", userService.findById(id));
        return "user/view";
    }

    @RequestMapping("delete")
    public String delete(Integer id) {
        if (id != null) {
            userService.deleteUser(id);
        }
        return "redirect:list";
    }

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String loginPage() {
        return "login";
    }

    @RequestMapping(value = "login", method = RequestMethod.POST)
    public String doLogin(@RequestParam("username") String username,
                          @RequestParam("password") String password,
                          HttpSession session,
                          Model model) {
        User user = userService.login(username, password);
        if (user == null) {
            model.addAttribute("errorMsg", "用户名或密码错误");
            return "login";
        }
        session.setAttribute("user", user);
        return "redirect:/index";
    }

    @RequestMapping("logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    /**
     * 跳转到注册页面
     */
    @RequestMapping(value = "register", method = RequestMethod.GET)
    public String registerPage() {
        return "register";
    }

    /**
     * 处理用户注册
     */
    @RequestMapping(value = "register", method = RequestMethod.POST)
    public String doRegister(@RequestParam("username") String username,
                             @RequestParam("password") String password,
                             @RequestParam("confirmPassword") String confirmPassword,
                             @RequestParam("name") String name,
                             @RequestParam(value = "email", required = false) String email,
                             @RequestParam(value = "phone", required = false) String phone,
                             @RequestParam("role") String role,
                             Model model) {
        // 验证密码确认
        if (!password.equals(confirmPassword)) {
            model.addAttribute("errorMsg", "两次输入的密码不一致");
            return "register";
        }

        // 检查用户名是否已存在
        if (userService.isUsernameExists(username)) {
            model.addAttribute("errorMsg", "用户名已存在，请选择其他用户名");
            return "register";
        }

        // 验证角色（只允许注册学生和教师，管理员只能由系统创建）
        if (!"student".equals(role) && !"teacher".equals(role)) {
            model.addAttribute("errorMsg", "无效的角色类型");
            return "register";
        }

        // 创建新用户
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRole(role);
        newUser.setStatus(1); // 默认启用

        boolean success = userService.addUser(newUser);
        if (success) {
            // 根据角色创建对应的学生或教师记录
            if ("student".equals(role)) {
                Student student = new Student();
                student.setUserId(newUser.getUserId());
                student.setStudentNumber(username); // 使用用户名作为学号
                student.setClassName("未分配"); // 默认班级
                student.setPhone(phone);
                student.setEmail(email);
                studentService.addStudent(student);
            } else if ("teacher".equals(role)) {
                Teacher teacher = new Teacher();
                teacher.setUserId(newUser.getUserId());
                teacher.setTeacherNumber(username); // 使用用户名作为工号
                teacher.setDepartment("未分配"); // 默认部门
                teacher.setPhone(phone);
                teacher.setEmail(email);
                teacherService.addTeacher(teacher);
            }
            model.addAttribute("successMsg", "注册成功！请登录");
            return "login";
        } else {
            model.addAttribute("errorMsg", "注册失败，请稍后重试");
            return "register";
        }
    }
}
