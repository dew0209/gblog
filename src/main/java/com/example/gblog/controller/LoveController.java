package com.example.gblog.controller;

import com.example.gblog.common.lang.Result;
import com.example.gblog.service.LoveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/love")
public class LoveController {

    @Autowired
    LoveService loveService;

    @ResponseBody
    @RequestMapping("/add")
    public Result add(Integer postId){
        loveService.add(postId);
        return Result.success();
    }

    @ResponseBody
    @RequestMapping("/remove")
    public Result remove(Integer postId){
        loveService.remove(postId);
        return Result.success();
    }


}
