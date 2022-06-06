package com.example.gblog.service.impl;

import com.example.gblog.bean.Order;
import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.mapper.PayPostMapper;
import com.example.gblog.mapper.PostMapper;
import com.example.gblog.service.*;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CollVo;
import com.example.gblog.vo.PageVo;
import com.example.gblog.vo.PayPostVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PayPostServiceImpl implements PayPostService {
    @Autowired
    PayPostMapper payPostMapper;
    @Autowired
    OrderService orderService;
    @Autowired
    ReadingService readingService;
    @Autowired
    PostMapper postMapper;
    @Autowired
    NumService numService;

    @Override
    public PageVo<BlogListVo> getPostPay(Integer pn, Integer size,String key) {
        PageVo<BlogListVo> res = new PageVo<>();
        res.setCurrPage(pn);
        res.setPageSize(size);
        //获得总数
        res.setTotalCount(getTotalPay(key));
        res.setList(payPostMapper.getPostPay((pn - 1) * size,size,key));
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
        }else if(byId.getUser().getId() != user.getId()) {
            //付费了 更新阅读
            //查询这个人是否已经访问这个博客了
            int ans = readingService.getByPostIdAndUserId(id,user.getId());
            if(ans == 0){
                //更新reading表
                readingService.insert(id,user.getId());
                //更新post表
                postMapper.updateViewCount(id);
                //更新data表
                numService.updateReading(payPostMapper.getById(id).getUser().getId());
            }
        }
        return byId;
    }

    @Override
    public void add(Post newPost) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();
        payPostMapper.add(newPost,userId,2);
    }

    @Override
    public void update(Post newPost) {
        payPostMapper.update(newPost);
    }

    @Override
    public void del(Integer id) {
        payPostMapper.del(id);

    }

    @Override
    public PageVo<PayPostVo> getByUserId(Integer userId,Integer pn,Integer pnSize) {
        List<PayPostVo> list = payPostMapper.getByUserId(userId,(pn - 1) * pnSize,pnSize);
        PageVo<PayPostVo> res = new PageVo<>();
        res.setList(list);
        res.setPageSize(pnSize);
        res.setCurrPage(pn);
        res.setTotalCount(getTotalPayByUserId(userId));
        return res;
    }

    @Override
    public PageVo<CollVo> getColl(Integer id, Integer pn, Integer pnSize) {
        List<CollVo> res = payPostMapper.getColl(id,(pn - 1) * pnSize,pnSize);
        PageVo<CollVo> vo = new PageVo<>();
        vo.setTotalCount(payPostMapper.getTotalColl(id));
        vo.setList(res);
        vo.setCurrPage(pn);
        vo.setPageSize(pnSize);
        return vo;
    }

    @Override
    public PageVo<CollVo> getCollOrder(Integer id, Integer pn, Integer pnSize) {
        List<CollVo> res = payPostMapper.getCollAll(id,(pn - 1) * pnSize,pnSize);
        PageVo<CollVo> vo = new PageVo<>();
        vo.setTotalCount(payPostMapper.getTotalCollAll(id));
        vo.setList(res);
        vo.setCurrPage(pn);
        vo.setPageSize(pnSize);
        return vo;
    }

    @Override
    public void caclMon(Integer userId,String par) {
        //获取到有关该用户的所有订单
        //计算所有付费订单
        List<PayPostVo> ids = payPostMapper.getByUserIdNoPay(userId);
        //计算金额
        double res = 0;
        for (PayPostVo id : ids) {
            int dou = id.getAllNum() - id.getGetNum();
            if(dou <= 0)continue;
            res += dou * Integer.parseInt(id.getPrice());
            res -= dou * 0.1;
        }
        //更新
        int ans = payPostMapper.isOrderExists(userId);
        if(ans == 1){
            payPostMapper.updateById(userId,res + "",par);
        }else {
            payPostMapper.insert(userId,res + "",par);
        }
    }

    private int getTotalPayByUserId(Integer userId) {
        return payPostMapper.getTotalPayByUserId(userId);
    }

    private int getTotalPay(String key) {
        return payPostMapper.getTotalPay(key);
    }
}
