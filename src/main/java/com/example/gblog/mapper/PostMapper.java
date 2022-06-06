package com.example.gblog.mapper;

import com.example.gblog.bean.Post;
import com.example.gblog.vo.BlogListVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface PostMapper {

    public List<Post> getPost(@Param("st") int pn, @Param("size") int pnSize);

    List<Post> getPostById(@Param("st") int pn, @Param("size") int pnSize,@Param("id") int id);

    int getTotalByStatus(@Param("id") Integer id,@Param("status") Integer status);

    List<Post> getByStatusAndId(@Param("id") Integer id,@Param("status") int i,@Param("st") int i1,@Param("size") Integer pnSize);

    List<BlogListVo> getPostNoPay(@Param("st") int i, @Param("size") Integer size,@Param("key") String key);

    int getTotalNoPay(@Param("key") String key);

    void addBlogNoPay(@Param("newPost") Post newPost, @Param("type") int i, @Param("userId") Integer id);

    Post getById(@Param("id") Integer id);

    void addReviewCount(@Param("id") Integer postId);

    void subReviewCount(@Param("id")Integer postId);

    void update(@Param("post") Post post);

    void del(@Param("id") Integer id);

    void updateViewCount(@Param("postId") Integer id);
}
