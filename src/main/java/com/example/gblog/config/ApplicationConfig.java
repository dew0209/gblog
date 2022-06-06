package com.example.gblog.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class ApplicationConfig extends WebMvcConfigurerAdapter{
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        //Windows下
        registry.addResourceHandler("/upload/**").addResourceLocations("file:///D:/workspace/workspaceideaj/gblog/upload/");

        super.addResourceHandlers(registry);
    }
}
