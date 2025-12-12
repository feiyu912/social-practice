package com.ssm.dao;

import com.ssm.entity.SystemLog;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 系统日志DAO接口
 */
public interface SystemLogDAO {
    /**
     * 根据ID查询日志
     * @param logId 日志ID
     * @return 日志对象
     */
    SystemLog findById(@Param("logId") Integer logId);

    /**
     * 根据用户ID查询日志
     * @param userId 用户ID
     * @return 日志列表
     */
    List<SystemLog> findByUserId(@Param("userId") Integer userId);

    /**
     * 根据操作类型查询日志
     * @param operationType 操作类型
     * @return 日志列表
     */
    List<SystemLog> findByOperationType(@Param("operationType") String operationType);

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
    List<SystemLog> findByTimeRange(@Param("startTime") String startTime, @Param("endTime") String endTime);

    /**
     * 添加日志
     * @param systemLog 日志对象
     * @return 影响行数
     */
    int insert(SystemLog systemLog);

    /**
     * 更新日志
     * @param systemLog 日志对象
     * @return 影响行数
     */
    int update(SystemLog systemLog);

    /**
     * 删除日志
     * @param logId 日志ID
     * @return 影响行数
     */
    int delete(@Param("logId") Integer logId);

    /**
     * 批量删除日志
     * @param logIds 日志ID列表
     * @return 删除成功的数量
     */
    int batchDelete(@Param("logIds") List<Integer> logIds);

    /**
     * 清空日志
     * @return 影响行数
     */
    int clearLogs();

    /**
     * 关键字搜索（用户名、操作描述）
     * @param keyword 关键词
     * @return 日志列表
     */
    List<SystemLog> searchLogs(@Param("keyword") String keyword);
}