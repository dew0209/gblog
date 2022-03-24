package com.example.gblog.controller;

import com.example.gblog.bean.Post;
import com.example.gblog.common.lang.Result;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    /* 主页的文章展示 */
    @RequestMapping("/get/more")
    @ResponseBody
    public Result getMore(int pn,int pnSize){
        PageVo<Post> res = postService.getPost(pn,pnSize);
        //直接返回数据即可
        return Result.success(res.getList());
    }
}
