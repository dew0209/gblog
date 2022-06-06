package com.example.gblog.bean;

import lombok.Data;

import java.util.Date;

@Data
public class HisMessage {
    private String mess;
    private Integer loc;
    private Date hisTime;
}
