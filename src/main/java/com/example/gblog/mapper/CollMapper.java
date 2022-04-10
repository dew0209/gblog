package com.example.gblog.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface CollMapper {
    void add(@Param("postId") Integer postId, @Param("userId") Integer userId);

    void remove(@Param("postId") Integer postId,@Param("userId") Integer userId);

    Integer getById(@Param("postId") Integer postId,@Param("userId") Integer userId);

    void delByPostId(@Param("postId") Integer id);
}
