package com.example.gblog.bean;

import lombok.Data;

import java.util.Date;
import java.util.List;
//评论和回复
@Data
public class Comment {
    private Integer id;
    private String comment;
    private Integer postId;
    private Integer userId;
    private Integer replayId;
    private Date created;
    private Integer status;
}
