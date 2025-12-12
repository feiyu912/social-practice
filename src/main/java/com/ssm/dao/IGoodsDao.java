package com.ssm.dao;

import java.util.List;
import com.ssm.entity.Goods;

/**
 * 商品DAO接口
 * 定义商品相关的数据库操作方法
 */
public interface IGoodsDao {
    /**
     * 查询全部商品
     * @return 商品列表
     */
    List<Goods> findAll();
    
    /**
     * 按ID号查询商品
     * @param id 商品ID
     * @return 商品对象
     */
    Goods findById(Integer id);
    
    /**
     * 添加一个新商品
     * @param goods 商品对象
     * @return 受影响的行数
     */
    int addGoods(Goods goods);
    
    /**
     * 按ID号删除一个商品
     * @param id 商品ID
     * @return 受影响的行数
     */
    int deleteGoods(Integer id);
    
    /**
     * 按商品名称模糊查询商品
     * @param goodsname 商品名称关键词
     * @return 商品列表
     */
    List<Goods> findByGoodsname(String goodsname);
    
    /**
     * 动态查询：多个条件为"商品名称、价格、数量组合"
     * @param goods 商品条件对象
     * @return 商品列表
     */
    List<Goods> findGoodsByCondition(Goods goods);
    
    /**
     * 更新商品信息
     * @param goods 商品对象
     * @return 受影响的行数
     */
    int updateGoods(Goods goods);
}