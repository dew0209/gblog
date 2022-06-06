package com.example.gblog.bean;

import lombok.Data;

@Data
public class FromMess {
    private String fromUser;
    private String toId;
    private String message;
}
