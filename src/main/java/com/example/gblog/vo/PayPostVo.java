package com.example.gblog.vo;

import lombok.Data;

import java.util.Date;

@Data
public class PayPostVo {
    //id 标题 时间 收 总
    private Integer id;
    private String title;
    private Date date;
    private String price;
    private Integer getNum;
    private Integer allNum;
}
