package com.example.gblog.controller;

import cn.hutool.crypto.SecureUtil;
import com.alipay.api.FileItem;
import com.example.gblog.bean.User;
import com.example.gblog.common.lang.Result;
import com.example.gblog.mapper.UserMapper;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.swing.plaf.multi.MultiMenuItemUI;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
@RequestMapping("/info")
public class UserInfoController {
    @Value("${upload}")
    String path;

    @Autowired
    UserMapper userMapper;

    @RequestMapping("/{id}")
    public String getInfo(@PathVariable("id")String id, HttpServletRequest request){
        //获取用户信息
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        request.setAttribute("infoUser",user);
        return "/info";
    }

    @PostMapping("/avatar")
    public String updateAvatar(String avatar_data, MultipartFile avatar_file,HttpServletRequest request) throws IOException {
        System.out.println(avatar_data);
        System.out.println(avatar_file.getBytes().length);
        //更新用户的头像信息
        System.out.println(path);
        String avatar = UUID.randomUUID() + avatar_file.getOriginalFilename();
        //获得当前登录用户的信息
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer userId = user.getId();//获得用户id
        userMapper.updateAvatar("/upload/" + avatar,userId);
        user.setAvatar("/upload/" + avatar);
        //文件存储
        avatar_file.transferTo(new File(path + avatar));
        return "redirect:/info/1";
    }



    @ResponseBody
    @PostMapping("/setPas")
    public Result stPas(String oldpass,String newpass,String newpassAgain){
        if(oldpass == null || newpass == null || newpassAgain == null){
            return Result.fail("密码不能为空");
        }
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer id = user.getId();
        String ol = SecureUtil.md5(oldpass);
        int res = userMapper.getByIdAndPass(id,ol);
        if(res != 1){
            return Result.fail("密码验证失败");
        }
        if(!newpass.equals(newpassAgain)){
            return Result.fail("两次密码输入不一致");
        }
        String nl = SecureUtil.md5(newpass);
        userMapper.setNePass(id,nl);
        return Result.success().action("/info/" + id);
    }
    @ResponseBody
    @PostMapping("/setBase")
    public Result setBase(String username,String sign){
        if(username == null || sign == null){
            return Result.fail("不能设置为空");
        }
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        Integer id = user.getId();

        userMapper.setNeBase(id,username,sign);
        user.setUsername(username);
        user.setSign(sign);
        return Result.success().action("/info/" + id);
    }
}
