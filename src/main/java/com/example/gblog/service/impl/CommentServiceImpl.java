package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.CommentMapper;
import com.example.gblog.service.CommentService;
import com.example.gblog.service.PostService;
import com.example.gblog.service.UserService;
import com.example.gblog.vo.CommentVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {
    @Autowired
    CommentMapper commentMapper;
    @Autowired
    UserService userService;
    @Autowired
    PostService postService;
    @Override
    public void addComment(Integer postId, String review) {
        //获得当前登录用户的信息
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        commentMapper.addComment(userId,postId,review);
    }

    @Override
    public List<CommentVo> getComment(Integer id) {
        List<CommentVo> res = commentMapper.getComment(id);
        for (CommentVo re : res) {
            re.setReComm(commentMapper.getReComment(re.getId(),id));
        }
        return res;
    }

    @Override
    public void addRe(Integer id, Integer postId, Integer replayId, Integer userId, String comment,Integer rId) {
        Integer u_id = ((User) SecurityUtils.getSubject().getSession().getAttribute("profile")).getId();
        commentMapper.addRe(u_id,id,postId,id,userId,comment,rId);
    }

    @Override
    public void del(Integer id,Integer postId) {
        //删除评论主键为id的评论,注意删除关联  re_id
        //查询所有关联id
        ArrayList<Integer> ids = new ArrayList<>();
        ids.add(id);
        while (ids.size() != 0){
            List<Integer> res = new ArrayList<>();
            for (Integer integer : ids) {
                res.addAll(commentMapper.getFloorIds(integer));
                //将其删除，更改状态
                commentMapper.changeStatus(integer);
                //修改这篇文章的评论数量
                postService.subReviewCount(postId);
            }
            //清空
            ids.clear();
            //更新数组
            ids.addAll(res);
        }

    }
}
