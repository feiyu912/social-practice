package com.ssm.entity;

import java.util.List;

/**
 * 商品类别实体类
 * 对应数据库中的goods_type表
 */
public class GoodsType {
    private Integer tid;          // 商品类别编号
    private String typename;      // 商品类别名称
    private List<Goods> goodsList; // 该类别下的商品集合（一对多）
    
    // 无参构造方法
    public GoodsType() {
    }
    
    // 有参构造方法
    public GoodsType(Integer tid, String typename) {
        this.tid = tid;
        this.typename = typename;
    }
    
    // getter和setter方法
    public Integer getTid() {
        return tid;
    }
    
    public void setTid(Integer tid) {
        this.tid = tid;
    }
    
    public String getTypename() {
        return typename;
    }
    
    public void setTypename(String typename) {
        this.typename = typename;
    }
    
    public List<Goods> getGoodsList() {
        return goodsList;
    }
    
    public void setGoodsList(List<Goods> goodsList) {
        this.goodsList = goodsList;
    }
    
    // toString方法
    @Override
    public String toString() {
        return "GoodsType [tid=" + tid + ", typename=" + typename + "]";
    }
}