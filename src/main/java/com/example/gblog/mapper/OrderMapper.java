package com.example.gblog.mapper;

import com.example.gblog.bean.Order;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface OrderMapper {
    Order getById(@Param("postId") Integer id,@Param("userId") Integer id1);

    void addPayNo(@Param("price") Integer price,@Param("tradeNo") String tradeNo,@Param("userId") Integer id,@Param("postId")Integer postId);

    Order getByOrderId(@Param("postId") Integer postId,@Param("userId")Integer userId);

    void addRealPay(@Param("price") String totalAmount,@Param("orderId") String outTradeNo,@Param("realOrderId") String tradeNo);

    Order getByOutTradeNo(@Param("outTradeNo") String outTradeNo);
}
