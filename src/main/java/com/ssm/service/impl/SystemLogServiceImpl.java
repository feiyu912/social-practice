package com.ssm.service.impl;

import com.ssm.dao.SystemLogDAO;
import com.ssm.entity.SystemLog;
import com.ssm.service.SystemLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 系统日志服务实现类
 */
@Service
@Transactional
public class SystemLogServiceImpl implements SystemLogService {

    @Autowired
    private SystemLogDAO systemLogDAO;

    @Override
    public SystemLog findById(Integer logId) {
        return systemLogDAO.findById(logId);
    }

    @Override
    public List<SystemLog> findByUserId(Integer userId) {
        return systemLogDAO.findByUserId(userId);
    }

    @Override
    public List<SystemLog> findByOperationType(String operationType) {
        return systemLogDAO.findByOperationType(operationType);
    }

    @Override
    public List<SystemLog> findAll() {
        return systemLogDAO.findAll();
    }

    @Override
    public List<SystemLog> findByTimeRange(String startTime, String endTime) {
        return systemLogDAO.findByTimeRange(startTime, endTime);
    }

    @Override
    public boolean addLog(SystemLog systemLog) {
        systemLog.setCreateTime(new Date());
        return systemLogDAO.insert(systemLog) > 0;
    }

    @Override
    public boolean updateLog(SystemLog systemLog) {
        return systemLogDAO.update(systemLog) > 0;
    }

    @Override
    public boolean deleteLog(Integer logId) {
        return systemLogDAO.delete(logId) > 0;
    }

    @Override
    public int batchDelete(List<Integer> logIds) {
        return systemLogDAO.batchDelete(logIds);
    }

    @Override
    public boolean clearLogs() {
        return systemLogDAO.clearLogs() > 0;
    }

    @Override
    public void recordLoginLog(Integer userId, String username, String ipAddress, String result) {
        SystemLog log = new SystemLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setOperation("用户登录 - " + result);
        log.setMethod("POST /user/login");
        log.setIp(ipAddress);
        log.setCreateTime(new Date());
        systemLogDAO.insert(log);
    }

    @Override
    public void recordOperationLog(Integer userId, String operationType, String description, String result) {
        SystemLog log = new SystemLog();
        log.setUserId(userId);
        log.setOperation(operationType + " - " + description + " - " + result);
        log.setCreateTime(new Date());
        systemLogDAO.insert(log);
    }

    @Override
    public void recordErrorLog(Integer userId, String operationType, String description, String errorInfo) {
        SystemLog log = new SystemLog();
        log.setUserId(userId);
        log.setOperation(operationType + " - " + description + " - 错误: " + errorInfo);
        log.setCreateTime(new Date());
        systemLogDAO.insert(log);
    }

    @Override
    public List<Object[]> getLogStatistics(String startTime, String endTime) {
        // 此方法需要额外的DAO方法支持，暂时返回空列表
        return new ArrayList<Object[]>();
    }

    @Override
    public List<Object[]> getAccessStatistics(int days) {
        // 此方法需要额外的DAO方法支持，暂时返回空列表
        return new ArrayList<Object[]>();
    }

    @Override
    public List<SystemLog> searchLogs(String keyword) {
        return systemLogDAO.searchLogs(keyword);
    }
}
