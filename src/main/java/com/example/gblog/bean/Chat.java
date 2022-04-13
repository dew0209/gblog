package com.example.gblog.bean;

import lombok.Data;

@Data
public class Chat {
    private Integer userId;
    private Integer toUserId;
    private String avatar;
    private String toUserName;
}
