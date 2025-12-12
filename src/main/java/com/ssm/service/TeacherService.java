package com.ssm.service;

import com.ssm.entity.Teacher;
import java.util.List;

/**
 * 教师服务接口
 */
public interface TeacherService {
    /**
     * 根据ID查询教师
     * @param teacherId 教师ID
     * @return 教师对象
     */
    Teacher findById(Integer teacherId);

    /**
     * 根据用户ID查询教师
     * @param userId 用户ID
     * @return 教师对象
     */
    Teacher findByUserId(Integer userId);

    /**
     * 根据工号查询教师
     * @param teacherNumber 工号
     * @return 教师对象
     */
    Teacher findByTeacherNumber(String teacherNumber);

    /**
     * 查询所有教师
     * @return 教师列表
     */
    List<Teacher> findAll();

    /**
     * 根据姓名模糊查询教师
     * @param name 姓名
     * @return 教师列表
     */
    List<Teacher> findByName(String name);

    /**
     * 根据学院查询教师
     * @param department 学院
     * @return 教师列表
     */
    List<Teacher> findByDepartment(String department);

    /**
     * 根据职称查询教师
     * @param title 职称
     * @return 教师列表
     */
    List<Teacher> findByTitle(String title);

    /**
     * 添加教师
     * @param teacher 教师对象
     * @return 是否成功
     */
    boolean addTeacher(Teacher teacher);

    /**
     * 更新教师信息
     * @param teacher 教师对象
     * @return 是否成功
     */
    boolean updateTeacher(Teacher teacher);

    /**
     * 删除教师
     * @param teacherId 教师ID
     * @return 是否成功
     */
    boolean deleteTeacher(Integer teacherId);

    /**
     * 获取教师总数
     * @return 教师总数
     */
    int getTeacherCount();

    /**
     * 检查工号是否存在
     * @param teacherNumber 工号
     * @return 是否存在
     */
    boolean isTeacherNumberExists(String teacherNumber);

    /**
     * 批量删除教师
     * @param teacherIds 教师ID列表
     * @return 删除成功的数量
     */
    int batchDeleteTeachers(List<Integer> teacherIds);

    /**
     * 导入教师信息
     * @param teachers 教师列表
     * @return 导入成功的数量
     */
    int importTeachers(List<Teacher> teachers);

    /**
     * 根据关键字搜索教师
     * @param keyword 关键字（工号或姓名）
     * @return 教师列表
     */
    List<Teacher> searchByKeyword(String keyword);
}