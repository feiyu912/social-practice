package com.ssm.dao;

import com.ssm.entity.ActivityTeacher;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 活动教师关联DAO接口
 */
public interface ActivityTeacherDAO {
    /**
     * 根据活动ID查询教师列表
     * @param activityId 活动ID
     * @return 教师ID列表
     */
    List<Integer> findTeacherIdsByActivityId(@Param("activityId") Integer activityId);

    /**
     * 根据教师ID查询活动列表
     * @param teacherId 教师ID
     * @return 活动ID列表
     */
    List<Integer> findActivityIdsByTeacherId(@Param("teacherId") Integer teacherId);

    /**
     * 添加活动教师关联
     * @param activityTeacher 关联对象
     * @return 影响行数
     */
    int insert(ActivityTeacher activityTeacher);

    /**
     * 批量添加活动教师关联
     * @param activityTeachers 关联对象列表
     * @return 影响行数
     */
    int batchInsert(@Param("activityTeachers") List<ActivityTeacher> activityTeachers);

    /**
     * 根据活动ID删除关联
     * @param activityId 活动ID
     * @return 影响行数
     */
    int deleteByActivityId(@Param("activityId") Integer activityId);

    /**
     * 删除指定的活动教师关联
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @return 影响行数
     */
    int deleteByActivityAndTeacher(@Param("activityId") Integer activityId, @Param("teacherId") Integer teacherId);

    /**
     * 检查教师是否是活动负责人
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @return 存在返回1，不存在返回0
     */
    int checkTeacherInActivity(@Param("activityId") Integer activityId, @Param("teacherId") Integer teacherId);
}