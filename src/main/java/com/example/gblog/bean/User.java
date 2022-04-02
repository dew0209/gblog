package com.example.gblog.bean;

import lombok.Data;

import java.util.Date;

/**
 *  id INT PRIMARY KEY AUTO_INCREMENT COMMENT "主键id",
 * 	username VARCHAR(20) NOT NULL COMMENT "用户名",
 * 	email VARCHAR(20) NOT NULL COMMENT "邮箱",
 * 	PASSWORD VARCHAR(255) NOT NULL COMMENT "密码",
 * 	SIGN VARCHAR(255) DEFAULT "这个人很懒，什么都没写" COMMENT "个性签名",
 * 	birthday DATETIME   DEFAULT "2000-01-01" COMMENT '生日',
 * 	created DATETIME   NOT NULL COMMENT '创建日期',
 * 	modified DATETIME   NULL COMMENT '最后修改时间',
 * 	qqnum  VARCHAR(20) DEFAULT "未设置",
 * 	STATUS INT DEFAULT '0'
 */

@Data
public class User {
    //主键id
    private Integer id;
    //用户名
    private String username;
    //性别
    private String gender;
    //邮箱
    private String email;
    //个性签名
    private String sign;
    //头像链接
    private String avatar;
    //生日
    private Date birthday;
    //创建时间
    private Date created;
    //最后一次修改时间
    private Date modified;
    //qq号
    private String qqNum;
    //登录状态
    private Integer status;

}
