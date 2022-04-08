package com.example.gblog.mapper;

import com.example.gblog.vo.CommentVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;

@Component
public interface CommentMapper {
    void addComment(@Param("userId") Integer userId,@Param("postId") Integer postId,@Param("review") String review);

    List<CommentVo> getComment(@Param("id") Integer id);

    List<CommentVo> getReComment(@Param("replayId") Integer id,@Param("id")Integer postId);

    void addRe(@Param("userId")Integer userId,@Param("id") Integer id,@Param("postId") Integer postId,@Param("replayId") Integer replayId,@Param("reId") Integer reId,@Param("comment") String comment,@Param("rId")Integer rId);

    List<Integer> getFloorIds(@Param("reId") Integer integer);

    void changeStatus(@Param("id") Integer integer);
}
