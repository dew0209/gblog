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
import com.example.gblog.bean.Order;
import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.common.lang.Result;
import com.example.gblog.mapper.PayPostMapper;
import com.example.gblog.service.*;
import com.example.gblog.vo.BlogListVo;
import com.example.gblog.vo.CommentVo;
import com.example.gblog.vo.PageVo;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/yui")
public class PayPostController {
    String str = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCR5qBvU0+QgFvD3x/REpIPXQLAnaFQ/GW/r51es4RlVSQd4ZPPZ0GSh2EZWsna6B5H3uAJv50brXbuccZdBXgXljs5/a/I2Jc5CGzGetqcJ5R83tZftSZfubowR5c55F1UGO5WMQsynb8q4f87tKvEg87x2RiUWlql/sQlEBbOj/VR12N4rTuQggTvi565He26qmm0fk49wR4s3sMwqFCkftTif+0qsU09eunjTi+QfbYFx3TrU6tG211Y21fxYFsZ7Q6I/RxFhfMq1l/hwd04+tDA8ck4BlXQOnS1iAHY1ZA48bmiO2X5SCGeIW3Bc7mS/PLNKkJfQUb+wlSclpHVAgMBAAECggEAcPRuLQIAzUyyvrgVd9W6wq4tnVXsODjPxVF+snyk+Zaq+X9U4fN87qZk5C5HrHScTOQd6y4vwefP9dabzhSX3xruC31+BC67FOqS3C7s5Iw4B1y19y7V4LJ3lT03tRg5sQwEKTKbCrrZ76c75MuBWAj7xH1g7CnvmCffTxpfrdbWsyps4wjaBC/doYtP2KnQyggNTiE5Y3/i8LNhgugh1I0j/av2m40cAY4Uz/KBcyUWUFJLiD7ejrX651FvNANKl0rLvhfB+Hv7Hskz8FxzDIwYhoMWO1v+Kjf7o9bS6fm/lZ65e4xlzVdjj7dnx/Ig3Z/Ph7lGrxmtrF9m7WYuQQKBgQDFcQ/M3WaBNRg1yNXQF0rBd55tXcsPTU6bL3mXiYfJt4c1Qe3G46ScYTKbXMcLd4ovIAac5UKOnwzm0CEZeORQN+A1A++X5NryE6ovuIBm5HtG4czHg2jaWhrw0oKZJcO/Dzpu49OW7o4VtRRnLRouoUpTBA7u/zxtJDXkRk0VPQKBgQC9LEkL07Tv6kh4IQEE1NETo/eYU0bR5ELPHSFESJ2z8DtcsGyW1euQbKoyvqM6OposYjkwxZU9e9tzwKPuGSG0TxO6ADoMcbZHKLBlwceyST2rODM4oP88mmjofEWLP0qkWgzzCoC06EpA1RX9NUrgWJKZc2OlbwMum7TGu44oeQKBgChaDRKfhR2PDl2fqCMZP4v+uIA9lQyRjiklMMKJtxjAy39U9BWb3L6hFsit03hCfBlZgEB8kne3hdl+W+Vq0a6bXNU48rSmbyDeZ//Mw2FD/PXlnAaCkuFdXPgu7cYC89iOcjDLmyjTpHJHSd40V4+EIz6IK80omN7tcZ4vx/05AoGAR/an1xLzWu0yIljTzWW0H5eZod3ULBZ8f9OiCxrgu0nhGzKWLI82bJuZ53H0IDuY2NeI0A/p5RjP8+nNss7mrnQCmhhp/L/pSoqlCCC+egk4p4Dao2lDj2diD0bvIbizCXCkSnStX6SaUq19DvUOBehL5Ior1wwzFrDvBUbmHmkCgYAb26/MZPIDvAqUGUpqJejsKQuTRLq4BfEwlFnAmGNNRW/x03uqBa1pq1tN/e1G3RwrxqX6SKbYo3mVOv3ocPOShwKS7+RKcEUUMJFtFaiIEJ4+Bbo/OMGBSrvVJFtmWLs+Kd1qZ53DOI5PAPmirmGzwEe8kTQfDio6dvkgqPK35A==";
    String str1 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmNIdQQG44I5eOqd79n31hSbcmfkXQlT+recYvuGFFCMqeIl7tQKTE9jkbnV5gnMLiMPy3yfoFxxHnKhQmzJYDA472Jk1rioD8jr31HnAMgIGg2s2Hvq16TNqt9tbTaa7S2MfQlYuoi0tfgqKJzjzsmPWR8jm5Id7nVeeZFiIKpI17UiwH10nx31Cf+qxytbhs18s5dINg3j1sjDq11tBTiXutKUbAdowXojmsJyi8DsO0pN/5gg5MKT0CmMNIph+XslHTraTEZrdoVBbYIGbDPwFZan6aUGxuSIFxiWoj1MYmZ3hcE8IncIZ+n38/a+/fji5yAzr75vbkdEpMOfJxQIDAQAB";
    @Autowired
    PayPostService payPostService;
    @Autowired
    CommentService commentService;
    @Autowired
    OrderService orderService;
    @Autowired
    LoveService loveService;
    @Autowired
    CollService collService;
    @ResponseBody
    @PostMapping("/add")
    public Result add(String title,String content,String keywords,Integer price,String introduce){
        Post newPost = new Post();
        newPost.setContent(content);
        newPost.setTitle(title);
        String[] keys = keywords.split(",");
        if(0 < keys.length)newPost.setKeywords1(keys[0]);
        if(1 < keys.length)newPost.setKeywords2(keys[1]);
        if(2 < keys.length)newPost.setKeywords3(keys[2]);
        //设置价格
        newPost.setPrice(price);
        //设置内容
        newPost.setContent(content);
        //设置创建时间，请调用数据库函数now()
        //设置修改时间，请调用数据库函数now()
        //设置三个不同的数据  访问量，评论数量，收藏数量
        newPost.setViewCount(0);
        newPost.setReviewCount(0);
        newPost.setCollectCount(0);
        //介绍，只针对付费，非付费设置为null
        newPost.setIntroduce(introduce);
        //type=1,userId=profile.getId()
        payPostService.add(newPost);
        return Result.success();
    }


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
    public String pay(Integer postId,Integer price) throws AlipayApiException {
        //确保登录
        User user = (User)SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return "error";

        //该笔交易存在且未完成，不再计入
        Order res = orderService.getByOrderId(postId);
        if(res != null)if(res.getStatus() == 1)return "error";
        Post byId = payPostService.getById(postId);
        if(user.getId() == byId.getUser().getId())return "error";
        if(byId.getPrice() != price)return "error";
        System.out.println(postId +"===" + price);
        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipaydev.com/gateway.do","2021000119660061",str,"json","utf-8",str1,"RSA2");
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        String tradeNo = System.currentTimeMillis() + "";
        System.out.println(tradeNo);
        String body = "";
        request.setBizContent("{\"out_trade_no\":\""+ tradeNo +"\","
                + "\"total_amount\":\""+ price +"\","
                + "\"subject\":\""+ "支付博客" +"\","
                + "\"body\":\""+ body +"\","
                + "\"timeout_express\":\"10m\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");
        //回调地址去完成业务逻辑
        request.setNotifyUrl("http://eureka7001.com:8080/yui/payreturn");
        request.setReturnUrl("http://eureka7001.com:8080/yui/payreturn");

        AlipayTradePagePayResponse response = alipayClient.pageExecute(request);
        if(response.isSuccess()){
            //将该笔交易存储到数据库中，状态为未支付状态
            if(res == null){
                orderService.addPayNo(price,tradeNo,user.getId(),postId);
            }
        }
        String form = response.getBody();
        System.out.println(form);
        return form;
    }
    @RequestMapping("/payreturn")
    public String returnPay(HttpServletRequest request){
        String tradeNo = request.getParameter("trade_no");//支付宝交易号  例如：2022040922001408460505827163
        String totalAmount = request.getParameter("total_amount");//交易金额
        String outTradeNo	 = request.getParameter("out_trade_no");
        orderService.addRealPay(totalAmount,outTradeNo,tradeNo);
        Order order = orderService.getByOutTradeNo(outTradeNo);
        //返回到对应的付费博客页面，进行解锁。
        if (order == null) return "error";
        return "redirect:http://localhost:8080/yui/post/blog/" + order.getPostId();
    }
    @GetMapping("/post/blog/{id}")
    public String detail(@PathVariable("id")Integer id,HttpServletRequest request){
        Post post = payPostService.getById(id);
        List<CommentVo> comment = commentService.getComment(id);
        request.setAttribute("post",post);
        request.setAttribute("comment",comment);
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return "showPay";
        Integer loveSUm = loveService.getById(id);
        Integer collSum = collService.getById(id);
        if(loveSUm != 0)
            request.setAttribute("love",loveSUm);
        if(collSum != 0)
            request.setAttribute("coll",collSum);
        return "showPay";
    }
    @RequestMapping("/updateTo/{id}")
    public String updateTo(@PathVariable("id") Integer id,HttpServletRequest request){
        //查询登录状态
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return "error";
        Post post = payPostService.getById(id);
        if (post.getUser().getId() != user.getId())return "error";
        String str = "";
        if (post.getKeywords1() != null)str += post.getKeywords1() + ",";
        if (post.getKeywords2() != null)str += post.getKeywords2() + ",";
        if (post.getKeywords3() != null)str += post.getKeywords3();
        if(str.charAt(str.length() - 1) == ',')str = str.substring(0,str.length() - 2);
        post.setKeywords(str);
        request.setAttribute("post",post);
        return "updatePay";
    }
    @ResponseBody
    @PostMapping("/update")
    public Result updateA(Integer id,String title,String content,String keywords,Integer price,String introduce){
        Post newPost = payPostService.getById(id);
        newPost.setContent(content);
        newPost.setTitle(title);
        String[] keys = keywords.split(",");
        if(0 < keys.length)newPost.setKeywords1(keys[0]);
        if(1 < keys.length)newPost.setKeywords2(keys[1]);
        if(2 < keys.length)newPost.setKeywords3(keys[2]);
        newPost.setPrice(price);
        newPost.setContent(content);
        newPost.setIntroduce(introduce);
        payPostService.update(newPost);
        return Result.success();
    }
    @RequestMapping("/del/{id}")
    public String del(@PathVariable("id") Integer id){
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(user == null)return "error";
        Integer userId = user.getId();
        Post byId = payPostService.getById(id);
        if(byId.getUser().getId() != userId)return "error";
        payPostService.del(id);
        return "redirect:/yui/1";
    }

}
