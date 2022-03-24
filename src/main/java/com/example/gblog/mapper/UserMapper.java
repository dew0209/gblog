package com.example.gblog.mapper;

import com.example.gblog.bean.User;
import com.example.gblog.vo.RegisterVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface UserMapper {

    Integer register(RegisterVo user);

    RegisterVo getUserByUsernameAndPassword(@Param("email") String email);
    User getById(@Param("id") Integer id);
    void updateStatus(@Param("email") String email,@Param("code") Integer code);
}
