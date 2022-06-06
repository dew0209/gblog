package com.example.gblog.config;

import com.jagregory.shiro.freemarker.ShiroTags;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Configuration
public class ShiroFreemarkerConfig {
    @Autowired
    private freemarker.template.Configuration configuration;

    @PostConstruct
    public void setUp() {
        configuration.setSharedVariable("shiro", new ShiroTags());
    }
}
