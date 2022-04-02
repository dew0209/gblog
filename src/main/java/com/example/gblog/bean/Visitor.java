package com.example.gblog.bean;

import lombok.Data;

import java.util.Date;
@Data
public class Visitor {
    private Integer id;
    private Integer userId;
    private User visitorUser;
    private Date visitorTime;
}
