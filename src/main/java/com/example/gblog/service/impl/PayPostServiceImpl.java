package com.example.gblog.service.impl;

import com.example.gblog.bean.Order;
import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.mapper.PayPostMapper;
import com.example.gblog.service.OrderService;
import com.example.gblog.service.PayPostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;
import org.apache.shiro.SecurityUtils;
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
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null){
            byId.setContent(null);
            return byId;
        }
        Order res = orderService.getById(id);
        if(user.getId() == byId.getUser().getId())return byId;
        if(res == null){
            //没有付费
            byId.setContent(null);
        }
        return byId;
    }

    @Override
    public void add(Post newPost) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();
        payPostMapper.add(newPost,userId,2);
    }

    private int getTotalPay() {
        return payPostMapper.getTotalPay();
    }
}
