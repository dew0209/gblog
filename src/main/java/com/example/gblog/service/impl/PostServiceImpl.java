package com.example.gblog.service.impl;

import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.mapper.PostMapper;
import com.example.gblog.service.*;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {
    @Autowired
    PostMapper postMapper;
    @Autowired
    CommentService commentService;
    @Autowired
    CollService collService;
    @Autowired
    LoveService loveService;
    @Autowired
    ReadingService readingService;
    @Autowired
    NumService numService;

    @Override
    public PageVo<Post> getPost(int pn, int pnSize) {
        PageVo<Post> res = new PageVo<>();
        res.setList(postMapper.getPost((pn - 1) * pnSize,pnSize));
        List<Post> list = res.getList();
        for (Post post : list) {
            //付费的博客
            if (post.getType().getId() == 2){
                post.setContent(null);
            }
        }
        return res;
    }

    @Override
    public PageVo<Post> getPostById(int pn, int pnSize, Integer id) {
        PageVo<Post> res = new PageVo<>();
        List<Post> postById = postMapper.getPostById((pn - 1) * pnSize, pnSize, id);
        for (Post post : postById) {
            if(post.getType().getId() == 2){
                post.setContent(null);
            }
        }
        res.setList(postById);
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
    public PageVo<BlogListVo> getPostNoPay(Integer pn, Integer size,String key) {
        PageVo<BlogListVo> res = new PageVo<>();
        res.setCurrPage(pn);
        res.setPageSize(size);
        //获得总数
        res.setTotalCount(getTotalNoPay(key));
        res.setList(postMapper.getPostNoPay((pn - 1) * size,size,key));

        return res;
    }

    @Override
    public Integer addBlogNoPay(String title, String content, String keywords) {
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
        return newPost.getId();
    }

    @Override
    public Post getById(Integer id) {
        return postMapper.getById(id);
    }

    @Override
    public void addReviewCount(Integer postId) {
        postMapper.addReviewCount(postId);
    }

    @Override
    public void subReviewCount(Integer postId) {
        postMapper.subReviewCount(postId);
    }

    @Override
    public void update(Post post) {
        postMapper.update(post);
    }

    @Override
    public void del(Integer id) {
        //删除博客  删除评论 删除收藏 删除喜欢（点赞）
        postMapper.del(id);
        commentService.delByPostId(id);
        collService.delByPostId(id);
        loveService.delByPostId(id);
    }

    @Override
    public void addReading(Integer id,Integer userId) {
        //查询这个人是否已经访问这个博客了
        int res = readingService.getByPostIdAndUserId(id,userId);
        if(res == 0){
            //更新reading表
            readingService.insert(id,userId);
            //更新post表
            postMapper.updateViewCount(id);
            //更新data表
            numService.updateReading(postMapper.getById(id).getUser().getId());
        }
    }

    private int getTotalNoPay(String key) {
        return postMapper.getTotalNoPay(key);
    }

    private int getTotalByStatus(Integer id,Integer status) {
        return postMapper.getTotalByStatus(id,status);
    }
}
