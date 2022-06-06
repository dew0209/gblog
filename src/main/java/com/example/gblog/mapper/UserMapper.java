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

    int hasEmail(@Param("email") String email);

    void updateAvatar(@Param("avatar") String avatar,@Param("userId") Integer userId);

    int getByIdAndPass(@Param("id") Integer id,@Param("olPass") String ol);

    void setNePass(@Param("id") Integer id,@Param("pass") String nl);

    void setNeBase(@Param("id") Integer id,@Param("username") String username,@Param("sign") String sign);

    Integer getBlSt(@Param("id") Integer id);

    Integer getBlNoPay(@Param("id") Integer id);

    Integer getBlogPay(@Param("id") Integer id);

    void setS1(@Param("id") Integer id);
    void setS2(@Param("id") Integer id);
    void setS3(@Param("id") Integer id);

    void setu1(@Param("id") Integer id);
    void setu2(@Param("id") Integer id);
    void setu3(@Param("id") Integer id);
}
