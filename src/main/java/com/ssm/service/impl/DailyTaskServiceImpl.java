package com.ssm.service.impl;

import com.ssm.dao.DailyTaskDAO;
import com.ssm.entity.DailyTask;
import com.ssm.service.DailyTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 日常任务服务实现类
 */
@Service
@Transactional
public class DailyTaskServiceImpl implements DailyTaskService {

    @Autowired
    private DailyTaskDAO dailyTaskDAO;

    @Override
    public DailyTask findById(Integer taskId) {
        return dailyTaskDAO.findById(taskId);
    }

    @Override
    public List<DailyTask> findByStudentId(Integer studentId) {
        return dailyTaskDAO.findByStudentId(studentId);
    }

    @Override
    public List<DailyTask> findByStudentIdAndStatus(Integer studentId, Integer status) {
        return dailyTaskDAO.findByStudentIdAndStatus(studentId, status);
    }

    @Override
    public List<DailyTask> findByDateRange(Integer studentId, Date startDate, Date endDate) {
        return dailyTaskDAO.findByDateRange(studentId, startDate, endDate);
    }

    @Override
    public List<DailyTask> findTodayTasks(Integer studentId, Date date) {
        return dailyTaskDAO.findTodayTasks(studentId, date);
    }

    @Override
    public List<DailyTask> findPendingTasks(Integer studentId) {
        return dailyTaskDAO.findPendingTasks(studentId);
    }

    @Override
    public boolean addTask(DailyTask dailyTask) {
        try {
            dailyTask.setStatus(0); // 未提交
            dailyTask.setCreateTime(new Date());
            dailyTask.setUpdateTime(new Date());
            if (dailyTask.getPriority() == null) {
                dailyTask.setPriority(0); // 默认优先级
            }
            return dailyTaskDAO.insert(dailyTask) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateTask(DailyTask dailyTask) {
        try {
            dailyTask.setUpdateTime(new Date());
            return dailyTaskDAO.update(dailyTask) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(Integer taskId, Integer status) {
        try {
            return dailyTaskDAO.updateStatus(taskId, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean completeTask(Integer taskId) {
        try {
            Date now = new Date();
            dailyTaskDAO.updateStatus(taskId, 1); // 已提交
            dailyTaskDAO.updateCompletedTime(taskId, now);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteTask(Integer taskId) {
        try {
            return dailyTaskDAO.delete(taskId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int batchDeleteTasks(List<Integer> taskIds) {
        try {
            return dailyTaskDAO.batchDelete(taskIds);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<Object[]> getTaskStatistics(Integer studentId) {
        return dailyTaskDAO.getTaskStatistics(studentId);
    }
    
    @Override
    public int getPendingTaskCount(Integer studentId) {
        // 获取学生待完成的任务数量（状态为0的任务）
        List<DailyTask> pendingTasks = findByStudentIdAndStatus(studentId, 0);
        return pendingTasks != null ? pendingTasks.size() : 0;
    }
}


