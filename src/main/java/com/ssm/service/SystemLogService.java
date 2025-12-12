package com.ssm.service;

import com.ssm.entity.SystemLog;
import java.util.List;

/**
 * 系统日志服务接口
 */
public interface SystemLogService {
    /**
     * 根据ID查询日志
     * @param logId 日志ID
     * @return 日志对象
     */
    SystemLog findById(Integer logId);

    /**
     * 根据用户ID查询日志
     * @param userId 用户ID
     * @return 日志列表
     */
    List<SystemLog> findByUserId(Integer userId);

    /**
     * 根据操作类型查询日志
     * @param operationType 操作类型
     * @return 日志列表
     */
    List<SystemLog> findByOperationType(String operationType);

    /**
     * 查询所有日志
     * @return 日志列表
     */
    List<SystemLog> findAll();

    /**
     * 根据时间范围查询日志
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 日志列表
     */
    List<SystemLog> findByTimeRange(String startTime, String endTime);

    /**
     * 添加日志
     * @param systemLog 日志对象
     * @return 是否成功
     */
    boolean addLog(SystemLog systemLog);

    /**
     * 更新日志
     * @param systemLog 日志对象
     * @return 是否成功
     */


    /**
     * 删除日志
     * @param logId 日志ID
     * @return 是否成功
     */
    boolean deleteLog(Integer logId);

    /**
     * 批量删除日志
     * @param logIds 日志ID列表
     * @return 删除成功的数量
     */
    int batchDelete(List<Integer> logIds);

    /**
     * 清空日志
     * @return 是否成功
     */
    boolean clearLogs();

    /**
     * 记录登录日志
     * @param userId 用户ID
     * @param username 用户名
     * @param ipAddress IP地址
     * @param result 登录结果
     */
    void recordLoginLog(Integer userId, String username, String ipAddress, String result);

    /**
     * 记录操作日志
     * @param userId 用户ID
     * @param operationType 操作类型
     * @param description 操作描述
     * @param result 操作结果
     */
    void recordOperationLog(Integer userId, String operationType, String description, String result);

    /**
     * 记录异常日志
     * @param userId 用户ID
     * @param operationType 操作类型
     * @param description 操作描述
     * @param errorInfo 错误信息
     */
    void recordErrorLog(Integer userId, String operationType, String description, String errorInfo);

    /**
     * 获取日志统计信息
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    List<Object[]> getLogStatistics(String startTime, String endTime);

    /**
     * 获取系统访问量统计
     * @param days 天数
     * @return 访问量统计
     */
    List<Object[]> getAccessStatistics(int days);

    /**
     * 更新日志
     * @param systemLog 日志对象
     * @return 是否成功
     */
    boolean updateLog(SystemLog systemLog);

    /**
     * 关键字搜索（用户名、操作描述）
     * @param keyword 关键词
     * @return 日志列表
     */
    List<SystemLog> searchLogs(String keyword);
}