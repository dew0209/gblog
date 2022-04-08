package com.example.gblog.service.impl;

import com.example.gblog.bean.Order;
import com.example.gblog.bean.Post;
import com.example.gblog.mapper.PayPostMapper;
import com.example.gblog.service.OrderService;
import com.example.gblog.service.PayPostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PayPostServiceImpl implements PayPostService {
    @Autowired
    PayPostMapper payPostMapper;
    @Autowired
    OrderService orderService;

    @Override
    public PageVo<BlogListVo> getPostPay(Integer pn, Integer size) {
        PageVo<BlogListVo> res = new PageVo<>();
        res.setCurrPage(pn);
        res.setPageSize(size);
        //获得总数
        res.setTotalCount(getTotalPay());
        res.setList(payPostMapper.getPostPay((pn - 1) * size,size));
        return res;
    }
    @Override
    public Post getById(Integer id) {
        Post byId = payPostMapper.getById(id);
        //用户是否已经付费过此订单
        //if()  先设定都没有付费
        Order res = orderService.getById(id);
        if(res == null){
            //没有付费
            byId.setContent(null);
        }
        return byId;
    }

    private int getTotalPay() {
        return payPostMapper.getTotalPay();
    }
}
