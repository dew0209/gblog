package com.example.gblog.mapper;

import com.example.gblog.bean.Order;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface OrderMapper {
    Order getById(@Param("postId") Integer id,@Param("userId") Integer id1);
}
