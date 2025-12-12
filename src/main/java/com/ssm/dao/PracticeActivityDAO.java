package com.ssm.dao;

import com.ssm.entity.PracticeActivity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 社会实践活动DAO接口
 */
public interface PracticeActivityDAO {
    /**
     * 根据ID查询活动
     * @param activityId 活动ID
     * @return 活动对象
     */
    PracticeActivity findById(@Param("activityId") Integer activityId);

    /**
     * 查询所有活动
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 活动列表
     */
    List<PracticeActivity> findAll(@Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 根据教师ID查询活动
     * @param teacherId 教师ID
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 活动列表
     */
    List<PracticeActivity> findByTeacherId(@Param("teacherId") Integer teacherId, @Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 根据状态查询活动
     * @param status 状态
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 活动列表
     */
    List<PracticeActivity> findByStatus(@Param("status") String status, @Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 添加活动
     * @param activity 活动对象
     * @return 影响行数
     */
    int insert(PracticeActivity activity);

    /**
     * 更新活动信息
     * @param activity 活动对象
     * @return 影响行数
     */
    int update(PracticeActivity activity);

    /**
     * 更新活动状态
     * @param activityId 活动ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 更新参与人数
     * @param activityId 活动ID
     * @param count 人数变化（正数增加，负数减少）
     * @return 影响行数
     */
    int updateParticipantCount(@Param("activityId") Integer activityId, @Param("count") Integer count);

    /**
     * 删除活动
     * @param activityId 活动ID
     * @return 影响行数
     */
    int delete(@Param("activityId") Integer activityId);

    /**
     * 查询活动总数
     * @return 活动总数
     */
    int count();

    /**
     * 根据教师ID查询活动总数
     * @param teacherId 教师ID
     * @return 活动总数
     */
    int countByTeacherId(@Param("teacherId") Integer teacherId);

    /**
     * 根据状态查询活动总数
     * @param status 状态
     * @return 活动总数
     */
    int countByStatus(@Param("status") String status);

    /**
     * 根据关键字搜索活动
     * @param keyword 关键字
     * @param offset 偏移量
     * @param limit 限制数量
     * @return 活动列表
     */
    List<PracticeActivity> searchByKeyword(@Param("keyword") String keyword, @Param("offset") Integer offset, @Param("limit") Integer limit);
}
