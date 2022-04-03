package com.example.gblog.controller;

import com.example.gblog.bean.Post;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
/*
* 只处理普通博客的请求，不处理付费。
* */
@Controller
@RequestMapping("/post")
public class PostController {
    @Autowired
    PostService postService;

    @GetMapping("/{id}")
    public String index(@PathVariable(value = "id",required = false)Integer pn, HttpServletRequest request){
        if(pn == null)pn = 1;
        PageVo<BlogListVo> res = postService.getPostNoPay(pn,20);
        request.setAttribute("res",res);
        return "blog";
    }
    @GetMapping("/write")
    public String write(){
        return "write";
    }
}
