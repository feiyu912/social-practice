package com.ssm.dao;

import com.ssm.entity.GroupInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 小组信息DAO接口
 */
public interface GroupInfoDAO {
    /**
     * 根据ID查询小组
     * @param groupId 小组ID
     * @return 小组对象
     */
    GroupInfo findById(@Param("groupId") Integer groupId);

    /**
     * 根据活动ID查询小组
     * @param activityId 活动ID
     * @return 小组列表
     */
    List<GroupInfo> findByActivityId(@Param("activityId") Integer activityId);

    /**
     * 根据组长ID查询小组
     * @param leaderId 组长ID
     * @return 小组对象
     */
    GroupInfo findByLeaderId(@Param("leaderId") Integer leaderId);

    /**
     * 添加小组
     * @param groupInfo 小组对象
     * @return 影响行数
     */
    int insert(GroupInfo groupInfo);

    /**
     * 更新小组信息
     * @param groupInfo 小组对象
     * @return 影响行数
     */
    int update(GroupInfo groupInfo);

    /**
     * 更新成员数量
     * @param groupId 小组ID
     * @param memberCount 成员数量
     * @return 影响行数
     */
    int updateMemberCount(@Param("groupId") Integer groupId, @Param("memberCount") Integer memberCount);

    /**
     * 更新小组状态
     * @param groupId 小组ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("groupId") Integer groupId, @Param("status") Integer status);

    /**
     * 删除小组
     * @param groupId 小组ID
     * @return 影响行数
     */
    int delete(@Param("groupId") Integer groupId);

    /**
     * 根据活动ID删除所有小组
     * @param activityId 活动ID
     * @return 影响行数
     */
    int deleteByActivityId(@Param("activityId") Integer activityId);
}