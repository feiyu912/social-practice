package com.ssm.service.impl;

import com.ssm.dao.StudentDAO;
import com.ssm.entity.Student;
import com.ssm.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 学生服务实现类
 */
@Service
@Transactional
public class StudentServiceImpl implements StudentService {

    @Autowired
    private StudentDAO studentDAO;

    @Override
    public Student findById(Integer studentId) {
        return studentDAO.findById(studentId);
    }

    @Override
    public Student findByUserId(Integer userId) {
        return studentDAO.findByUserId(userId);
    }

    @Override
    public Student findByStudentNumber(String studentNumber) {
        return studentDAO.findByStudentNumber(studentNumber);
    }

    @Override
    public List<Student> findAll() {
        // 使用分页参数，但返回所有学生
        return studentDAO.findAll(0, Integer.MAX_VALUE);
    }

    @Override
    public List<Student> findByName(String name) {
        return studentDAO.findByName(name);
    }

    @Override
    public List<Student> findByClassName(String className) {
        return studentDAO.findByClassName(className);
    }

    @Override
    public boolean addStudent(Student student) {
        try {
            // Student实体类没有时间属性，直接插入
            return studentDAO.insert(student) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStudent(Student student) {
        try {
            // Student实体类没有时间属性，直接更新
            return studentDAO.update(student) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteStudent(Integer studentId) {
        try {
            return studentDAO.delete(studentId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getStudentCount() {
        return studentDAO.count();
    }

    @Override
    public boolean isStudentNumberExists(String studentNumber) {
        return studentDAO.findByStudentNumber(studentNumber) != null;
    }

    @Override
    public int batchDeleteStudents(List<Integer> studentIds) {
        try {
            int count = 0;
            for (Integer studentId : studentIds) {
                if (studentDAO.delete(studentId) > 0) {
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
    public int importStudents(List<Student> students) {
        try {
            int count = 0;
            for (Student student : students) {
                if (!isStudentNumberExists(student.getStudentNumber())) {
                    // Student实体类没有时间属性，直接插入
                    if (studentDAO.insert(student) > 0) {
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
    public List<Student> searchByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return studentDAO.searchByKeyword(keyword.trim(), 0, Integer.MAX_VALUE);
    }
}