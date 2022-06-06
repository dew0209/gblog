package com.example.gblog.controller;

import com.example.gblog.bean.Chat;
import com.example.gblog.bean.HisMessage;
import com.example.gblog.bean.User;
import com.example.gblog.common.lang.Result;
import com.example.gblog.service.ChatService;
import com.example.gblog.service.UserService;
import com.example.gblog.util.RedisUtil;
import lombok.Data;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.*;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    ChatService chatService;

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
        String key = "chat_" + user.getId();
        String listStr = "";
        if(redisUtil.hasKey(key)){
            listStr = (String) redisUtil.get(key);
        }
        //联系人列表
        String[] ids = listStr.split(",");
        ArrayList<User> users = new ArrayList<>();
        for (String idStr : ids) {
            if(idStr.equals(""))continue;
            User byId = userService.getById(Integer.parseInt(idStr));
            users.add(byId);
        }

        if(listStr == null || "".equals(listStr)){
            listStr = "" + id;
            User byId = userService.getById(id);
            users.add(byId);
        }else {
            boolean ok = false;
            for (String s : ids) {
                if(s.equals(String.valueOf(id)))ok = true;
            }
            if(!ok) {
                listStr += "," + id;
                User byId = userService.getById(id);
                users.add(byId);
            }
        }
        redisUtil.set(key,listStr,7 * 60);
        return Result.success(users);
    }

    @ResponseBody
    @PostMapping("/his")
    public Result his(Integer id){
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return Result.fail("未登录");
        chatService.updateSt(id,user.getId(),1);
        Integer desId = user.getId();
        //1代表左边，2代表右边
        //自己的 设置为2
        List<HisMessage> res = chatService.getHis(desId,id);
        for (HisMessage re : res) {
            re.setLoc(2);
        }
        List<HisMessage> res1 = chatService.getHis(id,desId);
        for (HisMessage re : res1) {
            re.setLoc(1);
        }
        res.addAll(res1);
        res.sort(new Comparator<HisMessage>() {
            @Override
            public int compare(HisMessage o1, HisMessage o2) {
                Date hisTime1 = o1.getHisTime();
                Date hisTime2 = o2.getHisTime();
                if(hisTime1.getTime() - hisTime2.getTime() > 0)return -1;
                return 1;
            }
        });
        List<HisMessage> hisMessages = res.subList(0, Math.min(9,res.size() - 1) + 1);
        Collections.reverse(hisMessages);
        return Result.success(hisMessages);
    }
}
