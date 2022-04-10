package com.example.gblog.mapper;

import com.example.gblog.bean.Num;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

@Component
public interface NumMapper {
    Num getNumByUserId(@Param("id") Integer id);

    void add(@Param("userId") Integer id);

    void addReading(@Param("userId") Integer id);
}
