package com.ssm.service;

import com.ssm.entity.GradeInfo;
import java.util.List;

/**
 * 成绩信息服务接口
 */
public interface GradeInfoService {
    /**
     * 根据ID查询成绩
     * @param gradeId 成绩ID
     * @return 成绩对象
     */
    GradeInfo findById(Integer gradeId);

    /**
     * 根据学生ID和活动ID查询成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 成绩对象
     */
    GradeInfo findByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 根据学生ID查询所有成绩
     * @param studentId 学生ID
     * @return 成绩列表
     */
    List<GradeInfo> findByStudentId(Integer studentId);

    /**
     * 根据活动ID查询所有成绩
     * @param activityId 活动ID
     * @return 成绩列表
     */
    List<GradeInfo> findByActivityId(Integer activityId);

    /**
     * 根据教师ID查询所有评分
     * @param teacherId 教师ID
     * @return 成绩列表
     */
    List<GradeInfo> findByTeacherId(Integer teacherId);

    /**
     * 添加成绩
     * @param gradeInfo 成绩对象
     * @return 是否成功
     */
    boolean addGrade(GradeInfo gradeInfo);

    /**
     * 更新成绩信息
     * @param gradeInfo 成绩对象
     * @return 是否成功
     */
    boolean updateGrade(GradeInfo gradeInfo);

    /**
     * 删除成绩
     * @param gradeId 成绩ID
     * @return 是否成功
     */
    boolean deleteGrade(Integer gradeId);

    /**
     * 根据学生ID和活动ID删除成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean deleteByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 查询活动平均分
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getAverageScoreByActivity(Integer activityId);

    /**
     * 查询活动成绩统计
     * @param activityId 活动ID
     * @return 统计信息
     */
    List<Object[]> getScoreStatisticsByActivity(Integer activityId);

    /**
     * 检查学生是否已有成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 是否已有成绩
     */
    boolean hasGrade(Integer studentId, Integer activityId);

    /**
     * 批量评分
     * @param gradeInfos 成绩列表
     * @return 评分成功的数量
     */
    int batchGrade(List<GradeInfo> gradeInfos);

    /**
     * 根据学生ID、活动ID和教师ID查询成绩（支持多人评分）
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @return 成绩对象
     */
    GradeInfo findByStudentAndActivityAndTeacher(Integer studentId, Integer activityId, Integer teacherId);

    /**
     * 根据学生ID和活动ID查询所有教师的评分（多人评分）
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 成绩列表
     */
    List<GradeInfo> findAllGradesByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 计算学生某个活动的平均分（多人评分的平均分）
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getAverageScoreByStudentAndActivity(Integer studentId, Integer activityId);

    /**
     * 检查教师是否已对该学生评分
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @return 是否已评分
     */
    boolean hasGradeByTeacher(Integer studentId, Integer activityId, Integer teacherId);

    /**
     * 按小组评分（给小组所有成员相同的分数）
     * @param groupId 小组ID
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @param score 分数
     * @param comment 评语
     * @return 评分成功的数量
     */
    int gradeGroup(Integer groupId, Integer activityId, Integer teacherId, Double score, String comment);

    /**
     * 获取小组的平均分（所有成员的平均分）
     * @param groupId 小组ID
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getGroupAverageScore(Integer groupId, Integer activityId);
}