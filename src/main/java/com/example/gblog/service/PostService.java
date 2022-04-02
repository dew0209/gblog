package com.example.gblog.service;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.PageVo;

public interface PostService {
    PageVo<Post> getPost(int pn, int pnSize);

    PageVo<Post> getPostById(int pn, int pnSize, Integer id);

    PageVo<Post> getPostByIdAnStaus(Integer pn, Integer pnSize, Integer id);
}
