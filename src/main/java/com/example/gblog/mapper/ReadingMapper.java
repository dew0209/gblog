package com.example.gblog.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface ReadingMapper {
    int getByPostIdAndUserId(@Param("postId") Integer postId,@Param("userId") Integer userId);

    void insert(@Param("postId") Integer postId,@Param("userId") Integer userId);
}
