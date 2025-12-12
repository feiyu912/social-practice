package com.ssm.service.impl;

import com.ssm.dao.NoticeDAO;
import com.ssm.entity.Notice;
import com.ssm.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 公告服务实现类
 */
@Service
@Transactional
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeDAO noticeDAO;

    @Override
    public Notice findById(Integer noticeId) {
        return noticeDAO.findById(noticeId);
    }

    @Override
    public List<Notice> findAll() {
        return noticeDAO.findAll();
    }

    @Override
    public List<Notice> findValidNotices() {
        return noticeDAO.findValidNotices();
    }

    @Override
    public List<Notice> findByPublisherId(Integer publisherId) {
        return noticeDAO.findByPublisherId(publisherId);
    }

    @Override
    public List<Notice> findByTitleLike(String title) {
        return noticeDAO.findByTitleLike(title);
    }
    
    @Override
    public List<Notice> findByTitleOrContent(String keyword) {
        return noticeDAO.findByTitleOrContent(keyword);
    }
    
    @Override
    public boolean insert(Notice notice) {
        try {
            return noticeDAO.insert(notice) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean update(Notice notice) {
        try {
            return noticeDAO.update(notice) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void delete(Integer id) {
        noticeDAO.delete(id);
    }

    @Override
    public boolean addNotice(Notice notice) {
        try {
            if (notice.getPublishTime() == null) {
                notice.setPublishTime(new Date());
            }
            return noticeDAO.insert(notice) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateNotice(Notice notice) {
        try {
            return noticeDAO.update(notice) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteNotice(Integer noticeId) {
        try {
            return noticeDAO.delete(noticeId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean publishNotice(Integer noticeId) {
        try {
            return noticeDAO.updateStatus(noticeId, "published") > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean revokeNotice(Integer noticeId) {
        try {
            return noticeDAO.updateStatus(noticeId, "draft") > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Notice> getLatestNotices(int count) {
        List<Notice> all = noticeDAO.findValidNotices();
        if (all != null && all.size() > count) {
            return all.subList(0, count);
        }
        return all != null ? all : new ArrayList<>();
    }

    @Override
    public int getTotalCount() {
        return noticeDAO.count();
    }

    @Override
    public int getValidNoticeCount() {
        return noticeDAO.countValid();
    }

    @Override
    public boolean isNoticeExpired(Notice notice) {
        if (notice == null || notice.getExpiryTime() == null) {
            return false;
        }
        return new Date().after(notice.getExpiryTime());
    }

    @Override
    public List<Object[]> getNoticeStatusStatistics() {
        List<Object[]> stats = new ArrayList<>();
        return stats;
    }
}
