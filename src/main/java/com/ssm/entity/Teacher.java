package com.ssm.entity;

/**
 * 教师实体类
 */
public class Teacher {
    private Integer id;          // 教师ID（数据库主键）
    private Integer teacherId;   // 教师ID
    private String teacherNumber; // 工号
    private String department;   // 部门
    private Integer userId;      // 关联用户ID
    private String phone;        // 手机号
    private String email;        // 邮箱
    private String realName;     // 真实姓名（从user表关联获取）
    private Integer gender;      // 性别（1:男, 0:女）
    private String college;      // 学院（与department相同或别名）
    private String position;     // 职务

    // 构造方法
    public Teacher() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Integer teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherNumber() {
        return teacherNumber;
    }

    public void setTeacherNumber(String teacherNumber) {
        this.teacherNumber = teacherNumber;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getCollege() {
        return college != null ? college : department;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Override
    public String toString() {
        return "Teacher{" +
                "teacherId=" + teacherId +
                ", teacherNumber='" + teacherNumber + '\'' +
                ", department='" + department + '\'' +
                ", userId=" + userId +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}