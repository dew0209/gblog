package com.example.gblog.service;

import com.example.gblog.bean.User;
import com.example.gblog.vo.RegisterVo;

public interface UserService {
    public Integer register(RegisterVo user);

    User login(String username, String password);
}
