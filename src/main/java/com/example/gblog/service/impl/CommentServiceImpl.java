package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.CommentMapper;
import com.example.gblog.service.CommentService;
import com.example.gblog.service.UserService;
import com.example.gblog.vo.CommentVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {
    @Autowired
    CommentMapper commentMapper;
    @Autowired
    UserService userService;
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
    public void addRe(Integer id, Integer postId, Integer replayId, Integer userId, String comment) {
        Integer u_id = ((User) SecurityUtils.getSubject().getSession().getAttribute("profile")).getId();
        commentMapper.addRe(u_id,id,postId,id,userId,comment);
    }
}
