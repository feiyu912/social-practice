package com.ssm.dao;

import com.ssm.entity.Notice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 公告DAO接口
 */
public interface NoticeDAO {
    /**
     * 根据ID查询公告
     */
    Notice findById(@Param("id") Integer id);

    /**
     * 查询所有公告
     */
    List<Notice> findAll();

    /**
     * 查询有效公告（已发布的）
     */
    List<Notice> findValidNotices();

    /**
     * 根据发布者ID查询公告
     */
    List<Notice> findByPublisherId(@Param("publisherId") Integer publisherId);

    /**
     * 根据标题模糊查询
     */
    List<Notice> findByTitleLike(@Param("title") String title);

    /**
     * 根据标题或内容模糊查询
     */
    List<Notice> findByTitleOrContent(@Param("keyword") String keyword);

    /**
     * 插入公告
     */
    int insert(Notice notice);

    /**
     * 更新公告
     */
    int update(Notice notice);

    /**
     * 删除公告
     */
    int delete(@Param("id") Integer id);

    /**
     * 统计公告数量
     */
    int count();

    /**
     * 统计有效公告数量
     */
    int countValid();

    /**
     * 更新公告状态
     */
    int updateStatus(@Param("id") Integer id, @Param("status") String status);
}
