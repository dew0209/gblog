package com.example.gblog.service.impl;

import com.example.gblog.bean.Post;
import com.example.gblog.mapper.PostMapper;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.BlogListVo;
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

    @Override
    public PageVo<Post> getPostById(int pn, int pnSize, Integer id) {
        PageVo<Post> res = new PageVo<>();
        res.setList(postMapper.getPostById((pn - 1) * pnSize,pnSize,id));
        return res;
    }

    @Override
    public PageVo<Post> getPostByIdAnStaus(Integer pn, Integer pnSize, Integer id) {
        PageVo<Post> res = new PageVo<>();
        res.setTotalCount(getTotalByStatus(id,0));
        res.setPageSize(pnSize);
        res.setCurrPage(pn);
        res.setList(postMapper.getByStatusAndId(id,0,(pn - 1) * pnSize,pnSize));
        return res;
    }

    @Override
    public PageVo<BlogListVo> getPostNoPay(Integer pn, Integer size) {
        PageVo<BlogListVo> res = new PageVo<>();
        res.setCurrPage(pn);
        res.setPageSize(size);
        //获得总数
        res.setTotalCount(getTotalNoPay());
        res.setList(postMapper.getPostNoPay((pn - 1) * size,size));
        return res;
    }

    private int getTotalNoPay() {
        return postMapper.getTotalNoPay();
    }

    private int getTotalByStatus(Integer id,Integer status) {
        return postMapper.getTotalByStatus(id,status);
    }
}
