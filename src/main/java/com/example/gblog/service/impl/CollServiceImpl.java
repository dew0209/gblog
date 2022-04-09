package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.CollMapper;
import com.example.gblog.service.CollService;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CollServiceImpl implements CollService {
    @Autowired
    CollMapper collMapper;
    @Override
    public void add(Integer postId) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        collMapper.add(postId,userId);
    }

    @Override
    public void remove(Integer postId) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        collMapper.remove(postId,userId);
    }

    @Override
    public Integer getById(Integer postId) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        return collMapper.getById(postId,userId);
    }
}
