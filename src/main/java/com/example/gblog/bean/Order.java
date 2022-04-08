package com.example.gblog.bean;

import lombok.Data;

@Data
public class Order {
    private Integer id;
    private String orderId;
    private Integer userId;
    private Integer postId;

}
