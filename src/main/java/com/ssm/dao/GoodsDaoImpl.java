package com.ssm.dao;

import java.util.List;
import java.util.ArrayList;
import java.sql.*;
import com.ssm.entity.Goods;
import com.ssm.entity.GoodsType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.dao.EmptyResultDataAccessException;

/**
 * 商品数据访问接口实现类
 * 使用Spring JDBC实现数据库操作
 */
public class GoodsDaoImpl implements IGoodsDao {
    
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    private RowMapper<Goods> goodsRowMapper = new RowMapper<Goods>() {
        @Override
        public Goods mapRow(ResultSet rs, int rowNum) throws SQLException {
            Goods goods = new Goods();
            goods.setId(rs.getInt("id"));
            goods.setGoodsname(rs.getString("goodsname"));
            goods.setPrice(rs.getDouble("price"));
            goods.setQuantity(rs.getInt("quantity"));
            goods.setTypeid(rs.getInt("typeid"));
            return goods;
        }
    };
    
    @Override
    public List<Goods> findAll() {
        String sql = "SELECT g.id, g.goodsname, g.price, g.quantity, g.typeid, t.tid, t.typename " +
                    "FROM goods g LEFT JOIN goods_type t ON g.typeid = t.tid";
        return jdbcTemplate.query(sql, new RowMapper<Goods>() {
            @Override
            public Goods mapRow(ResultSet rs, int rowNum) throws SQLException {
                Goods goods = new Goods();
                goods.setId(rs.getInt("id"));
                goods.setGoodsname(rs.getString("goodsname"));
                goods.setPrice(rs.getDouble("price"));
                goods.setQuantity(rs.getInt("quantity"));
                goods.setTypeid(rs.getInt("typeid"));
                
                // 设置商品类别信息
                GoodsType goodsType = new GoodsType();
                goodsType.setTid(rs.getInt("tid"));
                goodsType.setTypename(rs.getString("typename"));
                goods.setGoodsType(goodsType);
                
                return goods;
            }
        });
    }
    
    @Override
    public Goods findById(Integer id) {
        String sql = "SELECT g.id, g.goodsname, g.price, g.quantity, g.typeid, t.tid, t.typename " +
                    "FROM goods g LEFT JOIN goods_type t ON g.typeid = t.tid " +
                    "WHERE g.id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new RowMapper<Goods>() {
                @Override
                public Goods mapRow(ResultSet rs, int rowNum) throws SQLException {
                    Goods goods = new Goods();
                    goods.setId(rs.getInt("id"));
                    goods.setGoodsname(rs.getString("goodsname"));
                    goods.setPrice(rs.getDouble("price"));
                    goods.setQuantity(rs.getInt("quantity"));
                    goods.setTypeid(rs.getInt("typeid"));
                    
                    // 设置商品类别信息
                    GoodsType goodsType = new GoodsType();
                    goodsType.setTid(rs.getInt("tid"));
                    goodsType.setTypename(rs.getString("typename"));
                    goods.setGoodsType(goodsType);
                    
                    return goods;
                }
            }, id);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
    
    @Override
    public int addGoods(Goods goods) {
        String sql = "INSERT INTO goods (goodsname, price, quantity, typeid) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, goods.getGoodsname(), goods.getPrice(), goods.getQuantity(), goods.getTypeid());
    }
    
    @Override
    public int deleteGoods(Integer id) {
        String sql = "DELETE FROM goods WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }
    
    @Override
    public int updateGoods(Goods goods) {
        String sql = "UPDATE goods SET goodsname = ?, price = ?, quantity = ?, typeid = ? WHERE id = ?";
        return jdbcTemplate.update(sql, goods.getGoodsname(), goods.getPrice(), goods.getQuantity(), goods.getTypeid(), goods.getId());
    }
    
    @Override
    public List<Goods> findByGoodsname(String goodsname) {
        String sql = "SELECT id, goodsname, price, quantity, typeid FROM goods WHERE goodsname LIKE ?";
        return jdbcTemplate.query(sql, goodsRowMapper, "%" + goodsname + "%");
    }
    
    @Override
    public List<Goods> findGoodsByCondition(Goods goods) {
        StringBuilder sql = new StringBuilder("SELECT id, goodsname, price, quantity, typeid FROM goods WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (goods.getGoodsname() != null && !goods.getGoodsname().trim().isEmpty()) {
            sql.append(" AND goodsname LIKE ?");
            params.add("%" + goods.getGoodsname() + "%");
        }
        
        if (goods.getPrice() != null && goods.getPrice() > 0) {
            sql.append(" AND price <= ?");
            params.add(goods.getPrice());
        }
        
        if (goods.getQuantity() != null && goods.getQuantity() > 0) {
            sql.append(" AND quantity >= ?");
            params.add(goods.getQuantity());
        }
        
        if (goods.getTypeid() != null && goods.getTypeid() > 0) {
            sql.append(" AND typeid = ?");
            params.add(goods.getTypeid());
        }
        
        return jdbcTemplate.query(sql.toString(), goodsRowMapper, params.toArray());
    }
}