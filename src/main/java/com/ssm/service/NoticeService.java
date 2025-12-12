package com.ssm.service;

import com.ssm.entity.Notice;
import java.util.List;

/**
 * 公告服务接口
 */
public interface NoticeService {
    /**
     * 根据ID查询公告
     * @param noticeId 公告ID
     * @return 公告对象
     */
    Notice findById(Integer noticeId);

    /**
     * 查询所有公告
     * @return 公告列表
     */
    List<Notice> findAll();

    /**
     * 查询有效公告（未过期的）
     * @return 公告列表
     */
    List<Notice> findValidNotices();

    /**
     * 根据发布者ID查询公告
     * @param publisherId 发布者ID
     * @return 公告列表
     */
    List<Notice> findByPublisherId(Integer publisherId);

    /**
     * 根据标题模糊查询公告
     * @param title 标题关键词
     * @return 公告列表
     */
    List<Notice> findByTitleLike(String title);

    /**
     * 根据标题或内容模糊查询
     * @param keyword 关键词
     * @return 公告列表
     */
    List<Notice> findByTitleOrContent(String keyword);

    /**
     * 添加公告
     * @param notice 公告对象
     * @return 是否成功
     */
    boolean addNotice(Notice notice);

    /**
     * 更新公告
     * @param notice 公告对象
     * @return 是否成功
     */
    boolean updateNotice(Notice notice);

    /**
     * 删除公告
     * @param noticeId 公告ID
     * @return 是否成功
     */
    boolean deleteNotice(Integer noticeId);

    /**
     * 插入公告（简化接口）
     * @param notice 公告对象
     * @return 是否成功
     */
    boolean insert(Notice notice);

    /**
     * 更新公告（简化接口）
     * @param notice 公告对象
     * @return 是否成功
     */
    boolean update(Notice notice);

    /**
     * 删除公告（简化接口）
     * @param id 公告ID
     */
    void delete(Integer id);

    /**
     * 发布公告
     * @param noticeId 公告ID
     * @return 是否成功
     */
    boolean publishNotice(Integer noticeId);

    /**
     * 撤销公告
     * @param noticeId 公告ID
     * @return 是否成功
     */
    boolean revokeNotice(Integer noticeId);

    /**
     * 获取最新公告
     * @param count 数量
     * @return 公告列表
     */
    List<Notice> getLatestNotices(int count);

    /**
     * 获取公告总数
     * @return 公告总数
     */
    int getTotalCount();

    /**
     * 获取有效公告数量
     * @return 有效公告数量
     */
    int getValidNoticeCount();

    /**
     * 检查公告是否过期
     * @param notice 公告对象
     * @return 是否过期
     */
    boolean isNoticeExpired(Notice notice);

    /**
     * 获取公告状态统计
     * @return 状态统计
     */
    List<Object[]> getNoticeStatusStatistics();
}