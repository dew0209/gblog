package com.example.gblog.mapper;

import com.example.gblog.bean.Post;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface PostMapper {

    public List<Post> getPost(@Param("st") int pn, @Param("size") int pnSize);
}
