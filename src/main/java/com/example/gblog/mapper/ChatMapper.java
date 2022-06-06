package com.example.gblog.mapper;

import com.example.gblog.bean.HisMessage;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface ChatMapper {
    void insert(@Param("userId") Integer id,@Param("toUserId") Integer toId,@Param("message") String messInfo);

    List<HisMessage> getHis(@Param("userId") Integer desId,@Param("toUserId") Integer id);

    void upState(@Param("a") int parseInt,@Param("b") int parseInt1,@Param("c") int i);
}
