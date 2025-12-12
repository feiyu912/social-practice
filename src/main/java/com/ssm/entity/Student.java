package com.ssm.entity;

/**
 * 学生实体类
 */
public class Student {
    private Integer id;          // 学生ID（数据库主键）
    private Integer studentId;   // 学生ID
    private String studentNumber; // 学号
    private String className;    // 班级
    private Integer userId;      // 关联用户ID
    private String phone;        // 手机号
    private String email;        // 邮箱
    private String realName;     // 真实姓名（从user表关联获取）
    private Integer gender;      // 性别（1:男, 0:女）

    // 构造方法
    public Student() {
    }

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }


    public String getStudentNumber() {
        return studentNumber;
    }

    public void setStudentNumber(String studentNumber) {
        this.studentNumber = studentNumber;
    }




    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
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

    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", studentNumber='" + studentNumber + '\'' +
                ", className='" + className + '\'' +
                ", userId=" + userId +
                '}';
    }
}
