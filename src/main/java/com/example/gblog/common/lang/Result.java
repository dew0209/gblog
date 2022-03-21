package com.example.gblog.common.lang;

import lombok.Data;

import java.io.Serializable;

@Data
public class Result implements Serializable {
    /* 状态码 200 404 这些 */
    private int status;
    /* 提示信息 */
    private String msg;
    /* 数据域 */
    private Object data;
    /* 跳转路径 */
    private String action;

    public static Result success(String msg,Object data){
        Result result = new Result();
        result.msg = msg;
        result.status = 0;
        result.data = data;
        return result;
    }
    public static Result success(Object data){
        return success("操作成功",data);
    }
    public static Result success(){
        return success("操作成功",null);
    }
    public static Result fail(String msg){
        Result result = new Result();
        result.msg = msg;
        result.status = -1;
        result.data = null;
        return result;
    }
    public Result action(String action){
        this.action = action;
        return this;
    }

}
