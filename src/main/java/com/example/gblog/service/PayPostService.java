package com.example.gblog.service;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;

public interface PayPostService {
    PageVo<BlogListVo> getPostPay(Integer pn, Integer size);

    Post getById(Integer id);

    void add(Post newPost);
}
