package com.ssm.dao;

import com.ssm.entity.GradeInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 成绩信息DAO接口
 */
public interface GradeInfoDAO {
    /**
     * 根据ID查询成绩
     * @param gradeId 成绩ID
     * @return 成绩对象
     */
    GradeInfo findById(@Param("gradeId") Integer gradeId);

    /**
     * 根据学生ID和活动ID查询成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 成绩对象
     */
    GradeInfo findByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 根据学生ID查询所有成绩
     * @param studentId 学生ID
     * @return 成绩列表
     */
    List<GradeInfo> findByStudentId(@Param("studentId") Integer studentId);

    /**
     * 根据活动ID查询所有成绩
     * @param activityId 活动ID
     * @return 成绩列表
     */
    List<GradeInfo> findByActivityId(@Param("activityId") Integer activityId);

    /**
     * 根据教师ID查询所有评分
     * @param teacherId 教师ID
     * @return 成绩列表
     */
    List<GradeInfo> findByTeacherId(@Param("teacherId") Integer teacherId);

    /**
     * 添加成绩
     * @param gradeInfo 成绩对象
     * @return 影响行数
     */
    int insert(GradeInfo gradeInfo);

    /**
     * 更新成绩信息
     * @param gradeInfo 成绩对象
     * @return 影响行数
     */
    int update(GradeInfo gradeInfo);

    /**
     * 删除成绩
     * @param gradeId 成绩ID
     * @return 影响行数
     */
    int delete(@Param("gradeId") Integer gradeId);

    /**
     * 根据学生ID和活动ID删除成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 影响行数
     */
    int deleteByStudentAndActivity(@Param("studentId") Integer studentId, @Param("activityId") Integer activityId);

    /**
     * 查询活动平均分
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getAverageScoreByActivity(@Param("activityId") Integer activityId);

    /**
     * 查询活动成绩统计
     * @param activityId 活动ID
     * @return 统计信息
     */
    List<Object[]> getScoreStatisticsByActivity(@Param("activityId") Integer activityId);

    /**
     * 根据学生ID、活动ID和教师ID查询成绩
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @param teacherId 教师ID
     * @return 成绩对象
     */
    GradeInfo findByStudentAndActivityAndTeacher(@Param("studentId") Integer studentId, 
                                                  @Param("activityId") Integer activityId, 
                                                  @Param("teacherId") Integer teacherId);

    /**
     * 根据学生ID和活动ID查询所有教师的评分
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 成绩列表
     */
    List<GradeInfo> findAllGradesByStudentAndActivity(@Param("studentId") Integer studentId, 
                                                        @Param("activityId") Integer activityId);

    /**
     * 计算学生某个活动的平均分
     * @param studentId 学生ID
     * @param activityId 活动ID
     * @return 平均分
     */
    Double getAverageScoreByStudentAndActivity(@Param("studentId") Integer studentId, 
                                                @Param("activityId") Integer activityId);
}