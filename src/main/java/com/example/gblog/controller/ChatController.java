package com.example.gblog.controller;

import com.example.gblog.bean.Chat;
import com.example.gblog.bean.User;
import com.example.gblog.common.lang.Result;
import com.example.gblog.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/chat")
public class ChatController {
    @Autowired
    UserService userService;
    @ResponseBody
    @RequestMapping("/show")
    public Result chat(){
        //获取当前用户的信息。不获取聊天信息，需要获取聊天记录，应该为点击发消息，才获取对应消息的记录，不使用sessionstore，单纯数据库开搞，开冲。
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return Result.fail("未登录");
        return Result.success(user);
    }
    @ResponseBody
    @RequestMapping("/mess")
    public Result mess(Integer id){
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return Result.fail("未登录");
        User byId = userService.getById(id);
        Chat chat = new Chat();
        chat.setUserId(user.getId());
        chat.setToUserId(id);
        chat.setAvatar(byId.getAvatar());
        chat.setToUserName(byId.getUsername());
        return Result.success(chat);
    }
}
