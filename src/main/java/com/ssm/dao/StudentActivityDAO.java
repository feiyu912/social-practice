package com.ssm.dao;

import com.ssm.entity.StudentActivity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 学生参与活动DAO接口
 */
public interface StudentActivityDAO {
    /**
     * 根据学生ID和活动ID查询
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 学生活动关联对象
     */
    StudentActivity findByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 根据学生ID查询参与的活动
     * @param studentId 学生ID
     * @return 学生活动关联列表
     */
    List<StudentActivity> findByStudentId(@Param("studentId") Integer studentId);
    
    /**
     * 根据学生ID查询参与的活动（包含活动详细信息）
     * @param studentId 学生ID
     * @return 学生活动关联列表（包含活动详细信息）
     */
    List<StudentActivity> findByStudentIdWithActivity(@Param("studentId") Integer studentId);
    
    /**
     * 根据活动ID查询参与的学生
     * @param activityId 活动ID
     * @return 学生活动关联列表
     */
    List<StudentActivity> findByActivityId(@Param("activityId") Integer activityId);
    
    /**
     * 根据活动ID查询报名列表（包含学生信息，教师审核用）
     * @param activityId 活动ID
     * @return 学生活动关联列表（包含学生详细信息）
     */
    List<StudentActivity> findByActivityIdWithStudent(@Param("activityId") Integer activityId);

    /**
     * 根据活动ID和状态查询参与的学生
     * @param activityId 活动ID
     * @param status 状态
     * @return 学生活动关联列表
     */
    List<StudentActivity> findByActivityIdAndStatus(@Param("activityId") Integer activityId, @Param("status") Integer status);

    /**
     * 添加学生活动关联
     * @param studentActivity 关联对象
     * @return 影响行数
     */
    int insert(StudentActivity studentActivity);

    /**
     * 更新状态
     * @param id 关联ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    /**
     * 更新小组ID
     * @param id 关联ID
     * @param groupId 小组ID
     * @return 影响行数
     */
    int updateGroupId(@Param("id") Integer id, @Param("groupId") Integer groupId);

    /**
     * 删除学生活动关联
     * @param id 关联ID
     * @return 影响行数
     */
    int delete(@Param("id") Integer id);

    /**
     * 根据学生ID和活动ID删除关联
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 影响行数
     */
    int deleteByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 查询活动参与人数
     * @param activityId 活动ID
     * @return 参与人数
     */
    int countByActivityId(@Param("activityId") Integer activityId);

    /**
     * 查询活动中特定状态的参与人数
     * @param activityId 活动ID
     * @param status 状态
     * @return 参与人数
     */
    int countByActivityIdAndStatus(@Param("activityId") Integer activityId, @Param("status") Integer status);

    /**
     * 根据小组ID查询成员
     * @param groupId 小组ID
     * @return 学生ID列表
     */
    List<Integer> findByGroupId(@Param("groupId") Integer groupId);
}