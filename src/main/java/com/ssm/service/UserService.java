package com.ssm.service;

import com.ssm.entity.User;
import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {
    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 用户对象，登录失败返回null
     */
    User login(String username, String password);

    /**
     * 根据ID查询用户
     * @param userId 用户ID
     * @return 用户对象
     */
    User findById(Integer userId);

    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户对象
     */
    User findByUsername(String username);

    /**
     * 查询所有用户
     * @return 用户列表
     */
    List<User> findAll();

    /**
     * 添加用户
     * @param user 用户对象
     * @return 是否成功
     */
    boolean addUser(User user);

    /**
     * 更新用户信息
     * @param user 用户对象
     * @return 是否成功
     */
    boolean updateUser(User user);

    /**
     * 删除用户
     * @param userId 用户ID
     * @return 是否成功
     */
    boolean deleteUser(Integer userId);

    /**
     * 修改密码
     * @param userId 用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 是否成功
     */
    boolean changePassword(Integer userId, String oldPassword, String newPassword);

    /**
     * 重置密码
     * @param userId 用户ID
     * @param newPassword 新密码
     * @return 是否成功
     */
    boolean resetPassword(Integer userId, String newPassword);

    /**
     * 检查用户名是否存在
     * @param username 用户名
     * @return 是否存在
     */
    boolean isUsernameExists(String username);
}