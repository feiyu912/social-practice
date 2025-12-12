package com.ssm.service.impl;

import com.ssm.dao.PracticeActivityDAO;
import com.ssm.dao.PracticeReportDAO;
import com.ssm.dao.StudentActivityDAO;
import com.ssm.entity.PracticeActivity;
import com.ssm.entity.PracticeReport;
import com.ssm.entity.StudentActivity;
import com.ssm.service.PracticeReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 实践报告服务实现类
 */
@Service
@Transactional
public class PracticeReportServiceImpl implements PracticeReportService {

    @Autowired
    private PracticeReportDAO practiceReportDAO;

    @Autowired
    private PracticeActivityDAO practiceActivityDAO;

    @Autowired
    private StudentActivityDAO studentActivityDAO;

    @Override
    public PracticeReport findById(Integer reportId) {
        return practiceReportDAO.findById(reportId);
    }

    @Override
    public PracticeReport findByStudentAndActivity(Integer studentId, Integer activityId) {
        return practiceReportDAO.findByStudentAndActivity(studentId, activityId);
    }

    @Override
    public List<PracticeReport> findByStudentId(Integer studentId) {
        return practiceReportDAO.findByStudentId(studentId);
    }

    @Override
    public List<PracticeReport> findByActivityId(Integer activityId) {
        return practiceReportDAO.findByActivityId(activityId);
    }

    @Override
    public List<PracticeReport> findByStatus(String status) {
        return practiceReportDAO.findByStatus(status);
    }

    @Override
    public List<PracticeReport> findByActivityIdAndStatus(Integer activityId, String status) {
        return practiceReportDAO.findByActivityIdAndStatus(activityId, status);
    }

    @Override
    public boolean submitReport(PracticeReport report) {
        try {
            // 检查学生是否参与了该活动
            StudentActivity studentActivity = studentActivityDAO.findByStudentAndActivity(report.getStudentId(), report.getActivityId());
            if (studentActivity == null) {
                return false; // 学生未参与该活动
            }

            // 检查活动是否可以提交报告
            PracticeActivity activity = practiceActivityDAO.findById(report.getActivityId());
            if (activity == null || (!"ongoing".equals(activity.getStatus()) && !"finished".equals(activity.getStatus()))) {
                return false; // 活动不存在或状态不允许提交报告
            }

            // 检查是否已经提交过报告
            PracticeReport existingReport = practiceReportDAO.findByStudentAndActivity(report.getStudentId(), report.getActivityId());
            if (existingReport != null) {
                return false; // 已经提交过报告
            }

            // 设置报告初始状态
            report.setStatus("pending");
            report.setSubmitTime(new Date());
            report.setUpdateTime(new Date());

            return practiceReportDAO.insert(report) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateReport(PracticeReport report) {
        try {
            // 只能更新待审核状态的报告
            PracticeReport existingReport = practiceReportDAO.findById(report.getReportId());
            if (existingReport == null || (existingReport.getStatus() == null || !existingReport.getStatus().equals("pending"))) {
                return false; // 报告不存在或状态不允许更新
            }

            report.setUpdateTime(new Date());
            return practiceReportDAO.update(report) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateReportStatus(Integer reportId, String status) {
        try {
            return practiceReportDAO.updateStatus(reportId, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean gradeReport(Integer reportId, Integer score, String comment, Integer teacherId) {
        try {
            PracticeReport report = practiceReportDAO.findById(reportId);
            if (report == null) {
                return false; // 报告不存在
            }

            // 直接使用update方法更新状态
            report.setStatus("reviewed");
            report.setUpdateTime(new Date());

            // 评分和评语可能需要通过其他方式存储
            return practiceReportDAO.update(report) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteReport(Integer reportId) {
        try {
            return practiceReportDAO.delete(reportId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteByStudentAndActivity(Integer studentId, Integer activityId) {
        try {
            return practiceReportDAO.deleteByStudentAndActivity(studentId, activityId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Object[]> getReportStatisticsByActivity(Integer activityId) {
        return practiceReportDAO.getReportStatisticsByActivity(activityId);
    }

    @Override
    public int getReportCountByActivityAndStatus(Integer activityId, String status) {
        return practiceReportDAO.countByActivityIdAndStatus(activityId, status);
    }

    @Override
    public boolean isReportSubmitted(Integer studentId, Integer activityId) {
        return practiceReportDAO.findByStudentAndActivity(studentId, activityId) != null;
    }

    @Override
    public Double getAverageScoreByActivity(Integer activityId) {
        try {
            // 由于DAO中没有getAverageScoreByActivity方法，暂时返回null
            // 如果需要此功能，应该在DAO中添加相应方法
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public int getSubmittedReportCount(Integer studentId) {
        // 获取学生已提交的报告数量
        List<PracticeReport> reports = findByStudentId(studentId);
        return reports != null ? reports.size() : 0;
    }
}
