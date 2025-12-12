package com.ssm.service;

import com.ssm.entity.PracticeReport;
import java.util.List;

/**
 * 实践报告服务接口
 */
public interface PracticeReportService {
    /**
     * 根据ID查询报告
     * @param reportId 报告ID
     * @return 报告对象
     */
    PracticeReport findById(Integer reportId);

    /**
     * 根据学生ID和活动ID查询报告
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 报告对象
     */
    PracticeReport findByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 根据学生ID查询所有报告
     * @param studentId 学生ID
     * @return 报告列表
     */
    List<PracticeReport> findByStudentId(Integer studentId);

    /**
     * 根据活动ID查询所有报告
     * @param activityId 活动ID
     * @return 报告列表
     */
    List<PracticeReport> findByActivityId(Integer activityId);

    /**
     * 根据状态查询报告
     * @param status 状态
     * @return 报告列表
     */
    List<PracticeReport> findByStatus(String status);

    /**
     * 根据活动ID和状态查询报告
     * @param activityId 活动ID
     * @param status 状态
     * @return 报告列表
     */
    List<PracticeReport> findByActivityIdAndStatus(Integer activityId, String status);

    /**
     * 提交报告
     * @param report 报告对象
     * @return 是否成功
     */
    boolean submitReport(PracticeReport report);

    /**
     * 更新报告信息
     * @param report 报告对象
     * @return 是否成功
     */
    boolean updateReport(PracticeReport report);

    /**
     * 更新报告状态
     * @param reportId 报告ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateReportStatus(Integer reportId, String status);

    /**
     * 评分报告
     * @param reportId 报告ID
     * @param score 评分
     * @param comment 评语
     * @param teacherId 教师ID
     * @return 是否成功
     */
    boolean gradeReport(Integer reportId, Integer score, String comment, Integer teacherId);

    /**
     * 删除报告
     * @param reportId 报告ID
     * @return 是否成功
     */
    boolean deleteReport(Integer reportId);

    /**
     * 根据学生ID和活动ID删除报告
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean deleteByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 获取活动报告统计信息
     * @param activityId 活动ID
     * @return 统计信息
     */
    List<Object[]> getReportStatisticsByActivity(Integer activityId);

    /**
     * 获取活动报告数量
     * @param activityId 活动ID
     * @param status 状态
     * @return 报告数量
     */
    int getReportCountByActivityAndStatus(Integer activityId, String status);

    /**
     * 检查学生是否已提交报告
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否已提交
     */
    boolean isReportSubmitted(Integer studentId, Integer activityId);

    /**
     * 获取活动平均分
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getAverageScoreByActivity(Integer activityId);
    
    /**
     * 获取学生已提交的报告数量
     * @param studentId 学生ID
     * @return 已提交报告数量
     */
    int getSubmittedReportCount(Integer studentId);
}
