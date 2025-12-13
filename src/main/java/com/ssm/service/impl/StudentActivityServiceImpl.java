package com.ssm.service.impl;

import com.ssm.dao.PracticeActivityDAO;
import com.ssm.dao.StudentActivityDAO;
import com.ssm.entity.PracticeActivity;
import com.ssm.entity.StudentActivity;
import com.ssm.service.StudentActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 学生参与活动服务实现类
 */
@Service
@Transactional
public class StudentActivityServiceImpl implements StudentActivityService {

    @Autowired
    private StudentActivityDAO studentActivityDAO;

    @Autowired
    private PracticeActivityDAO practiceActivityDAO;

    @Override
    public StudentActivity findByStudentAndActivity(Integer studentId, Integer activityId) {
        return studentActivityDAO.findByStudentAndActivity(studentId, activityId);
    }

    @Override
    public List<StudentActivity> findByStudentId(Integer studentId) {
        return studentActivityDAO.findByStudentId(studentId);
    }
    
    @Override
    public List<StudentActivity> findByStudentIdWithActivity(Integer studentId) {
        return studentActivityDAO.findByStudentIdWithActivity(studentId);
    }

    @Override
    public List<StudentActivity> findByActivityId(Integer activityId) {
        return studentActivityDAO.findByActivityId(activityId);
    }
    
    @Override
    public List<StudentActivity> findByActivityIdWithStudent(Integer activityId) {
        return studentActivityDAO.findByActivityIdWithStudent(activityId);
    }

    @Override
    public List<StudentActivity> findByActivityIdAndStatus(Integer activityId, Integer status) {
        return studentActivityDAO.findByActivityIdAndStatus(activityId, status);
    }

    @Override
    public boolean registerActivity(Integer studentId, Integer activityId) {
        try {
            // 检查活动是否可以报名（只有招募中状态可以报名）
            PracticeActivity activity = practiceActivityDAO.findById(activityId);
            if (activity == null || !"recruiting".equals(activity.getStatus())) {
                return false; // 活动不存在或不是招募中状态
            }
            
            // 检查当前时间是否在活动时间范围内
            Date now = new Date();
            if (activity.getStartTime() != null && now.before(activity.getStartTime())) {
                return false; // 活动还未开始
            }
            if (activity.getEndTime() != null && now.after(activity.getEndTime())) {
                return false; // 活动已结束
            }

            // 检查是否已经报名
            if (isStudentRegistered(studentId, activityId)) {
                return false; // 已经报名
            }

            // 创建报名记录，状态为待审核(0)
            StudentActivity studentActivity = new StudentActivity();
            studentActivity.setStudentId(studentId);
            studentActivity.setActivityId(activityId);
            studentActivity.setStatus(0); // 待审核状态
            studentActivity.setJoinTime(new Date());
            studentActivity.setUpdateTime(new Date());

            if (studentActivityDAO.insert(studentActivity) > 0) {
                // 更新活动报名人数
                int count = studentActivityDAO.countByActivityId(activityId);
                practiceActivityDAO.updateParticipantCount(activityId, count);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelRegistration(Integer studentId, Integer activityId) {
        try {
            // 检查是否已经报名
            StudentActivity studentActivity = findByStudentAndActivity(studentId, activityId);
            if (studentActivity == null || studentActivity.getStatus() != 0) {
                return false; // 未报名或状态不允许取消（只有待审核状态可以取消）
            }

            if (studentActivityDAO.deleteByStudentAndActivity(studentId, activityId) > 0) {
                // 更新活动参与人数
                int count = studentActivityDAO.countByActivityId(activityId);
                practiceActivityDAO.updateParticipantCount(activityId, count);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(Integer studentId, Integer activityId, Integer status) {
        try {
            // 先根据studentId和activityId查询id
            StudentActivity studentActivity = findByStudentAndActivity(studentId, activityId);
            if (studentActivity != null) {
                return studentActivityDAO.updateStatus(studentActivity.getId(), status) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateStatusById(Integer id, Integer status) {
        try {
            return studentActivityDAO.updateStatus(id, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateGroupId(Integer studentId, Integer activityId, Integer groupId) {
        try {
            // 先根据studentId和activityId查询id
            StudentActivity studentActivity = findByStudentAndActivity(studentId, activityId);
            if (studentActivity != null) {
                return studentActivityDAO.updateGroupId(studentActivity.getId(), groupId) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteStudentActivity(Integer studentId, Integer activityId) {
        try {
            return studentActivityDAO.deleteByStudentAndActivity(studentId, activityId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getActivityParticipantCount(Integer activityId) {
        return studentActivityDAO.countByActivityId(activityId);
    }

    @Override
    public int getActivityParticipantCountByStatus(Integer activityId, Integer status) {
        return studentActivityDAO.countByActivityIdAndStatus(activityId, status);
    }

    @Override
    public boolean isStudentRegistered(Integer studentId, Integer activityId) {
        return findByStudentAndActivity(studentId, activityId) != null;
    }
    
    @Override
    public boolean isStudentApproved(Integer studentId, Integer activityId) {
        StudentActivity sa = findByStudentAndActivity(studentId, activityId);
        return sa != null && sa.getStatus() == 1; // status=1表示已通过
    }

    @Override
    public List<Object[]> getStudentActivityStatistics(Integer studentId) {
        return null;
    }
    
    @Override
    public int getRegisteredActivityCount(Integer studentId) {
        List<StudentActivity> activities = findByStudentId(studentId);
        return activities != null ? activities.size() : 0;
    }
}