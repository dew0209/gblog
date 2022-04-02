package com.example.gblog.mapper;

import com.example.gblog.bean.Post;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface PostMapper {

    public List<Post> getPost(@Param("st") int pn, @Param("size") int pnSize);

    List<Post> getPostById(@Param("st") int pn, @Param("size") int pnSize,@Param("id") int id);

    int getTotalByStatus(@Param("id") Integer id,@Param("status") Integer status);

    List<Post> getByStatusAndId(@Param("id") Integer id,@Param("status") int i,@Param("st") int i1,@Param("size") Integer pnSize);
}
