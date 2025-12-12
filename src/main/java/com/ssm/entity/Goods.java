package com.ssm.entity;

/**
 * 商品实体类
 * 对应数据库中的goods表
 */
public class Goods {
    private Integer id;        // 商品编号
    private String goodsname;  // 商品名称
    private Double price;      // 商品单价
    private Integer quantity;  // 商品数量
    private Integer typeid;    // 商品类别ID
    private GoodsType goodsType; // 商品类别对象（多对一）
    
    // 无参构造方法
    public Goods() {
    }
    
    // 有参构造方法
    public Goods(Integer id, String goodsname, Double price, Integer quantity) {
        this.id = id;
        this.goodsname = goodsname;
        this.price = price;
        this.quantity = quantity;
    }
    
    // 有参构造方法（包含类别ID）
    public Goods(Integer id, String goodsname, Double price, Integer quantity, Integer typeid) {
        this.id = id;
        this.goodsname = goodsname;
        this.price = price;
        this.quantity = quantity;
        this.typeid = typeid;
    }
    
    // getter和setter方法
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getGoodsname() {
        return goodsname;
    }
    
    public void setGoodsname(String goodsname) {
        this.goodsname = goodsname;
    }
    
    public Double getPrice() {
        return price;
    }
    
    public void setPrice(Double price) {
        this.price = price;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public Integer getTypeid() {
        return typeid;
    }
    
    public void setTypeid(Integer typeid) {
        this.typeid = typeid;
    }
    
    public GoodsType getGoodsType() {
        return goodsType;
    }
    
    public void setGoodsType(GoodsType goodsType) {
        this.goodsType = goodsType;
    }
    
    // toString方法
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Goods [id=").append(id)
          .append(", goodsname=").append(goodsname)
          .append(", price=").append(price)
          .append(", quantity=").append(quantity)
          .append(", typeid=").append(typeid);
        
        if (goodsType != null) {
            sb.append(", 类别名称=").append(goodsType.getTypename());
        }
        
        sb.append("]");
        return sb.toString();
    }
}