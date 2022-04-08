package com.example.gblog.controller;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.domain.AlipayTradePrecreateModel;
import com.alipay.api.domain.AlipayTradeWapPayModel;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradePrecreateRequest;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import com.alipay.api.response.AlipayTradePrecreateResponse;
import com.alipay.api.response.AlipayTradeWapPayResponse;
import com.example.gblog.bean.Post;
import com.example.gblog.common.lang.Result;
import com.example.gblog.mapper.PayPostMapper;
import com.example.gblog.service.CommentService;
import com.example.gblog.service.PayPostService;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CommentVo;
import com.example.gblog.vo.PageVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/yui")
public class PayPostController {
    String str = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCR5qBvU0+QgFvD3x/REpIPXQLAnaFQ/GW/r51es4RlVSQd4ZPPZ0GSh2EZWsna6B5H3uAJv50brXbuccZdBXgXljs5/a/I2Jc5CGzGetqcJ5R83tZftSZfubowR5c55F1UGO5WMQsynb8q4f87tKvEg87x2RiUWlql/sQlEBbOj/VR12N4rTuQggTvi565He26qmm0fk49wR4s3sMwqFCkftTif+0qsU09eunjTi+QfbYFx3TrU6tG211Y21fxYFsZ7Q6I/RxFhfMq1l/hwd04+tDA8ck4BlXQOnS1iAHY1ZA48bmiO2X5SCGeIW3Bc7mS/PLNKkJfQUb+wlSclpHVAgMBAAECggEAcPRuLQIAzUyyvrgVd9W6wq4tnVXsODjPxVF+snyk+Zaq+X9U4fN87qZk5C5HrHScTOQd6y4vwefP9dabzhSX3xruC31+BC67FOqS3C7s5Iw4B1y19y7V4LJ3lT03tRg5sQwEKTKbCrrZ76c75MuBWAj7xH1g7CnvmCffTxpfrdbWsyps4wjaBC/doYtP2KnQyggNTiE5Y3/i8LNhgugh1I0j/av2m40cAY4Uz/KBcyUWUFJLiD7ejrX651FvNANKl0rLvhfB+Hv7Hskz8FxzDIwYhoMWO1v+Kjf7o9bS6fm/lZ65e4xlzVdjj7dnx/Ig3Z/Ph7lGrxmtrF9m7WYuQQKBgQDFcQ/M3WaBNRg1yNXQF0rBd55tXcsPTU6bL3mXiYfJt4c1Qe3G46ScYTKbXMcLd4ovIAac5UKOnwzm0CEZeORQN+A1A++X5NryE6ovuIBm5HtG4czHg2jaWhrw0oKZJcO/Dzpu49OW7o4VtRRnLRouoUpTBA7u/zxtJDXkRk0VPQKBgQC9LEkL07Tv6kh4IQEE1NETo/eYU0bR5ELPHSFESJ2z8DtcsGyW1euQbKoyvqM6OposYjkwxZU9e9tzwKPuGSG0TxO6ADoMcbZHKLBlwceyST2rODM4oP88mmjofEWLP0qkWgzzCoC06EpA1RX9NUrgWJKZc2OlbwMum7TGu44oeQKBgChaDRKfhR2PDl2fqCMZP4v+uIA9lQyRjiklMMKJtxjAy39U9BWb3L6hFsit03hCfBlZgEB8kne3hdl+W+Vq0a6bXNU48rSmbyDeZ//Mw2FD/PXlnAaCkuFdXPgu7cYC89iOcjDLmyjTpHJHSd40V4+EIz6IK80omN7tcZ4vx/05AoGAR/an1xLzWu0yIljTzWW0H5eZod3ULBZ8f9OiCxrgu0nhGzKWLI82bJuZ53H0IDuY2NeI0A/p5RjP8+nNss7mrnQCmhhp/L/pSoqlCCC+egk4p4Dao2lDj2diD0bvIbizCXCkSnStX6SaUq19DvUOBehL5Ior1wwzFrDvBUbmHmkCgYAb26/MZPIDvAqUGUpqJejsKQuTRLq4BfEwlFnAmGNNRW/x03uqBa1pq1tN/e1G3RwrxqX6SKbYo3mVOv3ocPOShwKS7+RKcEUUMJFtFaiIEJ4+Bbo/OMGBSrvVJFtmWLs+Kd1qZ53DOI5PAPmirmGzwEe8kTQfDio6dvkgqPK35A==";
    String str1 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmNIdQQG44I5eOqd79n31hSbcmfkXQlT+recYvuGFFCMqeIl7tQKTE9jkbnV5gnMLiMPy3yfoFxxHnKhQmzJYDA472Jk1rioD8jr31HnAMgIGg2s2Hvq16TNqt9tbTaa7S2MfQlYuoi0tfgqKJzjzsmPWR8jm5Id7nVeeZFiIKpI17UiwH10nx31Cf+qxytbhs18s5dINg3j1sjDq11tBTiXutKUbAdowXojmsJyi8DsO0pN/5gg5MKT0CmMNIph+XslHTraTEZrdoVBbYIGbDPwFZan6aUGxuSIFxiWoj1MYmZ3hcE8IncIZ+n38/a+/fji5yAzr75vbkdEpMOfJxQIDAQAB";
    @Autowired
    PayPostService payPostService;
    @Autowired
    CommentService commentService;
    @RequestMapping("/write")
    public String write(){
        return "writePay";
    }
    //获取所有的付费博客
    @GetMapping("/{id}")
    public String index(@PathVariable(value = "id",required = false)Integer pn, HttpServletRequest request){
        if(pn == null)pn = 1;
        PageVo<BlogListVo> res = payPostService.getPostPay(pn,20);
        request.setAttribute("res",res);
        return "blogPay";
    }
    @ResponseBody
    @PostMapping("/pay")
    public String pay(Integer postId,Double price) throws AlipayApiException {
        System.out.println(postId +"===" + price);
        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipaydev.com/gateway.do","2021000119660061",str,"json","utf-8",str1,"RSA2");
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        String body = "";
        request.setBizContent("{\"out_trade_no\":\""+ System.currentTimeMillis() +"\","
                + "\"total_amount\":\""+ price +"\","
                + "\"subject\":\""+ "测试" +"\","
                + "\"body\":\""+ body +"\","
                + "\"timeout_express\":\"10m\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");

        request.setNotifyUrl("http://eureka7001.com:8080/post/blog/29");
        request.setReturnUrl("http://eureka7001.com:8080/post/blog/29");

        AlipayTradePagePayResponse response = alipayClient.pageExecute(request);
        String form = response.getBody();
        System.out.println(form);
        return form;
    }
    @GetMapping("/post/blog/{id}")
    public String detail(@PathVariable("id")Integer id,HttpServletRequest request){
        Post post = payPostService.getById(id);
        List<CommentVo> comment = commentService.getComment(id);
        request.setAttribute("post",post);
        request.setAttribute("comment",comment);
        return "showPay";
    }
}
