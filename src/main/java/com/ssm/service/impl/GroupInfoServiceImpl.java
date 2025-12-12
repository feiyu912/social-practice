package com.ssm.service.impl;

import com.ssm.dao.GroupInfoDAO;
import com.ssm.dao.StudentActivityDAO;
import com.ssm.entity.GroupInfo;
import com.ssm.entity.StudentActivity;
import com.ssm.service.GroupInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * 小组信息服务实现类
 */
@Service
public class GroupInfoServiceImpl implements GroupInfoService {

    @Autowired
    private GroupInfoDAO groupInfoDAO;

    @Autowired
    private StudentActivityDAO studentActivityDAO;

    @Override
    public GroupInfo findById(Integer groupId) {
        try {
            return groupInfoDAO.findById(groupId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<GroupInfo> findByActivityId(Integer activityId) {
        try {
            return groupInfoDAO.findByActivityId(activityId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public GroupInfo findByLeaderId(Integer leaderId) {
        try {
            return groupInfoDAO.findByLeaderId(leaderId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean createGroup(GroupInfo groupInfo) {
        try {
            // 设置创建时间和更新时间
            groupInfo.setCreateTime(new Date());
            groupInfo.setUpdateTime(new Date());
            
            // 默认成员数量为1（组长）
            if (groupInfo.getMemberCount() == null) {
                groupInfo.setMemberCount(1);
            }
            
            // 默认状态为进行中
            if (groupInfo.getStatus() == null) {
                groupInfo.setStatus(1);
            }
            
            return groupInfoDAO.insert(groupInfo) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateGroup(GroupInfo groupInfo) {
        try {
            groupInfo.setUpdateTime(new Date());
            return groupInfoDAO.update(groupInfo) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateMemberCount(Integer groupId) {
        try {
            // 查询小组当前成员数量
            List<Integer> members = studentActivityDAO.findByGroupId(groupId);
            int memberCount = members != null ? members.size() : 0;
            
            // 更新小组成员数量
            return groupInfoDAO.updateMemberCount(groupId, memberCount) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(Integer groupId, Integer status) {
        try {
            return groupInfoDAO.updateStatus(groupId, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteGroup(Integer groupId) {
        try {
            // 先删除小组中的所有成员关联（将他们的groupId设为null）
            List<Integer> members = studentActivityDAO.findByGroupId(groupId);
            if (members != null) {
                for (Integer memberId : members) {
                    // 这里需要更复杂的逻辑来更新每个成员的groupId为null
                    // 暂时简化处理
                }
            }
            
            // 删除小组
            return groupInfoDAO.delete(groupId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean joinGroup(Integer studentId, Integer groupId, Integer activityId) {
        try {
            // 检查小组是否存在
            GroupInfo group = groupInfoDAO.findById(groupId);
            if (group == null) {
                return false; // 小组不存在
            }
            
            // 检查学生是否已报名该活动
            StudentActivity studentActivity = studentActivityDAO.findByStudentAndActivity(studentId, activityId);
            if (studentActivity == null) {
                return false; // 未报名活动
            }

            // 检查学生是否已在其他小组
            if (studentActivity.getGroupId() != null && !studentActivity.getGroupId().equals(groupId)) {
                return false; // 已在其他小组
            }
            
            // 如果学生已经在该小组中，则不需要重复加入
            if (groupId.equals(studentActivity.getGroupId())) {
                return true;
            }

            // 加入小组
            if (studentActivityDAO.updateGroupId(studentActivity.getId(), groupId) > 0) {
                // 更新小组成员数量
                updateMemberCount(groupId);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean leaveGroup(Integer studentId, Integer groupId) {
        try {
            // 查找学生的活动记录
            List<StudentActivity> activities = studentActivityDAO.findByStudentId(studentId);
            StudentActivity studentActivity = activities.stream()
                .filter(sa -> groupId.equals(sa.getGroupId()))
                .findFirst()
                .orElse(null);

            if (studentActivity == null) {
                return false;
            }

            // 检查是否是组长
            GroupInfo group = groupInfoDAO.findById(groupId);
            if (group != null && group.getLeaderId().equals(studentId)) {
                return false; // 组长不能退出，需要先转让组长或解散小组
            }

            // 退出小组
            if (studentActivityDAO.updateGroupId(studentActivity.getId(), null) > 0) {
                // 更新小组成员数量
                updateMemberCount(groupId);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Integer> getGroupMembers(Integer groupId) {
        try {
            // 通过StudentActivity查询该小组的所有成员
            return studentActivityDAO.findByGroupId(groupId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}