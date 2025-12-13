package com.ssm.service;

import com.ssm.entity.DailyTask;
import java.util.Date;
import java.util.List;

/**
 * 日常任务服务接口
 */
public interface DailyTaskService {
    /**
     * 根据ID查询任务
     * @param taskId 任务ID
     * @return 任务对象
     */
    DailyTask findById(Integer taskId);

    /**
     * 根据学生ID查询任务列表
     * @param studentId 学生ID
     * @return 任务列表
     */
    List<DailyTask> findByStudentId(Integer studentId);

    /**
     * 根据学生ID和状态查询任务
     * @param studentId 学生ID
     * @param status 状态
     * @return 任务列表
     */
    List<DailyTask> findByStudentIdAndStatus(Integer studentId, Integer status);

    /**
     * 根据日期范围查询任务
     * @param studentId 学生ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 任务列表
     */
    List<DailyTask> findByDateRange(Integer studentId, Date startDate, Date endDate);

    /**
     * 查询今日任务
     * @param studentId 学生ID
     * @param date 日期
     * @return 任务列表
     */
    List<DailyTask> findTodayTasks(Integer studentId, Date date);

    /**
     * 查询待完成任务
     * @param studentId 学生ID
     * @return 任务列表
     */
    List<DailyTask> findPendingTasks(Integer studentId);

    /**
     * 添加任务
     * @param dailyTask 任务对象
     * @return 是否成功
     */
    boolean addTask(DailyTask dailyTask);

    /**
     * 更新任务信息
     * @param dailyTask 任务对象
     * @return 是否成功
     */
    boolean updateTask(DailyTask dailyTask);

    /**
     * 更新任务状态
     * @param taskId 任务ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateStatus(Integer taskId, Integer status);

    /**
     * 完成任务
     * @param taskId 任务ID
     * @return 是否成功
     */
    boolean completeTask(Integer taskId);

    /**
     * 删除任务
     * @param taskId 任务ID
     * @return 是否成功
     */
    boolean deleteTask(Integer taskId);

    /**
     * 批量删除任务
     * @param taskIds 任务ID列表
     * @return 删除成功的数量
     */
    int batchDeleteTasks(List<Integer> taskIds);

    /**
     * 查询学生任务统计
     * @param studentId 学生ID
     * @return 统计信息
     */
    List<Object[]> getTaskStatistics(Integer studentId);
    
    /**
     * 获取学生待完成的任务数量
     * @param studentId 学生ID
     * @return 待完成任务数量
     */
    int getPendingTaskCount(Integer studentId);
    
    /**
     * 根据学生ID和活动ID查询任务
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 任务列表
     */
    List<DailyTask> findByStudentIdAndActivityId(Integer studentId, Integer activityId);
    
    /**
     * 根据活动ID查询所有任务
     * @param activityId 活动ID
     * @return 任务列表
     */
    List<DailyTask> findByActivityId(Integer activityId);
}


