package com.example.gblog.service.impl;

import com.example.gblog.bean.Order;
import com.example.gblog.bean.User;
import com.example.gblog.mapper.OrderMapper;
import com.example.gblog.service.OrderService;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    OrderMapper orderMapper;

    @Override
    public Order getById(Integer id) {
        User profile = (User)SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(profile == null) return  null;
        return orderMapper.getById(id, profile.getId());
    }



    @Override
    public void addPayNo(Integer price, String tradeNo, Integer id,Integer postId) {
        orderMapper.addPayNo(price,tradeNo,id,postId);
    }

    @Override
    public Order getByOrderId(Integer postId) {
        User profile = (User)SecurityUtils.getSubject().getSession().getAttribute("profile");
        return orderMapper.getByOrderId(postId,profile.getId());
    }

    @Override
    public void addRealPay(String totalAmount, String outTradeNo, String tradeNo) {
        orderMapper.addRealPay(totalAmount,outTradeNo,tradeNo);
    }

    @Override
    public Order getByOutTradeNo(String outTradeNo) {
        return orderMapper.getByOutTradeNo(outTradeNo);
    }
}
