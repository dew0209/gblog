package com.example.gblog.controller;

import cn.hutool.crypto.SecureUtil;
import com.example.gblog.common.lang.Const;
import com.example.gblog.common.lang.Result;
import com.example.gblog.service.UserService;
import com.example.gblog.util.RedisUtil;
import com.example.gblog.vo.RegisterVo;
import com.google.code.kaptcha.Producer;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.SimpleEmail;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/*
* 用户控制层：
*   登录
*   注册
*   找回密码
*   邮箱注册
* */
@Slf4j
@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private SimpleEmail simpleEmail;
    @Autowired
    private UserService userService;

    @Autowired
    Producer producer;

    @Autowired
    RedisUtil redisUtil;

    /**
     *
     * @param registerUser  注册的用户
     * @param verify        验证码
     * @return
     */
    @ResponseBody
    @PostMapping("/register")
    public Result register(RegisterVo registerUser,String verify){
        //检查数据的合法性
        String password = registerUser.getPassword();
        registerUser.setPassword(SecureUtil.md5(password));
        System.out.println(registerUser);
        System.out.println(registerUser.getUsername());
        userService.register(registerUser);
        return Result.success();
    }
    @ResponseBody
    @GetMapping("/verify")
    public Result verify(String email) throws EmailException {
        //判断是否恶意攻击服务器
        //从redis中获取   [邮箱+验证码组成方式]
        //获取验证码
        String text = producer.createText();
        simpleEmail.addTo(email);
        simpleEmail.setMsg(text);
        simpleEmail.send();
        return Result.success();
    }
    @ResponseBody
    @PostMapping("/login")
    public Result verify(String email,String password){
        UsernamePasswordToken token = new UsernamePasswordToken(email, SecureUtil.md5(password));
        try{
            SecurityUtils.getSubject().login(token);
        }catch (AuthenticationException e) {
            if (e instanceof UnknownAccountException) {
                return Result.fail("用户不存在");
            } else if (e instanceof LockedAccountException) {
                return Result.fail("用户被禁用");
            } else if (e instanceof IncorrectCredentialsException) {
                return Result.fail("密码错误");
            } else {
                return Result.fail("用户认证失败");
            }
        }

        return Result.success().action("/");
    }
    @RequestMapping("/logout")
    public String logout(){
        SecurityUtils.getSubject().logout();
        return "/";
    }
}
