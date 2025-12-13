package com.ssm;

import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.Context;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.catalina.webresources.DirResourceSet;

import java.io.File;

/**
 * Spring应用程序入口类
 * 使用内嵌Tomcat启动Web应用
 */
public class Application {
    
    public static void main(String[] args) throws Exception {
        // 创建Tomcat实例
        Tomcat tomcat = new Tomcat();
        
        // 设置端口号
        int port = 8080;
        tomcat.setPort(port);
        tomcat.getConnector(); // 初始化默认连接器
        
        // 设置基本目录
        tomcat.setBaseDir("target/tomcat");
        
        // 创建Web应用上下文
        String contextPath = "";
        String webappDirLocation = new File("src/main/webapp/").getAbsolutePath();
        
        // 使用addWebapp加载Web应用
        Context context = tomcat.addWebapp(contextPath, webappDirLocation);
        
        // 设置父类加载器委托，解决类加载问题
        context.setParentClassLoader(Application.class.getClassLoader());
        
        // 添加编译后的类路径
        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(context);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                additionWebInfClasses.getAbsolutePath(), "/"));
        context.setResources(resources);
        
        // 启动Tomcat
        System.out.println("正在启动Spring应用，端口: " + port);
        tomcat.start();
        
        // 等待请求
        System.out.println("应用已启动，请访问 http://localhost:" + port);
        tomcat.getServer().await();
    }
}