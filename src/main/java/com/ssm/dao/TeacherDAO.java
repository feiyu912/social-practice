package com.ssm.dao;

import com.ssm.entity.Teacher;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 教师DAO接口
 */
public interface TeacherDAO {
    /**
     * 根据ID查询教师
     * @param teacherId 教师ID
     * @return 教师对象
     */
    Teacher findById(@Param("teacherId") Integer teacherId);

    /**
     * 根据用户ID查询教师
     * @param userId 用户ID
     * @return 教师对象
     */
    Teacher findByUserId(@Param("userId") Integer userId);

    /**
     * 根据工号查询教师
     * @param teacherNumber 工号
     * @return 教师对象
     */
    Teacher findByTeacherNumber(@Param("teacherNumber") String teacherNumber);

    /**
     * 查询所有教师
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 教师列表
     */
    List<Teacher> findAll(@Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 添加教师
     * @param teacher 教师对象
     * @return 影响行数
     */
    int insert(Teacher teacher);

    /**
     * 更新教师信息
     * @param teacher 教师对象
     * @return 影响行数
     */
    int update(Teacher teacher);

    /**
     * 删除教师
     * @param teacherId 教师ID
     * @return 影响行数
     */
    int delete(@Param("teacherId") Integer teacherId);

    /**
     * 查询教师总数
     * @return 教师总数
     */
    int count();

    /**
     * 根据关键字搜索教师（工号或姓名）
     * @param keyword 关键字
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 教师列表
     */
    List<Teacher> searchByKeyword(@Param("keyword") String keyword, @Param("offset") Integer offset, @Param("limit") Integer limit);
    
    /**
     * 根据姓名查询教师
     * @param name 姓名
     * @return 教师列表
     */
    List<Teacher> findByName(@Param("name") String name);
    
    /**
     * 根据部门查询教师
     * @param department 部门
     * @return 教师列表
     */
    List<Teacher> findByDepartment(@Param("department") String department);
    
    /**
     * 根据职称查询教师
     * @param title 职称
     * @return 教师列表
     */
    List<Teacher> findByTitle(@Param("title") String title);
}