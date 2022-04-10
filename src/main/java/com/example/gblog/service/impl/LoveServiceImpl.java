package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.LoveMapper;
import com.example.gblog.service.LoveService;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoveServiceImpl implements LoveService {
    @Autowired
    LoveMapper loveMapper;
    @Override
    public void add(Integer postId) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        loveMapper.add(postId,userId);
    }

    @Override
    public void remove(Integer postId) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        loveMapper.remove(postId,userId);
    }

    @Override
    public Integer getById(Integer id) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        return loveMapper.getById(id,userId);
    }

    @Override
    public void delByPostId(Integer id) {
        loveMapper.delByPostId(id);
    }
}
