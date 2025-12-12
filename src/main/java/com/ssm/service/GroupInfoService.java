package com.ssm.service;

import com.ssm.entity.GroupInfo;
import java.util.List;

/**
 * 小组信息服务接口
 */
public interface GroupInfoService {
    /**
     * 根据ID查询小组
     * @param groupId 小组ID
     * @return 小组对象
     */
    GroupInfo findById(Integer groupId);

    /**
     * 根据活动ID查询小组列表
     * @param activityId 活动ID
     * @return 小组列表
     */
    List<GroupInfo> findByActivityId(Integer activityId);

    /**
     * 根据组长ID查询小组
     * @param leaderId 组长ID
     * @return 小组对象
     */
    GroupInfo findByLeaderId(Integer leaderId);

    /**
     * 创建小组
     * @param groupInfo 小组对象
     * @return 是否成功
     */
    boolean createGroup(GroupInfo groupInfo);

    /**
     * 更新小组信息
     * @param groupInfo 小组对象
     * @return 是否成功
     */
    boolean updateGroup(GroupInfo groupInfo);

    /**
     * 更新成员数量
     * @param groupId 小组ID
     * @return 是否成功
     */
    boolean updateMemberCount(Integer groupId);

    /**
     * 更新小组状态
     * @param groupId 小组ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateStatus(Integer groupId, Integer status);

    /**
     * 删除小组
     * @param groupId 小组ID
     * @return 是否成功
     */
    boolean deleteGroup(Integer groupId);

    /**
     * 学生加入小组
     * @param studentId 学生ID
     * @param groupId 小组ID
     * @param activityId 活动ID
     * @return 是否成功
     */
    boolean joinGroup(Integer studentId, Integer groupId, Integer activityId);

    /**
     * 学生退出小组
     * @param studentId 学生ID
     * @param groupId 小组ID
     * @return 是否成功
     */
    boolean leaveGroup(Integer studentId, Integer groupId);

    /**
     * 获取小组的成员列表
     * @param groupId 小组ID
     * @return 学生ID列表
     */
    List<Integer> getGroupMembers(Integer groupId);
}


