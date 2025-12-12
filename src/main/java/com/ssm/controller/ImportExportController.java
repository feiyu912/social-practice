package com.ssm.controller;

import com.ssm.entity.GradeInfo;
import com.ssm.entity.Student;
import com.ssm.entity.Teacher;
import com.ssm.entity.User;
import com.ssm.service.GradeInfoService;
import com.ssm.service.StudentService;
import com.ssm.service.TeacherService;
import com.ssm.service.UserService;
import com.ssm.utils.ExcelUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * 导入导出控制器
 */
@Controller
@RequestMapping("importExport")
public class ImportExportController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private UserService userService;

    @Autowired
    private GradeInfoService gradeInfoService;

    /**
     * 跳转到导入学生页面
     */
    @RequestMapping(value = "importStudents", method = RequestMethod.GET)
    public String importStudentsPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            return "redirect:/login";
        }
        return "importExport/importStudents";
    }

    /**
     * 导入学生名单
     */
    @RequestMapping(value = "importStudents", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> importStudents(@RequestParam("file") MultipartFile file, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有管理员可以导入学生名单");
            return result;
        }

        if (file.isEmpty()) {
            result.put("success", false);
            result.put("message", "文件为空");
            return result;
        }

        try {
            // 保存临时文件
            File tempFile = File.createTempFile("import_students_", ".csv");
            file.transferTo(tempFile);

            // 读取CSV文件
            List<String[]> data = ExcelUtil.readCSV(tempFile);
            if (data.isEmpty()) {
                result.put("success", false);
                result.put("message", "文件内容为空");
                return result;
            }

            // 解析数据并导入
            int successCount = 0;
            int failCount = 0;
            List<String> errors = new ArrayList<>();

            for (int i = 0; i < data.size(); i++) {
                String[] row = data.get(i);
                if (row.length < 4) {
                    errors.add("第" + (i + 1) + "行：数据格式不正确，需要至少4列（学号、姓名、班级、手机号）");
                    failCount++;
                    continue;
                }

                try {
                    String studentNumber = row[0].trim();
                    String name = row[1].trim();
                    String className = row[2].trim();
                    String phone = row.length > 3 ? row[3].trim() : "";
                    String email = row.length > 4 ? row[4].trim() : "";

                    // 检查学号是否已存在
                    if (studentService.isStudentNumberExists(studentNumber)) {
                        errors.add("第" + (i + 1) + "行：学号 " + studentNumber + " 已存在");
                        failCount++;
                        continue;
                    }

                    // 创建用户
                    User newUser = new User();
                    newUser.setUsername("student_" + studentNumber);
                    newUser.setPassword("123456"); // 默认密码
                    newUser.setRole("student");
                    newUser.setName(name);
                    newUser.setStatus(1);
                    userService.addUser(newUser);

                    // 创建学生
                    Student student = new Student();
                    student.setStudentNumber(studentNumber);
                    student.setClassName(className);
                    student.setPhone(phone);
                    student.setEmail(email);
                    student.setUserId(newUser.getUserId());

                    if (studentService.addStudent(student)) {
                        successCount++;
                    } else {
                        failCount++;
                        errors.add("第" + (i + 1) + "行：导入失败");
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("第" + (i + 1) + "行：导入失败 - " + e.getMessage());
                }
            }

            // 删除临时文件
            tempFile.delete();

            result.put("success", true);
            result.put("message", "导入完成：成功 " + successCount + " 条，失败 " + failCount + " 条");
            result.put("successCount", successCount);
            result.put("failCount", failCount);
            if (!errors.isEmpty()) {
                result.put("errors", errors);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "导入失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 跳转到导入教师页面
     */
    @RequestMapping(value = "importTeachers", method = RequestMethod.GET)
    public String importTeachersPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            return "redirect:/login";
        }
        return "importExport/importTeachers";
    }

    /**
     * 导入教师名单
     */
    @RequestMapping(value = "importTeachers", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> importTeachers(@RequestParam("file") MultipartFile file, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "只有管理员可以导入教师名单");
            return result;
        }

        if (file.isEmpty()) {
            result.put("success", false);
            result.put("message", "文件为空");
            return result;
        }

        try {
            // 保存临时文件
            File tempFile = File.createTempFile("import_teachers_", ".csv");
            file.transferTo(tempFile);

            // 读取CSV文件
            List<String[]> data = ExcelUtil.readCSV(tempFile);
            if (data.isEmpty()) {
                result.put("success", false);
                result.put("message", "文件内容为空");
                return result;
            }

            // 解析数据并导入
            int successCount = 0;
            int failCount = 0;
            List<String> errors = new ArrayList<>();

            for (int i = 0; i < data.size(); i++) {
                String[] row = data.get(i);
                if (row.length < 3) {
                    errors.add("第" + (i + 1) + "行：数据格式不正确，需要至少3列（工号、姓名、部门）");
                    failCount++;
                    continue;
                }

                try {
                    String teacherNumber = row[0].trim();
                    String name = row[1].trim();
                    String department = row[2].trim();
                    String phone = row.length > 3 ? row[3].trim() : "";
                    String email = row.length > 4 ? row[4].trim() : "";

                    // 检查工号是否已存在
                    if (teacherService.isTeacherNumberExists(teacherNumber)) {
                        errors.add("第" + (i + 1) + "行：工号 " + teacherNumber + " 已存在");
                        failCount++;
                        continue;
                    }

                    // 创建用户
                    User newUser = new User();
                    newUser.setUsername("teacher_" + teacherNumber);
                    newUser.setPassword("123456"); // 默认密码
                    newUser.setRole("teacher");
                    newUser.setName(name);
                    newUser.setStatus(1);
                    userService.addUser(newUser);

                    // 创建教师
                    Teacher teacher = new Teacher();
                    teacher.setTeacherNumber(teacherNumber);
                    teacher.setDepartment(department);
                    teacher.setPhone(phone);
                    teacher.setEmail(email);
                    teacher.setUserId(newUser.getUserId());

                    if (teacherService.addTeacher(teacher)) {
                        successCount++;
                    } else {
                        failCount++;
                        errors.add("第" + (i + 1) + "行：导入失败");
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("第" + (i + 1) + "行：导入失败 - " + e.getMessage());
                }
            }

            // 删除临时文件
            tempFile.delete();

            result.put("success", true);
            result.put("message", "导入完成：成功 " + successCount + " 条，失败 " + failCount + " 条");
            result.put("successCount", successCount);
            result.put("failCount", failCount);
            if (!errors.isEmpty()) {
                result.put("errors", errors);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "导入失败：" + e.getMessage());
        }

        return result;
    }

    /**
     * 导出成绩单
     */
    @RequestMapping("exportGrades")
    public void exportGrades(@RequestParam("activityId") Integer activityId, 
                             HttpServletResponse response, 
                             HttpSession session) throws IOException {
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!"teacher".equals(user.getRole()) && !"admin".equals(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "没有权限导出成绩单");
            return;
        }

        // 查询活动成绩
        List<GradeInfo> grades = gradeInfoService.findByActivityId(activityId);
        
        // 准备CSV数据
        String[] headers = {"学号", "姓名", "活动名称", "分数", "评语", "评分教师", "评分时间"};
        List<String[]> data = new ArrayList<>();
        
        // 这里需要关联查询学生和教师信息，简化处理
        for (GradeInfo grade : grades) {
            String[] row = {
                String.valueOf(grade.getStudentId()),
                "", // 姓名需要关联查询
                String.valueOf(grade.getActivityId()),
                grade.getScore() != null ? grade.getScore().toString() : "",
                grade.getComment() != null ? grade.getComment() : "",
                String.valueOf(grade.getTeacherId()),
                grade.getGradeTime() != null ? grade.getGradeTime().toString() : ""
            };
            data.add(row);
        }

        // 设置响应头
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=grades_" + activityId + ".csv");
        
        // 写入CSV内容
        String csvContent = ExcelUtil.generateCSV(headers, data);
        response.getWriter().write(new String(csvContent.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8));
        response.getWriter().flush();
    }
}


