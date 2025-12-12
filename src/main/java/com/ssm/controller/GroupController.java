package com.ssm.controller;

import com.ssm.entity.*;
import com.ssm.service.GroupInfoService;
import com.ssm.service.PracticeActivityService;
import com.ssm.service.StudentActivityService;
import com.ssm.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 小组管理控制器
 */
@Controller
@RequestMapping("group")
public class GroupController {

    @Autowired
    private GroupInfoService groupInfoService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private StudentActivityService studentActivityService;

    @Autowired
    private PracticeActivityService practiceActivityService;

    /**
     * 小组管理页面
     */
    @RequestMapping("manage")
    public String manage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null || !"student".equals(user.getRole())) {
            return "redirect:/login";
        }

        // 获取学生ID
        Student student = studentService.findByUserId(user.getUserId());
        if (student == null) {
            model.addAttribute("error", "学生信息不存在");
            return "group/manage";
        }

        // 获取学生已通过审核的活动列表（只有审核通过的才能创建/加入小组）
        List<StudentActivity> studentActivities = studentActivityService.findByStudentIdWithActivity(student.getId());
        List<PracticeActivity> approvedActivities = new java.util.ArrayList<>();
        List<GroupInfo> myGroups = new java.util.ArrayList<>();
        
        if (studentActivities != null) {
            for (StudentActivity sa : studentActivities) {
                // 只筛选审核通过(status=1)且活动状态为招募中或进行中的
                if (sa.getStatus() != null && sa.getStatus() == 1 && sa.getActivity() != null) {
                    String actStatus = sa.getActivity().getStatus();
                    if ("recruiting".equals(actStatus) || "ongoing".equals(actStatus)) {
                        approvedActivities.add(sa.getActivity());
                    }
                }
                
                // 如果学生已加入小组，查询小组信息
                if (sa.getGroupId() != null) {
                    GroupInfo group = groupInfoService.findById(sa.getGroupId());
                    if (group != null) {
                        // 设置关联的活动信息
                        group.setActivity(sa.getActivity());
                        myGroups.add(group);
                    }
                }
            }
        }

        model.addAttribute("student", student);
        model.addAttribute("activities", approvedActivities);
        model.addAttribute("myGroups", myGroups);
        return "group/manage";
    }

    /**
     * 创建小组（只有审核通过的学生才能创建）
     */
    @RequestMapping("create")
    @ResponseBody
    public Map<String, Object> create(@RequestParam("activityId") Integer activityId,
                                      @RequestParam("groupName") String groupName,
                                      HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");

        try {
            if (user == null || !"student".equals(user.getRole())) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 获取学生ID
            Student student = studentService.findByUserId(user.getUserId());
            if (student == null) {
                result.put("success", false);
                result.put("message", "学生信息不存在");
                return result;
            }

            // 检查学生是否已报名该活动且审核通过
            if (!studentActivityService.isStudentApproved(student.getId(), activityId)) {
                result.put("success", false);
                result.put("message", "只有报名审核通过后才能创建小组");
                return result;
            }

            // 检查活动状态是否允许创建小组
            PracticeActivity activity = practiceActivityService.findById(activityId);
            if (activity == null || 
                (!"recruiting".equals(activity.getStatus()) && !"ongoing".equals(activity.getStatus()))) {
                result.put("success", false);
                result.put("message", "该活动当前状态不允许创建小组");
                return result;
            }

            GroupInfo groupInfo = new GroupInfo();
            groupInfo.setActivityId(activityId);
            groupInfo.setGroupName(groupName);
            groupInfo.setLeaderId(student.getId());
            groupInfo.setMemberCount(1); // 组长作为第一个成员
            groupInfo.setStatus(1); // 设置为进行中状态

            boolean success = groupInfoService.createGroup(groupInfo);
            result.put("success", success);
            result.put("message", success ? "创建成功" : "创建失败，小组名称可能已存在");
            if (success) {
                result.put("groupId", groupInfo.getGroupId());
                
                // 更新学生在活动中的小组ID
                studentActivityService.updateGroupId(student.getId(), activityId, groupInfo.getGroupId());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "创建失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 加入小组（只有审核通过的学生才能加入）
     */
    @RequestMapping("join")
    @ResponseBody
    public Map<String, Object> join(@RequestParam("groupId") Integer groupId,
                                    @RequestParam("activityId") Integer activityId,
                                    HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");

        try {
            if (user == null || !"student".equals(user.getRole())) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 获取学生ID
            Student student = studentService.findByUserId(user.getUserId());
            if (student == null) {
                result.put("success", false);
                result.put("message", "学生信息不存在");
                return result;
            }

            // 检查学生是否已报名该活动且审核通过
            if (!studentActivityService.isStudentApproved(student.getId(), activityId)) {
                result.put("success", false);
                result.put("message", "只有报名审核通过后才能加入小组");
                return result;
            }

            // 检查活动状态是否允许加入小组
            PracticeActivity activity = practiceActivityService.findById(activityId);
            if (activity == null || 
                (!"recruiting".equals(activity.getStatus()) && !"ongoing".equals(activity.getStatus()))) {
                result.put("success", false);
                result.put("message", "该活动当前状态不允许加入小组");
                return result;
            }

            boolean success = groupInfoService.joinGroup(student.getId(), groupId, activityId);
            result.put("success", success);
            result.put("message", success ? "加入成功" : "加入失败，可能已在其他小组或小组不存在");
            
            if (success) {
                // 更新学生在活动中的小组ID
                studentActivityService.updateGroupId(student.getId(), activityId, groupId);
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "加入失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 退出小组
     */
    @RequestMapping("leave")
    @ResponseBody
    public Map<String, Object> leave(@RequestParam("groupId") Integer groupId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");

        try {
            if (user == null || !"student".equals(user.getRole())) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 获取学生ID
            Student student = studentService.findByUserId(user.getUserId());
            if (student == null) {
                result.put("success", false);
                result.put("message", "学生信息不存在");
                return result;
            }

            boolean success = groupInfoService.leaveGroup(student.getId(), groupId);
            result.put("success", success);
            result.put("message", success ? "退出成功" : "退出失败，组长不能退出小组");
            
            if (success) {
                // 清除学生在活动中的小组ID
                // 这里需要根据groupId找到对应的activityId，然后清除学生的小组ID
                // 暂时留空，需要进一步实现
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "退出失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 查询活动的小组列表
     */
    @RequestMapping("list")
    public String list(@RequestParam("activityId") Integer activityId, Model model) {
        List<GroupInfo> groups = groupInfoService.findByActivityId(activityId);
        model.addAttribute("groups", groups);
        model.addAttribute("activityId", activityId);
        return "group/list";
    }
    
    /**
     * 查询活动的小组列表（JSON格式，供Ajax调用）
     */
    @RequestMapping("listJson")
    @ResponseBody
    public Map<String, Object> listJson(@RequestParam("activityId") Integer activityId) {
        Map<String, Object> result = new HashMap<>();
        List<GroupInfo> groups = groupInfoService.findByActivityId(activityId);
        result.put("groups", groups);
        return result;
    }

    /**
     * 查看小组详情
     */
    @RequestMapping("view")
    public String view(@RequestParam("groupId") Integer groupId, Model model) {
        GroupInfo group = groupInfoService.findById(groupId);
        if (group != null) {
            List<Integer> members = groupInfoService.getGroupMembers(groupId);
            model.addAttribute("group", group);
            model.addAttribute("members", members);
        }
        return "group/view";
    }

    /**
     * 删除小组（仅组长或管理员）
     */
    @RequestMapping("delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam("groupId") Integer groupId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");

        try {
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            GroupInfo group = groupInfoService.findById(groupId);
            if (group == null) {
                result.put("success", false);
                result.put("message", "小组不存在");
                return result;
            }

            // 检查权限：只有组长或管理员可以删除
            boolean hasPermission = false;
            if ("admin".equals(user.getRole())) {
                hasPermission = true;
            } else if ("student".equals(user.getRole())) {
                Student student = studentService.findByUserId(user.getUserId());
                if (student != null && student.getId().equals(group.getLeaderId())) {
                    hasPermission = true;
                }
            }

            if (!hasPermission) {
                result.put("success", false);
                result.put("message", "没有权限删除该小组");
                return result;
            }

            boolean success = groupInfoService.deleteGroup(groupId);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除失败：" + e.getMessage());
        }
        return result;
    }
}