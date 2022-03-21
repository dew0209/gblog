package com.example.gblog.config;

import cn.hutool.core.map.MapUtil;
import com.example.gblog.shiro.AccountRealm;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import sun.net.httpserver.AuthFilter;

import java.util.LinkedHashMap;
import java.util.Map;


@Slf4j
@Configuration
public class ShiroConfig {

    @Bean
    public SecurityManager securityManager(AccountRealm accountRealm){
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        securityManager.setRealm(accountRealm);
        log.info("注入成功");
        return securityManager;
    }
    @Bean
    public ShiroFilterFactoryBean shiroFilterFactoryBean(SecurityManager securityManager){
        ShiroFilterFactoryBean filterFactoryBean = new ShiroFilterFactoryBean();
        filterFactoryBean.setSecurityManager(securityManager);
        // 配置登录的url和登录成功的url
        filterFactoryBean.setLoginUrl("/user/login");
        filterFactoryBean.setSuccessUrl("/");
        // 配置未授权跳转页面
        filterFactoryBean.setUnauthorizedUrl("/error");

        Map<String, String> hashMap = new LinkedHashMap<>();

        /*hashMap.put("/login", "anon");
        hashMap.put("/user/home", "authc");
        hashMap.put("/user/set", "authc");
        hashMap.put("/user/upload", "authc");
        //filterFactoryBean.setFilters(MapUtil.of("auth",authFilter()));
        hashMap.put("/collection/find", "auth");
        hashMap.put("/collection/add", "auth");
        hashMap.put("/collection/remove", "auth");*/

        filterFactoryBean.setFilterChainDefinitionMap(hashMap);

        return filterFactoryBean;
    }
}
