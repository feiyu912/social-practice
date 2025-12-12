package com.ssm.service.impl;

import com.ssm.dao.IGoodsDao;
import com.ssm.entity.Goods;
import com.ssm.service.IGoodsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 商品服务实现类
 * 实现商品相关的业务逻辑
 */
@Service
@Transactional
public class GoodsServiceImpl implements IGoodsService {
    
    @Autowired
    private IGoodsDao goodsDao;
    
    @Override
    public List<Goods> findAllGoods() {
        return goodsDao.findAll();
    }
    
    @Override
    public Goods findGoodsById(Integer id) {
        return goodsDao.findById(id);
    }
    
    @Override
    public boolean addGoods(Goods goods) {
        try {
            return goodsDao.addGoods(goods) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateGoods(Goods goods) {
        try {
            return goodsDao.updateGoods(goods) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean deleteGoods(Integer id) {
        try {
            return goodsDao.deleteGoods(id) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Goods> findGoodsByName(String goodsname) {
        return goodsDao.findByGoodsname(goodsname);
    }
    
    @Override
    public List<Goods> findGoodsByCondition(Goods goods) {
        return goodsDao.findGoodsByCondition(goods);
    }
}