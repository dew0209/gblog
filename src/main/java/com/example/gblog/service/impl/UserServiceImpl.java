package com.example.gblog.service.impl;

import com.example.gblog.bean.User;
import com.example.gblog.mapper.UserMapper;
import com.example.gblog.service.UserService;
import com.example.gblog.vo.RegisterVo;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
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
    public User login(String email, String password) {
        //比对输入的密码和数据库存储的密码是否一致
        RegisterVo res = userMapper.getUserByUsernameAndPassword(email);
        //没有这个人
        if (res == null){
            throw new UnknownAccountException();
        }
        //密码不一致
        if (!res.getPassword().equalsIgnoreCase(password)){
            throw new IncorrectCredentialsException();
        }
        //更新登录状态，设status为1.
        userMapper.updateStatus(email,1);
        return res;
    }

    @Override
    public boolean hasEmail(String email) {
        int count = userMapper.hasEmail(email);
        return count == 1;
    }

    @Override
    public User getById(Integer id) {
        return userMapper.getById(id);
    }

    @Override
    public Integer getBlSt(Integer id) {
        return userMapper.getBlSt(id);
    }

    @Override
    public Integer getBlNoPay(Integer id) {
        return userMapper.getBlNoPay(id);
    }

    @Override
    public Integer getBlogPay(Integer id) {
        return userMapper.getBlogPay(id);
    }

    @Override
    public void stS1(Integer id) {
        userMapper.setS1(id);
    }

    @Override
    public void stS2(Integer id) {
        userMapper.setS2(id);
    }
    @Override
    public void stS3(Integer id) {
        userMapper.setS3(id);
    }

    @Override
    public void stu1(Integer id) {
        userMapper.setu1(id);
    }
    @Override
    public void stu2(Integer id) {
        userMapper.setu2(id);
    }
    @Override
    public void stu3(Integer id) {
        userMapper.setu3(id);
    }
}
