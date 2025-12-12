package com.ssm.service;

import com.ssm.entity.Student;
import java.util.List;

/**
 * 学生服务接口
 */
public interface StudentService {
    /**
     * 根据ID查询学生
     * @param studentId 学生ID
     * @return 学生对象
     */
    Student findById(Integer studentId);

    /**
     * 根据用户ID查询学生
     * @param userId 用户ID
     * @return 学生对象
     */
    Student findByUserId(Integer userId);

    /**
     * 根据学号查询学生
     * @param studentNumber 学号
     * @return 学生对象
     */
    Student findByStudentNumber(String studentNumber);

    /**
     * 查询所有学生
     * @return 学生列表
     */
    List<Student> findAll();

    /**
     * 根据姓名模糊查询学生
     * @param name 姓名
     * @return 学生列表
     */
    List<Student> findByName(String name);

    /**
     * 根据班级查询学生
     * @param className 班级名称
     * @return 学生列表
     */
    List<Student> findByClassName(String className);

    /**
     * 添加学生
     * @param student 学生对象
     * @return 是否成功
     */
    boolean addStudent(Student student);

    /**
     * 更新学生信息
     * @param student 学生对象
     * @return 是否成功
     */
    boolean updateStudent(Student student);

    /**
     * 删除学生
     * @param studentId 学生ID
     * @return 是否成功
     */
    boolean deleteStudent(Integer studentId);

    /**
     * 获取学生总数
     * @return 学生总数
     */
    int getStudentCount();

    /**
     * 检查学号是否存在
     * @param studentNumber 学号
     * @return 是否存在
     */
    boolean isStudentNumberExists(String studentNumber);

    /**
     * 批量删除学生
     * @param studentIds 学生ID列表
     * @return 删除成功的数量
     */
    int batchDeleteStudents(List<Integer> studentIds);

    /**
     * 导入学生信息
     * @param students 学生列表
     * @return 导入成功的数量
     */
    int importStudents(List<Student> students);

    /**
     * 根据关键字搜索学生
     * @param keyword 关键字（学号或姓名）
     * @return 学生列表
     */
    List<Student> searchByKeyword(String keyword);
}