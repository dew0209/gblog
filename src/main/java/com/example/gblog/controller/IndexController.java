package com.example.gblog.controller;

import com.example.gblog.bean.Post;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class IndexController {
    @Autowired
    PostService postService;

    @RequestMapping({"/"})
    public String index(HttpServletRequest req){
        //获取第一页的数据，显示上去
        int pn = 1;
        int pnSize = 2;
        PageVo<Post> res = postService.getPost(pn,pnSize);
        req.setAttribute("pages",res);
        return "index";
    }
}
