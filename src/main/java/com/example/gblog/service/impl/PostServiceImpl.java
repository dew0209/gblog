package com.example.gblog.service.impl;

import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.mapper.PostMapper;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;
import org.apache.shiro.SecurityUtils;
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

    @Override
    public void addBlogNoPay(String title, String content, String keywords) {
        //普通博客的添加操作
        //页面传给我们标题，内容，关键字
        //我们需要用户id，type=1，status=0，created=now(),lastmd=now(),三个访问为0，介绍为null
        //获得当前登录用户的User对象，为了获取主键
        User profile = (User)SecurityUtils.getSubject().getSession().getAttribute("profile");
        //关键字数组
        String[] keys = keywords.split(",");//关键字数组
        //构造对象
        Post newPost = new Post();
        //设置标题
        newPost.setTitle(title);
        //设置关键字
        if(0 < keys.length)newPost.setKeywords1(keys[0]);
        if(1 < keys.length)newPost.setKeywords2(keys[1]);
        if(2 < keys.length)newPost.setKeywords3(keys[2]);
        //设置价格
        newPost.setPrice(0);
        //设置内容
        newPost.setContent(content);
        //设置创建时间，请调用数据库函数now()
        //设置修改时间，请调用数据库函数now()
        //设置三个不同的数据  访问量，评论数量，收藏数量
        newPost.setViewCount(0);
        newPost.setReviewCount(0);
        newPost.setCollectCount(0);
        //介绍，只针对付费，非付费设置为null
        newPost.setIntroduce(null);
        //type=1,userId=profile.getId()
        postMapper.addBlogNoPay(newPost,1,profile.getId());
    }

    @Override
    public Post getById(Integer id) {
        return postMapper.getById(id);
    }

    private int getTotalNoPay() {
        return postMapper.getTotalNoPay();
    }

    private int getTotalByStatus(Integer id,Integer status) {
        return postMapper.getTotalByStatus(id,status);
    }
}
