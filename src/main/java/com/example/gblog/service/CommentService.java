package com.example.gblog.service;

import com.example.gblog.vo.CommentVo;

import java.util.List;

public interface CommentService {
    void addComment(Integer postId, String review);

    List<CommentVo> getComment(Integer id);

    void addRe(Integer id, Integer postId, Integer replayId, Integer userId, String comment,Integer rId);

    void del(Integer id,Integer postId);
}
