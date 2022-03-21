package com.example.gblog.config;

import com.example.gblog.common.lang.Const;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EmailConfig {

    @Bean
    public SimpleEmail simpleEmail() throws EmailException {
        System.out.println("11111111111");
        SimpleEmail simpleEmail = new SimpleEmail();
        //
        //yvqqfkqvfxrhhhhh
        simpleEmail.setHostName("smtp.qq.com");
        simpleEmail.setCharset("utf-8");
        simpleEmail.setFrom(Const.EMAIL);
        simpleEmail.setAuthenticator(new DefaultAuthenticator(Const.EMAIL,"yvqqfkqvfxrhhhhh"));
        simpleEmail.setSSLOnConnect(true);
        simpleEmail.setSubject("离客验证码");
        return simpleEmail;
    }
}
