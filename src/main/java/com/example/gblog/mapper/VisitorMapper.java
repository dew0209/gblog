package com.example.gblog.mapper;

import com.example.gblog.bean.Visitor;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface VisitorMapper {

    List<Visitor> getByUserId(@Param("id") Integer id);
}
