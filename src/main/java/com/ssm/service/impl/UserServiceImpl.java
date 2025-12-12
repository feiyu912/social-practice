package com.ssm.service.impl;

import com.ssm.entity.User;
import com.ssm.dao.UserDAO;
import com.ssm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 用户服务实现类
 */
@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDAO userDAO;

    @Override
    public User login(String username, String password) {
        User user = userDAO.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    @Override
    public User findById(Integer userId) {
        return userDAO.findById(userId);
    }

    @Override
    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    @Override
    public List<User> findAll() {
        try {
            return userDAO.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean addUser(User user) {
        try {
            user.setCreateTime(new Date());
            user.setUpdateTime(new Date());
            return userDAO.insert(user) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUser(User user) {
        try {
            user.setUpdateTime(new Date());
            return userDAO.update(user) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteUser(Integer userId) {
        try {
            return userDAO.delete(userId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean changePassword(Integer userId, String oldPassword, String newPassword) {
        try {
            User user = userDAO.findById(userId);
            if (user != null && user.getPassword().equals(oldPassword)) {
                return userDAO.updatePassword(userId, newPassword) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean resetPassword(Integer userId, String newPassword) {
        try {
            User user = userDAO.findById(userId);
            if (user != null) {
                return userDAO.updatePassword(userId, newPassword) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userDAO.findByUsername(username) != null;
    }
}
