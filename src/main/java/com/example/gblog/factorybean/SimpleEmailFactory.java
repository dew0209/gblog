package com.example.gblog.factorybean;


import com.example.gblog.common.lang.Const;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.SimpleEmail;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class SimpleEmailFactory {
    public SimpleEmail getObject() throws Exception {
        log.info("创建邮件对象");
        SimpleEmail simpleEmail = new SimpleEmail();
        //yvqqfkqvfxrhhhhh
        simpleEmail.setHostName("smtp.qq.com");
        simpleEmail.setCharset("utf-8");
        simpleEmail.setFrom(Const.EMAIL);
        simpleEmail.setAuthenticator(new DefaultAuthenticator(Const.EMAIL,"ebdypxafugcnibaf"));
        simpleEmail.setSSLOnConnect(true);
        simpleEmail.setSubject("离客验证码");
        return simpleEmail;
    }

    public Class<?> getObjectType() {
        return SimpleEmail.class;
    }

    public boolean isSingleton() {
        return false;
    }
}
