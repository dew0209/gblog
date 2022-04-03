package com.example.gblog.vo;

import lombok.Data;

import java.util.Date;

@Data
public class BlogListVo {
    //博客主键
    private Integer postId;
    private Integer userId;
    //博客标题
    private String title;
    //头像地址
    private String avatar;
    //用户名
    private String username;
    //创建时间
    private Date created;
    //阅读量
    private Integer viewCount;
}
