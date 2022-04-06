package com.example.gblog.vo;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class CommentVo {
    private Integer id;
    private String userName;
    private Integer userId;
    private String comment;
    private String avatar;
    private Date created;
    private Integer reId;
    private String reName;

    private List<CommentVo> reComm;
}
