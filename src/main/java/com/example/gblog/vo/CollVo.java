package com.example.gblog.vo;

import lombok.Data;

import java.util.Date;

@Data
public class CollVo {
    private String postId;
    private String userId;
    private String typeName;
    private String username;
    private Date date;
    private String title;

}
