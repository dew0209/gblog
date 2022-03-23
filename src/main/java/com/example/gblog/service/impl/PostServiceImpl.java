package com.example.gblog.service.impl;

import com.example.gblog.bean.Post;
import com.example.gblog.mapper.PostMapper;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostServiceImpl implements PostService {
    @Autowired
    PostMapper postMapper;
    @Override
    public PageVo<Post> getPost(int pn, int pnSize) {
        PageVo<Post> res = new PageVo<>();
        res.setList(postMapper.getPost((pn - 1) * pnSize,pnSize));
        return res;
    }
}
