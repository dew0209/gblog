package com.example.gblog.service;

import com.example.gblog.bean.User;
import com.example.gblog.vo.RegisterVo;

public interface UserService {
    public Integer register(RegisterVo user);

    User login(String email, String password);

    boolean hasEmail(String email);

    User getById(Integer id);

    Integer getBlSt(Integer id);

    Integer getBlNoPay(Integer id);

    Integer getBlogPay(Integer id);

    void stS1(Integer id);
    void stS2(Integer id);
    void stS3(Integer id);
    void stu1(Integer id);
    void stu2(Integer id);
    void stu3(Integer id);
}
