package com.ssm.service;

import com.ssm.entity.StudentActivity;
import java.util.List;

/**
 * 学生参与活动服务接口
 */
public interface StudentActivityService {
    /**
     * 根据学生ID和活动ID查询参与信息
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 参与信息对象
     */
    StudentActivity findByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 根据学生ID查询所有参与的活动
     * @param studentId 学生ID
     * @return 参与信息列表
     */
    List<StudentActivity> findByStudentId(Integer studentId);
    
    /**
     * 根据学生ID查询所有参与的活动（包含活动详细信息）
     * @param studentId 学生ID
     * @return 参与信息列表（包含活动详细信息）
     */
    List<StudentActivity> findByStudentIdWithActivity(Integer studentId);

    /**
     * 根据活动ID查询所有参与的学生
     * @param activityId 活动ID
     * @return 参与信息列表
     */
    List<StudentActivity> findByActivityId(Integer activityId);
    
    /**
     * 根据活动ID查询报名列表（包含学生信息，教师审核用）
     * @param activityId 活动ID
     * @return 参与信息列表（包含学生详细信息）
     */
    List<StudentActivity> findByActivityIdWithStudent(Integer activityId);

    /**
     * 根据活动ID和状态查询参与信息
     * @param activityId 活动ID
     * @param status 状态
     * @return 参与信息列表
     */
    List<StudentActivity> findByActivityIdAndStatus(Integer activityId, Integer status);

    /**
     * 学生报名活动
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean registerActivity(Integer studentId, Integer activityId);

    /**
     * 学生取消报名
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean cancelRegistration(Integer studentId, Integer activityId);

    /**
     * 更新参与状态
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @param status 新状态
     * @return 是否成功
     */
    boolean updateStatus(Integer studentId, Integer activityId, Integer status);
    
    /**
     * 通过报名ID更新状态（审核用）
     * @param id 报名记录ID
     * @param status 新状态(1:通过, 2:拒绝)
     * @return 是否成功
     */
    boolean updateStatusById(Integer id, Integer status);

    /**
     * 更新小组ID
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @param groupId 小组ID
     * @return 是否成功
     */
    boolean updateGroupId(Integer studentId, Integer activityId, Integer groupId);

    /**
     * 删除学生活动关联
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean deleteStudentActivity(Integer studentId, Integer activityId);

    /**
     * 获取活动参与人数
     * @param activityId 活动ID
     * @return 参与人数
     */
    int getActivityParticipantCount(Integer activityId);

    /**
     * 获取活动中特定状态的参与人数
     * @param activityId 活动ID
     * @param status 状态
     * @return 参与人数
     */
    int getActivityParticipantCountByStatus(Integer activityId, Integer status);

    /**
     * 检查学生是否已报名某活动
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否已报名
     */
    boolean isStudentRegistered(Integer studentId, Integer activityId);
    
    /**
     * 检查学生是否已通过某活动的报名审核
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否已通过审核
     */
    boolean isStudentApproved(Integer studentId, Integer activityId);

    /**
     * 获取学生活动统计
     * @param studentId 学生ID
     * @return 统计数组
     */
    List<Object[]> getStudentActivityStatistics(Integer studentId);
    
    /**
     * 获取学生已报名的活动数量
     * @param studentId 学生ID
     * @return 活动数量
     */
    int getRegisteredActivityCount(Integer studentId);
}