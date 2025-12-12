package com.ssm.dao;

import com.ssm.entity.Student;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 学生DAO接口
 */
public interface StudentDAO {
    /**
     * 根据ID查询学生
     * @param studentId 学生ID
     * @return 学生对象
     */
    Student findById(@Param("studentId") Integer studentId);

    /**
     * 根据用户ID查询学生
     * @param userId 用户ID
     * @return 学生对象
     */
    Student findByUserId(@Param("userId") Integer userId);

    /**
     * 根据学号查询学生
     * @param studentNumber 学号
     * @return 学生对象
     */
    Student findByStudentNumber(@Param("studentNumber") String studentNumber);

    /**
     * 查询所有学生
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 学生列表
     */
    List<Student> findAll(@Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 添加学生
     * @param student 学生对象
     * @return 影响行数
     */
    int insert(Student student);

    /**
     * 更新学生信息
     * @param student 学生对象
     * @return 影响行数
     */
    int update(Student student);

    /**
     * 删除学生
     * @param studentId 学生ID
     * @return 影响行数
     */
    int delete(@Param("studentId") Integer studentId);

    /**
     * 查询学生总数
     * @return 学生总数
     */
    int count();

    /**
     * 根据关键字搜索学生（学号或姓名）
     * @param keyword 关键字
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 学生列表
     */
    List<Student> searchByKeyword(@Param("keyword") String keyword, @Param("offset") Integer offset, @Param("limit") Integer limit);
    
    /**
     * 根据姓名查询学生
     * @param name 姓名
     * @return 学生列表
     */
    List<Student> findByName(@Param("name") String name);
    
    /**
     * 根据班级名称查询学生
     * @param className 班级名称
     * @return 学生列表
     */
    List<Student> findByClassName(@Param("className") String className);
}