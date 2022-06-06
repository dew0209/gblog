package com.example.gblog.mapper;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CollVo;
import com.example.gblog.vo.PayPostVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface PayPostMapper {
    List<BlogListVo> getPostPay(@Param("st") int i,@Param("size") Integer size,String key);

    int getTotalPay(@Param("key") String key);

    Post getById(@Param("id") Integer id);

    void add(@Param("post") Post newPost,@Param("userId") Integer userId,@Param("type") int i);

    void update(@Param("post") Post newPost);

    void del(@Param("id") Integer id);

    List<PayPostVo> getByUserId(@Param("userId") Integer id,@Param("st")Integer i,@Param("size")Integer size);

    int getTotalPayByUserId(@Param("userId") Integer userId);

    List<CollVo> getColl(@Param("userId") Integer id,@Param("st") Integer pn,@Param("size") Integer pnSize);

    int getTotalColl(@Param("userId") Integer id);

    List<CollVo> getCollAll(@Param("userId") Integer id,@Param("st") Integer pn,@Param("size") Integer pnSize);

    int getTotalCollAll(@Param("id") Integer id);

    List<PayPostVo> getByUserIdNoPay(@Param("userId") Integer userId);

    int isOrderExists(@Param("userId") Integer userId);

    void updateById(@Param("userId") Integer userId,@Param("price") String s,@Param("par")String par);

    void insert(@Param("userId") Integer userId,@Param("price") String s,@Param("par")String par);
}
