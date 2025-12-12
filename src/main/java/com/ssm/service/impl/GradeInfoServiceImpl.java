package com.ssm.service.impl;

import com.ssm.dao.GradeInfoDAO;
import com.ssm.dao.StudentActivityDAO;
import com.ssm.entity.GradeInfo;
import com.ssm.service.GradeInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 成绩信息服务实现类
 */
@Service
@Transactional
public class GradeInfoServiceImpl implements GradeInfoService {

    @Autowired
    private GradeInfoDAO gradeInfoDAO;

    @Autowired
    private StudentActivityDAO studentActivityDAO;

    @Override
    public GradeInfo findById(Integer gradeId) {
        return gradeInfoDAO.findById(gradeId);
    }

    @Override
    public GradeInfo findByStudentAndActivity(Integer studentId, Integer activityId) {
        return gradeInfoDAO.findByStudentAndActivity(studentId, activityId);
    }

    @Override
    public List<GradeInfo> findByStudentId(Integer studentId) {
        return gradeInfoDAO.findByStudentId(studentId);
    }

    @Override
    public List<GradeInfo> findByActivityId(Integer activityId) {
        return gradeInfoDAO.findByActivityId(activityId);
    }

    @Override
    public List<GradeInfo> findByTeacherId(Integer teacherId) {
        return gradeInfoDAO.findByTeacherId(teacherId);
    }

    @Override
    public boolean addGrade(GradeInfo gradeInfo) {
        try {
            gradeInfo.setGradeTime(new Date());
            gradeInfo.setUpdateTime(new Date());
            return gradeInfoDAO.insert(gradeInfo) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateGrade(GradeInfo gradeInfo) {
        try {
            gradeInfo.setUpdateTime(new Date());
            return gradeInfoDAO.update(gradeInfo) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteGrade(Integer gradeId) {
        try {
            return gradeInfoDAO.delete(gradeId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteByStudentAndActivity(Integer studentId, Integer activityId) {
        try {
            return gradeInfoDAO.deleteByStudentAndActivity(studentId, activityId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Double getAverageScoreByActivity(Integer activityId) {
        return gradeInfoDAO.getAverageScoreByActivity(activityId);
    }

    @Override
    public List<Object[]> getScoreStatisticsByActivity(Integer activityId) {
        return gradeInfoDAO.getScoreStatisticsByActivity(activityId);
    }

    @Override
    public boolean hasGrade(Integer studentId, Integer activityId) {
        return gradeInfoDAO.findByStudentAndActivity(studentId, activityId) != null;
    }

    @Override
    public int batchGrade(List<GradeInfo> gradeInfos) {
        try {
            int count = 0;
            for (GradeInfo gradeInfo : gradeInfos) {
                // 检查该教师是否已评分，支持多人评分
                if (!hasGradeByTeacher(gradeInfo.getStudentId(), gradeInfo.getActivityId(), gradeInfo.getTeacherId())) {
                    gradeInfo.setGradeTime(new Date());
                    gradeInfo.setUpdateTime(new Date());
                    if (gradeInfoDAO.insert(gradeInfo) > 0) {
                        count++;
                    }
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public GradeInfo findByStudentAndActivityAndTeacher(Integer studentId, Integer activityId, Integer teacherId) {
        return gradeInfoDAO.findByStudentAndActivityAndTeacher(studentId, activityId, teacherId);
    }

    @Override
    public List<GradeInfo> findAllGradesByStudentAndActivity(Integer studentId, Integer activityId) {
        return gradeInfoDAO.findAllGradesByStudentAndActivity(studentId, activityId);
    }

    @Override
    public Double getAverageScoreByStudentAndActivity(Integer studentId, Integer activityId) {
        return gradeInfoDAO.getAverageScoreByStudentAndActivity(studentId, activityId);
    }

    @Override
    public boolean hasGradeByTeacher(Integer studentId, Integer activityId, Integer teacherId) {
        return gradeInfoDAO.findByStudentAndActivityAndTeacher(studentId, activityId, teacherId) != null;
    }

    @Override
    public int gradeGroup(Integer groupId, Integer activityId, Integer teacherId, Double score, String comment) {
        try {
            // 获取小组所有成员
            List<Integer> members = studentActivityDAO.findByGroupId(groupId);
            if (members == null || members.isEmpty()) {
                return 0;
            }

            int count = 0;
            Date now = new Date();
            for (Integer studentId : members) {
                // 检查该教师是否已对该学生评分
                if (!hasGradeByTeacher(studentId, activityId, teacherId)) {
                    GradeInfo gradeInfo = new GradeInfo();
                    gradeInfo.setStudentId(studentId);
                    gradeInfo.setActivityId(activityId);
                    gradeInfo.setTeacherId(teacherId);
                    gradeInfo.setScore(score);
                    gradeInfo.setComment(comment);
                    gradeInfo.setGradeTime(now);
                    gradeInfo.setUpdateTime(now);

                    if (gradeInfoDAO.insert(gradeInfo) > 0) {
                        count++;
                    }
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public Double getGroupAverageScore(Integer groupId, Integer activityId) {
        try {
            // 获取小组所有成员
            List<Integer> members = studentActivityDAO.findByGroupId(groupId);
            if (members == null || members.isEmpty()) {
                return null;
            }

            // 计算所有成员的平均分
            double totalScore = 0;
            int count = 0;
            for (Integer studentId : members) {
                Double avgScore = getAverageScoreByStudentAndActivity(studentId, activityId);
                if (avgScore != null) {
                    totalScore += avgScore;
                    count++;
                }
            }

            return count > 0 ? totalScore / count : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}