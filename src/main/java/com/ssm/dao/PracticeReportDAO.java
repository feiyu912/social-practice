package com.ssm.dao;

import com.ssm.entity.PracticeReport;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 实践报告DAO接口
 */
public interface PracticeReportDAO {
    /**
     * 根据ID查询报告
     * @param reportId 报告ID
     * @return 报告对象
     */
    PracticeReport findById(@Param("reportId") Integer reportId);

    /**
     * 根据学生ID和活动ID查询报告
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 报告对象
     */
    PracticeReport findByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 根据学生ID查询所有报告
     * @param studentId 学生ID
     * @return 报告列表
     */
    List<PracticeReport> findByStudentId(@Param("studentId") Integer studentId);

    /**
     * 根据活动ID查询所有报告
     * @param activityId 活动ID
     * @return 报告列表
     */
    List<PracticeReport> findByActivityId(@Param("activityId") Integer activityId);

    /**
     * 根据状态查询报告
     * @param status 状态
     * @return 报告列表
     */
    List<PracticeReport> findByStatus(@Param("status") String status);

    /**
     * 根据活动ID和状态查询报告
     * @param activityId 活动ID
     * @param status 状态
     * @return 报告列表
     */
    List<PracticeReport> findByActivityIdAndStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 添加报告
     * @param practiceReport 报告对象
     * @return 影响行数
     */
    int insert(PracticeReport practiceReport);

    /**
     * 更新报告信息
     * @param practiceReport 报告对象
     * @return 影响行数
     */
    int update(PracticeReport practiceReport);

    /**
     * 更新报告状态
     * @param reportId 报告ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("reportId") Integer reportId, @Param("status") String status);

    /**
     * 更新报告评分
     * @param reportId 报告ID
     * @param score 评分
     * @param comment 评语
     * @return 影响行数
     */
    int updateScore(@Param("reportId") Integer reportId, @Param("score") Integer score, @Param("comment") String comment);

    /**
     * 删除报告
     * @param reportId 报告ID
     * @return 影响行数
     */
    int delete(@Param("reportId") Integer reportId);

    /**
     * 根据学生ID和活动ID删除报告
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 影响行数
     */
    int deleteByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 查询活动报告统计
     * @param activityId 活动ID
     * @return 统计信息
     */
    List<Object[]> getReportStatisticsByActivity(@Param("activityId") Integer activityId);

    /**
     * 查询活动报告数量
     * @param activityId 活动ID
     * @param status 状态
     * @return 报告数量
     */
    int countByActivityIdAndStatus(@Param("activityId") Integer activityId, @Param("status") String status);
}
