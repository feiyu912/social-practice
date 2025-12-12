package com.ssm.service.impl;

import com.ssm.dao.TeacherDAO;
import com.ssm.entity.Teacher;
import com.ssm.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 教师服务实现类
 */
@Service
@Transactional
public class TeacherServiceImpl implements TeacherService {

    @Autowired
    private TeacherDAO teacherDAO;

    @Override
    public Teacher findById(Integer teacherId) {
        return teacherDAO.findById(teacherId);
    }

    @Override
    public Teacher findByUserId(Integer userId) {
        return teacherDAO.findByUserId(userId);
    }

    @Override
    public Teacher findByTeacherNumber(String teacherNumber) {
        return teacherDAO.findByTeacherNumber(teacherNumber);
    }

    @Override
    public List<Teacher> findAll() {
        // 使用分页参数，但返回所有教师
        return teacherDAO.findAll(0, Integer.MAX_VALUE);
    }

    @Override
    public List<Teacher> findByName(String name) {
        return teacherDAO.findByName(name);
    }

    @Override
    public List<Teacher> findByDepartment(String department) {
        return teacherDAO.findByDepartment(department);
    }

    @Override
    public List<Teacher> findByTitle(String title) {
        return teacherDAO.findByTitle(title);
    }

    @Override
    public boolean addTeacher(Teacher teacher) {
        try {
            // Teacher实体类没有时间属性，直接插入
            return teacherDAO.insert(teacher) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateTeacher(Teacher teacher) {
        try {
            // Teacher实体类没有时间属性，直接更新
            return teacherDAO.update(teacher) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteTeacher(Integer teacherId) {
        try {
            return teacherDAO.delete(teacherId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getTeacherCount() {
        return teacherDAO.count();
    }

    @Override
    public boolean isTeacherNumberExists(String teacherNumber) {
        return teacherDAO.findByTeacherNumber(teacherNumber) != null;
    }

    @Override
    public int batchDeleteTeachers(List<Integer> teacherIds) {
        try {
            int count = 0;
            for (Integer teacherId : teacherIds) {
                if (teacherDAO.delete(teacherId) > 0) {
                    count++;
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int importTeachers(List<Teacher> teachers) {
        try {
            int count = 0;
            for (Teacher teacher : teachers) {
                if (!isTeacherNumberExists(teacher.getTeacherNumber())) {
                    // Teacher实体类没有时间属性，直接插入
                    if (teacherDAO.insert(teacher) > 0) {
                        count++;
                    }
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<Teacher> searchByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return teacherDAO.searchByKeyword(keyword.trim(), 0, Integer.MAX_VALUE);
    }
}