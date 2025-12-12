package com.ssm.service;

import com.ssm.entity.PracticeActivity;
import java.util.List;

/**
 * 实践活动服务接口
 */
public interface PracticeActivityService {
    /**
     * 根据ID查询活动
     * @param activityId 活动ID
     * @return 活动对象
     */
    PracticeActivity findById(Integer activityId);

    /**
     * 查询所有活动
     * @return 活动列表
     */
    List<PracticeActivity> findAll();

    /**
     * 根据教师ID查询活动
     * @param teacherId 教师ID
     * @return 活动列表
     */
    List<PracticeActivity> findByTeacherId(Integer teacherId);

    /**
     * 根据状态查询活动
     * @param status 状态
     * @return 活动列表
     */
    List<PracticeActivity> findByStatus(String status);

    /**
     * 查询进行中的活动
     * @return 活动列表
     */
    List<PracticeActivity> findActiveActivities();

    /**
     * 查询已结束的活动
     * @return 活动列表
     */
    List<PracticeActivity> findCompletedActivities();

    /**
     * 添加活动
     * @param activity 活动对象
     * @return 是否成功
     */
    boolean addActivity(PracticeActivity activity);

    /**
     * 更新活动信息
     * @param activity 活动对象
     * @return 是否成功
     */
    boolean updateActivity(PracticeActivity activity);

    /**
     * 更新活动状态
     * @param activityId 活动ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateActivityStatus(Integer activityId, String status);

    /**
     * 更新参与人数
     * @param activityId 活动ID
     * @param participantCount 参与人数
     * @return 是否成功
     */
    boolean updateParticipantCount(Integer activityId, Integer participantCount);

    /**
     * 删除活动
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean deleteActivity(Integer activityId);

    /**
     * 获取活动总数
     * @return 活动总数
     */
    int getActivityCount();

    /**
     * 获取指定状态的活动数量
     * @param status 状态
     * @return 活动数量
     */
    int getActivityCountByStatus(String status);

    /**
     * 开始活动
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean startActivity(Integer activityId);

    /**
     * 结束活动
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean endActivity(Integer activityId);

    /**
     * 检查活动是否可报名
     * @param activityId 活动ID
     * @return 是否可报名
     */
    boolean canRegister(Integer activityId);

    /**
     * 检查活动是否可提交报告
     * @param activityId 活动ID
     * @return 是否可提交报告
     */
    boolean canSubmitReport(Integer activityId);

    /**
     * 根据关键字搜索活动
     * @param keyword 关键字（活动名称或描述）
     * @return 活动列表
     */
    List<PracticeActivity> searchByKeyword(String keyword);
}
