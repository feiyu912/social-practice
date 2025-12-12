package com.ssm.utils;

import java.io.Reader;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisUtil {
    private MyBatisUtil() {}
    private static final String RESOURCE = "mybatis-config.xml";
    private static SqlSessionFactory sqlSessionFactory = null;
    private static ThreadLocal<SqlSession> threadLocal = new ThreadLocal<SqlSession>();
    
    static {
        Reader reader = null;
        try {
            reader = Resources.getResourceAsReader(RESOURCE);
            SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
            sqlSessionFactory = builder.build(reader);
        } catch (Exception e1) {
            e1.printStackTrace();
            throw new ExceptionInInitializerError("初始化MyBatis失败，请检查配置文件或数据库");
        }
    }
    
    public static SqlSessionFactory getSqlSessionFactory() {
        return sqlSessionFactory;
    }
    
    //获取SqlSession对象
    public static SqlSession getSession() {
        SqlSession session = threadLocal.get();
        if(session == null) {
            session = (sqlSessionFactory != null) ? sqlSessionFactory.openSession() : null;
            threadLocal.set(session);
        }
        return session;
    }
    
    //关闭SqlSession对象
    public static void closeSession() {
        SqlSession session = (SqlSession) threadLocal.get();
        threadLocal.set(null);
        if(session != null) {
            session.close();
        }
    }
}