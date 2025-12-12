package com.ssm.controller;

import com.ssm.entity.SystemLog;
import com.ssm.service.SystemLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 系统日志控制器
 */
@Controller
@RequestMapping("systemLog")
public class SystemLogController {

    @Autowired
    private SystemLogService systemLogService;

    /**
     * 跳转到日志列表页面
     */
    @RequestMapping("list")
    public String logList(Model model) {
        List<SystemLog> logs = systemLogService.findAll();
        model.addAttribute("logs", logs);
        return "system/logList";
    }
    
    /**
     * 跳转到添加日志页面
     */
    @RequestMapping("add")
    public String add() {
        return "system/addLog";
    }
    
    /**
     * 跳转到编辑日志页面
     */
    @RequestMapping("edit")
    public String edit(Model model, Integer id) {
        if (id != null) {
            SystemLog log = systemLogService.findById(id);
            model.addAttribute("log", log);
        }
        return "system/editLog";
    }
    
    /**
     * 查看日志详情
     */
    @RequestMapping("view")
    public String view(Model model, Integer id) {
        if (id != null) {
            SystemLog log = systemLogService.findById(id);
            model.addAttribute("log", log);
        }
        return "system/viewLog";
    }
    
    /**
     * 删除日志
     */
    @RequestMapping("delete")
    public String delete(Integer id) {
        if (id != null) {
            systemLogService.deleteLog(id);
        }
        return "redirect:list";
    }
}