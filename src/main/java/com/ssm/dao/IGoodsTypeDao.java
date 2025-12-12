package com.ssm.dao;

import com.ssm.entity.GoodsType;
import java.util.List;

/**
 * 商品类别DAO接口
 * 定义商品类别的数据访问操作
 */
public interface IGoodsTypeDao {
    
    /**
     * 查询所有商品类别（包含商品集合）
     * @return 商品类别列表
     */
    List<GoodsType> findAllWithGoods();
    
    /**
     * 根据类别ID查询类别信息（包含商品集合）
     * @param tid 类别ID
     * @return 商品类别对象
     */
    GoodsType findByIdWithGoods(Integer tid);
    
    /**
     * 查询所有商品类别（不包含商品集合）
     * @return 商品类别列表
     */
    List<GoodsType> findAll();
    
    /**
     * 根据类别ID查询类别信息（不包含商品集合）
     * @param tid 类别ID
     * @return 商品类别对象
     */
    GoodsType findById(Integer tid);
}