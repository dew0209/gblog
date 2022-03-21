package com.example.gblog.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.example.gblog.mapper")
public class MyBatisConfig {

}
