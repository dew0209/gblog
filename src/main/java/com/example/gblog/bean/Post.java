package com.example.gblog.bean;

import lombok.Data;

import java.util.Date;

@Data
public class Post {
    private Integer id;
    private String title;
    private String keywords1;
    private String keywords2;
    private String keywords3;
    private Integer price;
    private String content;
    private Date created;
    private Date lastmd;
    private Integer viewCount;
    private Integer reviewCount;
    private Integer collectCount;
    private String introduce;

    private Type type;
    private User user;
}
