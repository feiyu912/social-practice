package com.ssm.dao;

import com.ssm.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户DAO接口
 */
public interface UserDAO {
    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户对象
     */
    User findByUsername(@Param("username") String username);

    /**
     * 根据ID查询用户
     * @param userId 用户ID
     * @return 用户对象
     */
    User findById(@Param("userId") Integer userId);

    /**
     * 添加用户
     * @param user 用户对象
     * @return 影响行数
     */
    int insert(User user);

    /**
     * 更新用户信息
     * @param user 用户对象
     * @return 影响行数
     */
    int update(User user);

    /**
     * 删除用户
     * @param userId 用户ID
     * @return 影响行数
     */
    int delete(@Param("userId") Integer userId);

    /**
     * 更新用户状态
     * @param userId 用户ID
     * @param status 状态
     * @return 影响行数
     */
    int updateStatus(@Param("userId") Integer userId, @Param("status") Integer status);

    /**
     * 修改密码
     * @param userId 用户ID
     * @param password 新密码
     * @return 影响行数
     */
    int updatePassword(@Param("userId") Integer userId, @Param("password") String password);
    
    /**
     * 查询所有用户
     * @return 用户列表
     */
    List<User> findAll();
    
    /**
     * 根据角色查询用户
     * @param role 角色
     * @return 用户列表
     */
    List<User> findByRole(@Param("role") String role);
}