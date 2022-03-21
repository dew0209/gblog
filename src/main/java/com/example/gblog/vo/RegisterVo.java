package com.example.gblog.vo;

import com.example.gblog.bean.User;
import lombok.Data;

@Data
public class RegisterVo extends User {

    //密码
    private String password;
    //确认密码
    private String passwordAgain;

}
