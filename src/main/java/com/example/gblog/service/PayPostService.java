package com.example.gblog.service;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CollVo;
import com.example.gblog.vo.PageVo;
import com.example.gblog.vo.PayPostVo;

import java.util.List;

public interface PayPostService {
    PageVo<BlogListVo> getPostPay(Integer pn, Integer size);

    Post getById(Integer id);

    void add(Post newPost);

    void update(Post newPost);

    void del(Integer id);

    PageVo<PayPostVo> getByUserId(Integer userId,Integer pn,Integer pnSize);

    PageVo<CollVo> getColl(Integer id, Integer pn, Integer pnSize);
}
