package com.example.gblog.controller;

import com.example.gblog.common.lang.Result;
import com.example.gblog.service.CommentService;
import com.example.gblog.service.PostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/comment")
@Slf4j
public class CommentController {
    @Autowired
    CommentService commentService;
    @Autowired
    PostService postService;

    @ResponseBody
    @PostMapping("/{id}")
    public Result addComment(@PathVariable("id")Integer postId,String review){
        if(postId == null)return Result.fail("未找到该文章");
        if(review == null || review.equals(""))return Result.fail("评论内容不能为空");
        commentService.addComment(postId,review);
        postService.addReviewCount(postId);
        return Result.success();
    }
    @ResponseBody
    @PostMapping("/add")
    public Result addRe(Integer id,Integer postId,Integer replayId,Integer userId,String comment,Integer rId){
        System.out.println(11111);
        System.out.println(postId);
        //添加评论或者回复
        commentService.addRe(id,postId,replayId,userId,comment,rId);
        //更新评论和回复数量
        postService.addReviewCount(postId);
        return Result.success("操作成功");
    }
    @ResponseBody
    @PostMapping("/del")
    public Result delComment(Integer id,Integer postId){
        log.info(String.valueOf(id));
        commentService.del(id,postId);
        return Result.success("操作成功");
    }

}
