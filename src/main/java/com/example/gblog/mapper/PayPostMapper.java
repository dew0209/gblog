package com.example.gblog.mapper;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.BlogListVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface PayPostMapper {
    List<BlogListVo> getPostPay(@Param("st") int i,@Param("size") Integer size);

    int getTotalPay();

    Post getById(@Param("id") Integer id);
}
