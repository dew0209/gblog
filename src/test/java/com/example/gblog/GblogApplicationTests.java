package com.example.gblog;

import com.example.gblog.util.RedisUtil;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest

class GblogApplicationTests {

    @Autowired
    RedisUtil redisUtil;

    @Test
    public void aaa() {
        String o = (String) redisUtil.get("ly020922@aliyun.com");
        System.out.println(o);
    }

}
