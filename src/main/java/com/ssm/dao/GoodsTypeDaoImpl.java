package com.ssm.dao;

import com.ssm.entity.Goods;
import com.ssm.entity.GoodsType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * 商品类别DAO实现类
 * 实现IGoodsTypeDao接口，使用Spring JDBC进行数据库操作
 */
@Repository
public class GoodsTypeDaoImpl implements IGoodsTypeDao {
    
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    // 商品类别RowMapper
    private final RowMapper<GoodsType> goodsTypeRowMapper = new RowMapper<GoodsType>() {
        @Override
        public GoodsType mapRow(ResultSet rs, int rowNum) throws SQLException {
            GoodsType goodsType = new GoodsType();
            goodsType.setTid(rs.getInt("tid"));
            goodsType.setTypename(rs.getString("typename"));
            return goodsType;
        }
    };
    
    // 商品RowMapper
    private final RowMapper<Goods> goodsRowMapper = new RowMapper<Goods>() {
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
    public List<GoodsType> findAllWithGoods() {
        String sql = "SELECT DISTINCT t.tid, t.typename FROM goods_type t";
        List<GoodsType> goodsTypes = jdbcTemplate.query(sql, goodsTypeRowMapper);
        
        // 为每个类别查询对应的商品
        for (GoodsType goodsType : goodsTypes) {
            String goodsSql = "SELECT g.id, g.goodsname, g.price, g.quantity, g.typeid FROM goods g WHERE g.typeid = ?";
            List<Goods> goodsList = jdbcTemplate.query(goodsSql, goodsRowMapper, goodsType.getTid());
            goodsType.setGoodsList(goodsList);
        }
        
        return goodsTypes;
    }
    
    @Override
    public GoodsType findByIdWithGoods(Integer tid) {
        String sql = "SELECT tid, typename FROM goods_type WHERE tid = ?";
        try {
            GoodsType goodsType = jdbcTemplate.queryForObject(sql, goodsTypeRowMapper, tid);
            
            // 查询该类别下的所有商品
            String goodsSql = "SELECT g.id, g.goodsname, g.price, g.quantity, g.typeid FROM goods g WHERE g.typeid = ?";
            List<Goods> goodsList = jdbcTemplate.query(goodsSql, goodsRowMapper, tid);
            goodsType.setGoodsList(goodsList);
            
            return goodsType;
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
    
    @Override
    public List<GoodsType> findAll() {
        String sql = "SELECT tid, typename FROM goods_type";
        return jdbcTemplate.query(sql, goodsTypeRowMapper);
    }
    
    @Override
    public GoodsType findById(Integer tid) {
        String sql = "SELECT tid, typename FROM goods_type WHERE tid = ?";
        try {
            return jdbcTemplate.queryForObject(sql, goodsTypeRowMapper, tid);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
}