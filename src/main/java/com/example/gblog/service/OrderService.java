package com.example.gblog.service;

import com.example.gblog.bean.Order;

public interface OrderService {

    Order getById(Integer id);

    void addPayNo(Integer price, String tradeNo, Integer id,Integer postId);

    Order getByOrderId(String tradeNo);

    void addRealPay(String totalAmount, String outTradeNo, String tradeNo);

    Order getByOutTradeNo(String outTradeNo);
}
