package com.example.gblog.config;

import com.example.gblog.common.lang.Const;
import com.example.gblog.factorybean.SimpleEmailFactory;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
@Slf4j
public class EmailConfig {

    @Bean
    public SimpleEmailFactory simpleEmail() throws EmailException {
        return new SimpleEmailFactory();
    }
}
