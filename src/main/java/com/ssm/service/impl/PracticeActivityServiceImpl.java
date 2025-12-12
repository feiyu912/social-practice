package com.ssm.service.impl;

import com.ssm.dao.PracticeActivityDAO;
import com.ssm.entity.PracticeActivity;
import com.ssm.service.PracticeActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 实践活动服务实现类
 */
@Service
@Transactional
public class PracticeActivityServiceImpl implements PracticeActivityService {

    @Autowired
    private PracticeActivityDAO practiceActivityDAO;

    @Override
    public PracticeActivity findById(Integer activityId) {
        return practiceActivityDAO.findById(activityId);
    }

    @Override
    public List<PracticeActivity> findAll() {
        // 调用DAO层方法时传入分页参数，这里使用0作为起始位置，Integer.MAX_VALUE作为限制数量获取所有数据
        return practiceActivityDAO.findAll(0, Integer.MAX_VALUE);
    }

    @Override
    public List<PracticeActivity> findByTeacherId(Integer teacherId) {
        // 调用DAO层方法时传入教师ID和分页参数
        return practiceActivityDAO.findByTeacherId(teacherId, 0, Integer.MAX_VALUE);
    }

    @Override
    public List<PracticeActivity> findByStatus(String status) {
        return practiceActivityDAO.findByStatus(status, 0, Integer.MAX_VALUE);
    }

    @Override
    public List<PracticeActivity> findActiveActivities() {
        return practiceActivityDAO.findByStatus("ongoing", 0, Integer.MAX_VALUE);
    }

    @Override
    public List<PracticeActivity> findCompletedActivities() {
        return practiceActivityDAO.findByStatus("finished", 0, Integer.MAX_VALUE);
    }

    @Override
    public boolean addActivity(PracticeActivity activity) {
        try {
            activity.setStatus("recruiting");
            activity.setCurrentParticipants(0); // 使用正确的setter方法
            activity.setCreateTime(new Date());
            activity.setUpdateTime(new Date());
            return practiceActivityDAO.insert(activity) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateActivity(PracticeActivity activity) {
        try {
            activity.setUpdateTime(new Date());
            return practiceActivityDAO.update(activity) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateActivityStatus(Integer activityId, String status) {
        try {
            return practiceActivityDAO.updateStatus(activityId, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateParticipantCount(Integer activityId, Integer participantCount) {
        try {
            return practiceActivityDAO.updateParticipantCount(activityId, participantCount) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteActivity(Integer activityId) {
        try {
            return practiceActivityDAO.delete(activityId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getActivityCount() {
        return practiceActivityDAO.count();
    }

    @Override
    public int getActivityCountByStatus(String status) {
        return practiceActivityDAO.countByStatus(status);
    }

    @Override
    public boolean startActivity(Integer activityId) {
        PracticeActivity activity = practiceActivityDAO.findById(activityId);
        if (activity != null && "recruiting".equals(activity.getStatus())) {
            return updateActivityStatus(activityId, "ongoing");
        }
        return false;
    }

    @Override
    public boolean endActivity(Integer activityId) {
        PracticeActivity activity = practiceActivityDAO.findById(activityId);
        if (activity != null && "ongoing".equals(activity.getStatus())) {
            return updateActivityStatus(activityId, "finished");
        }
        return false;
    }

    @Override
    public boolean canRegister(Integer activityId) {
        PracticeActivity activity = practiceActivityDAO.findById(activityId);
        return activity != null && ("recruiting".equals(activity.getStatus()) || "ongoing".equals(activity.getStatus()));
    }

    @Override
    public boolean canSubmitReport(Integer activityId) {
        PracticeActivity activity = practiceActivityDAO.findById(activityId);
        return activity != null && ("ongoing".equals(activity.getStatus()) || "finished".equals(activity.getStatus()));
    }

    @Override
    public List<PracticeActivity> searchByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return practiceActivityDAO.searchByKeyword(keyword.trim(), 0, Integer.MAX_VALUE);
    }
}
