package com.ssm.dao;

import com.ssm.entity.DailyTask;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 日常任务DAO接口
 */
public interface DailyTaskDAO {
    /**
     * 根据ID查询任务
     * @param taskId 任务ID
     * @return 任务对象
     */
    DailyTask findById(@Param("taskId") Integer taskId);

    /**
     * 根据学生ID查询任务
     * @param studentId 学生ID
     * @return 任务列表
     */
    List<DailyTask> findByStudentId(@Param("studentId") Integer studentId);

    /**
     * 根据学生ID和状态查询任务
     * @param studentId 学生ID
     * @param status 状态
     * @return 任务列表
     */
    List<DailyTask> findByStudentIdAndStatus(@Param("studentId") Integer studentId, @Param("status") Integer status);

    /**
     * 根据日期范围查询任务
     * @param studentId 学生ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 任务列表
     */
    List<DailyTask> findByDateRange(@Param("studentId") Integer studentId, 
                                   @Param("startDate") Date startDate, 
                                   @Param("endDate") Date endDate);

    /**
     * 查询今日任务
     * @param studentId 学生ID
     * @param date 日期
     * @return 任务列表
     */
    List<DailyTask> findTodayTasks(@Param("studentId") Integer studentId, @Param("date") Date date);

    /**
     * 查询待完成任务
     * @param studentId 学生ID
     * @return 任务列表
     */
    List<DailyTask> findPendingTasks(@Param("studentId") Integer studentId);

    /**
     * 添加任务
     * @param dailyTask 任务对象
     * @return 影响行数
     */
    int insert(DailyTask dailyTask);

    /**
     * 更新任务信息
     * @param dailyTask 任务对象
     * @return 影响行数
     */
    int update(DailyTask dailyTask);

    /**
     * 更新任务状态
     * @param taskId 任务ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("taskId") Integer taskId, @Param("status") Integer status);

    /**
     * 更新任务完成时间
     * @param taskId 任务ID
     * @param completedTime 完成时间
     * @return 影响行数
     */
    int updateCompletedTime(@Param("taskId") Integer taskId, @Param("completedTime") Date completedTime);

    /**
     * 删除任务
     * @param taskId 任务ID
     * @return 影响行数
     */
    int delete(@Param("taskId") Integer taskId);

    /**
     * 批量删除任务
     * @param taskIds 任务ID列表
     * @return 影响行数
     */
    int batchDelete(@Param("taskIds") List<Integer> taskIds);

    /**
     * 查询学生任务统计
     * @param studentId 学生ID
     * @return 统计信息
     */
    List<Object[]> getTaskStatistics(@Param("studentId") Integer studentId);
}