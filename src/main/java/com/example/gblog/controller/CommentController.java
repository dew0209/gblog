package com.example.gblog.controller;

import com.example.gblog.common.lang.Result;
import com.example.gblog.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/comment")
public class CommentController {
    @Autowired
    CommentService commentService;

    @ResponseBody
    @PostMapping("/{id}")
    public Result addComment(@PathVariable("id")Integer postId,String review){
        if(postId == null)return Result.fail("未找到该文章");
        if(review == null || review.equals(""))return Result.fail("评论内容不能为空");
        commentService.addComment(postId,review);
        return Result.success();
    }
    @ResponseBody
    @PostMapping("/add")
    public Result addRe(Integer id,Integer postId,Integer replayId,Integer userId,String comment){
        commentService.addRe(id,postId,replayId,userId,comment);
        return Result.success("操作成功");
    }
}
