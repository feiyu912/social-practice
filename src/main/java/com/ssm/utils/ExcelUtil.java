package com.ssm.utils;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Excel/CSV工具类
 * 用于导入导出数据
 */
public class ExcelUtil {

    /**
     * 读取CSV文件
     * @param file 文件
     * @return 数据列表（每行一个数组）
     */
    public static List<String[]> readCSV(File file) throws IOException {
        List<String[]> data = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }
                // 简单的CSV解析（假设使用逗号分隔）
                String[] values = line.split(",");
                // 去除每个值的首尾空格
                for (int i = 0; i < values.length; i++) {
                    values[i] = values[i].trim();
                }
                data.add(values);
            }
        }
        return data;
    }

    /**
     * 写入CSV文件
     * @param file 文件
     * @param headers 表头
     * @param data 数据列表
     */
    public static void writeCSV(File file, String[] headers, List<String[]> data) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"))) {
            // 写入表头
            if (headers != null && headers.length > 0) {
                writer.write(String.join(",", headers));
                writer.newLine();
            }
            // 写入数据
            for (String[] row : data) {
                writer.write(String.join(",", row));
                writer.newLine();
            }
        }
    }

    /**
     * 生成CSV内容（用于下载）
     * @param headers 表头
     * @param data 数据列表
     * @return CSV内容字符串
     */
    public static String generateCSV(String[] headers, List<String[]> data) {
        StringBuilder sb = new StringBuilder();
        // 写入表头
        if (headers != null && headers.length > 0) {
            sb.append(String.join(",", headers));
            sb.append("\n");
        }
        // 写入数据
        for (String[] row : data) {
            sb.append(String.join(",", row));
            sb.append("\n");
        }
        return sb.toString();
    }
}


