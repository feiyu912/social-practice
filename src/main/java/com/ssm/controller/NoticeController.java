package com.ssm.controller;

import com.ssm.entity.Notice;
import com.ssm.entity.User;
import com.ssm.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @RequestMapping("list")
    public String list(@RequestParam(value = "searchKey", required = false) String searchKey,
                       Model model) {
        if (searchKey != null && !searchKey.trim().isEmpty()) {
            model.addAttribute("notices", noticeService.findByTitleOrContent(searchKey.trim()));
        } else {
            model.addAttribute("notices", noticeService.findAll());
        }
        model.addAttribute("searchKey", searchKey);
        return "notice/list";
    }

    @RequestMapping(value = "add", method = RequestMethod.GET)
    public String add() {
        return "notice/add";
    }

    /**
     * 处理添加公告的POST请求
     */
    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String doAdd(@RequestParam("title") String title,
                        @RequestParam("content") String content,
                        @RequestParam(value = "author", required = false) String author,
                        @RequestParam(value = "status", required = false, defaultValue = "1") String statusCode,
                        HttpSession session,
                        Model model) {
        User user = (User) session.getAttribute("user");
        
        Notice notice = new Notice();
        notice.setTitle(title);
        notice.setContent(content);
        notice.setPublisherId(user != null ? user.getUserId() : null);
        notice.setPublishTime(new Date());
        
        // 转换状态码
        String status = "1".equals(statusCode) ? "published" : "draft";
        notice.setStatus(status);

        boolean success = noticeService.addNotice(notice);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "添加公告失败，请重试");
            model.addAttribute("notice", notice);
            return "notice/add";
        }
    }

    @RequestMapping(value = "edit", method = RequestMethod.GET)
    public String edit(Model model, Integer id) {
        model.addAttribute("notice", noticeService.findById(id));
        return "notice/edit";
    }

    /**
     * 处理编辑公告的POST请求
     */
    @RequestMapping(value = "edit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                         @RequestParam("title") String title,
                         @RequestParam("content") String content,
                         @RequestParam(value = "status", required = false, defaultValue = "1") String statusCode,
                         Model model) {
        Notice notice = noticeService.findById(id);
        if (notice == null) {
            return "redirect:list";
        }

        notice.setTitle(title);
        notice.setContent(content);
        
        // 转换状态码
        String status = "1".equals(statusCode) ? "published" : "draft";
        notice.setStatus(status);

        boolean success = noticeService.updateNotice(notice);
        if (success) {
            return "redirect:list";
        } else {
            model.addAttribute("errorMsg", "更新公告失败，请重试");
            model.addAttribute("notice", notice);
            return "notice/edit";
        }
    }

    @RequestMapping("view")
    public String view(Model model, Integer id) {
        model.addAttribute("notice", noticeService.findById(id));
        return "notice/view";
    }

    @RequestMapping("delete")
    public String delete(Integer id) {
        noticeService.delete(id);
        return "redirect:list";
    }
}
