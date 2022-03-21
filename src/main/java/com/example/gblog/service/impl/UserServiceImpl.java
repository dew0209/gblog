package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.UserMapper;
import com.example.gblog.service.UserService;
import com.example.gblog.vo.RegisterVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserMapper userMapper;
    @Override
    public Integer register(RegisterVo user) {
        Integer res = userMapper.register(user);
        return res;
    }

    @Override
    public User login(String username, String password) {
        User res = userMapper.getUserByUsernameAndPassword(username,password);
        return null;
    }
}
