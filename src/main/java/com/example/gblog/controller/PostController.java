package com.example.gblog.controller;

import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.common.lang.Result;
import com.example.gblog.service.CollService;
import com.example.gblog.service.CommentService;
import com.example.gblog.service.LoveService;
import com.example.gblog.service.PostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CommentVo;
import com.example.gblog.vo.PageVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/*
* 只处理普通博客的请求，不处理付费。
* */
@Controller
@RequestMapping("/post")
public class PostController {
    @Autowired
    PostService postService;
    @Autowired
    CommentService commentService;
    @Autowired
    LoveService loveService;
    @Autowired
    CollService collService;
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

    @ResponseBody
    @PostMapping("/add")
    public Result add(String title,String content,String keywords){
        System.out.println(title + "---" + content + "---" + keywords);
        if(title == null || "".equals(title))return Result.fail("标题不能为空");
        if(content == null || "".equals(content))return Result.fail("内容不能为空");
        if(keywords == null || "".equals(keywords))return Result.fail("关键字不能为空");
        postService.addBlogNoPay(title,content,keywords);
        return Result.success();
    }
    //获得具体的博客
    @GetMapping("/blog/{id}")
    public String showDetail(@PathVariable("id") Integer id,HttpServletRequest request){
        Post post = postService.getById(id);
        List<CommentVo> comment = commentService.getComment(id);
        request.setAttribute("post",post);
        request.setAttribute("comment",comment);
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return "show";
        Integer loveSUm = loveService.getById(id);
        Integer collSum = collService.getById(id);

        if(loveSUm != 0)
            request.setAttribute("love",loveSUm);
        if(collSum != 0)
            request.setAttribute("coll",collSum);
        return "show";
    }
}
