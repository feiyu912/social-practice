package com.ssm.service;

import java.util.List;
import com.ssm.entity.Goods;

/**
 * 商品服务接口
 * 定义商品相关的业务逻辑方法
 */
public interface IGoodsService {
    /**
     * 查询全部商品
     * @return 商品列表
     */
    List<Goods> findAllGoods();
    
    /**
     * 根据ID查询商品
     * @param id 商品ID
     * @return 商品对象
     */
    Goods findGoodsById(Integer id);
    
    /**
     * 添加商品
     * @param goods 商品对象
     * @return 添加结果
     */
    boolean addGoods(Goods goods);
    
    /**
     * 修改商品
     * @param goods 商品对象
     * @return 修改结果
     */
    boolean updateGoods(Goods goods);
    
    /**
     * 删除商品
     * @param id 商品ID
     * @return 删除结果
     */
    boolean deleteGoods(Integer id);
    
    /**
     * 根据商品名称模糊查询
     * @param goodsname 商品名称
     * @return 商品列表
     */
    List<Goods> findGoodsByName(String goodsname);
    
    /**
     * 根据条件动态查询商品
     * @param goods 查询条件
     * @return 商品列表
     */
    List<Goods> findGoodsByCondition(Goods goods);
}