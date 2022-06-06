package com.example.gblog.controller;

import cn.hutool.crypto.SecureUtil;
import com.example.gblog.bean.Num;
import com.example.gblog.bean.Post;
import com.example.gblog.bean.User;
import com.example.gblog.bean.Visitor;
import com.example.gblog.common.lang.Result;
import com.example.gblog.factorybean.SimpleEmailFactory;
import com.example.gblog.service.*;
import com.example.gblog.util.RedisUtil;
import com.example.gblog.vo.CollVo;
import com.example.gblog.vo.PageVo;
import com.example.gblog.vo.PayPostVo;
import com.example.gblog.vo.RegisterVo;
import com.google.code.kaptcha.Producer;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.mail.SimpleEmail;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/*
* 用户控制层：
*   登录
*   注册
*   找回密码
*   邮箱注册
*   只针对博主的类，针对其他用户会单独抽出来
* */
@Slf4j
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    SimpleEmailFactory simpleEmailFactory;

    @Autowired
    private UserService userService;

    @Autowired
    Producer producer;

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    NumService numService;

    @Autowired
    VisitorService visitorService;
    @Autowired
    PostService postService;
    @Autowired
    PayPostService payPostService;

    @Value("${upload}")
    String path;


    /**
     *
     * @param registerUser  注册的用户
     * @param verify        验证码
     * @return
     *
     *
     * log:
     *      邮件对象不要使用单例，一次发送邮件一个对象，多例的。
     *      初步测试成功
     *
     */
    @ResponseBody
    @PostMapping("/register")
    public Result register(RegisterVo registerUser,String verify){
        //前置检查  邮箱   用户名  密码  验证码  三者不能为空
        if (registerUser.getEmail() == null)return Result.fail("邮箱不能为空");
        //判断用户是否已经注册过了
        if(userService.hasEmail(registerUser.getEmail()))return Result.fail("用户已经存在");
        if (registerUser.getUsername() == null)return Result.fail("用户名不能为空");
        if (registerUser.getPassword() == null)return Result.fail("密码不能为空");
        if (verify == null)return Result.fail("验证码不能为空");
        //从redis中获取验证码
        String rellV = (String) redisUtil.get(registerUser.getEmail());
        //比较用户输入过来的验证码和redis中的验证码是否一致
        if (rellV == null || !rellV.equals(verify))return Result.fail("验证码不正确");
        String password = registerUser.getPassword();
        //对密码进行md5的加密
        registerUser.setPassword(SecureUtil.md5(password));
        //进行注册
        userService.register(registerUser);
        //数据初始化
        numService.add(registerUser.getId());
        return Result.success();
    }
    /*
    * 邮箱发送验证码
    * 验证邮箱布恩那个为空
    *   从redis获取，如果已经最近一分钟已经发送过验证码，则提示："尝试频繁，请稍后再试！"
    *
    *   否则继续发送：
    *       利用com.google.code kaptcha生成验证码，注意，这个再maven仓库中没有，需要自己手动安装
    *       利用org.apache.commons commons-email发送验证码
    *       将生成的验证码存储到redis中，set存储，过期时间为15分钟。注意多次发送也要刷新存储时间
    * */
    @ResponseBody
    @GetMapping("/verify")
    public Result verify(String email) throws Exception {
        if (email == null || "".equals(email))return Result.fail("邮箱不能为空");
        //一分钟间隔设置
        boolean ok = redisUtil.hasKey(email);
        if (ok){
            long expire = redisUtil.getExpire(email);
            if(15 * 60 - expire < 60)return Result.fail("尝试频繁，请稍后再试！");
        }
        //发送邮件验证码
        SimpleEmail simpleEmail = simpleEmailFactory.getObject();
        //获取验证码，发送验证码
        String text = producer.createText();
        simpleEmail.addTo(email);
        simpleEmail.setMsg(text);
        simpleEmail.send();
        //将验证码存储到redis中，设置过期时间为15分钟
        redisUtil.set(email,text,15*60);
        return Result.success();
    }
    /*
    * 登录
    * */
    @ResponseBody
    @PostMapping("/login")
    public Result verify(String email, String password, HttpSession session){
        UsernamePasswordToken token = new UsernamePasswordToken(email, SecureUtil.md5(password));
        try{
            SecurityUtils.getSubject().login(token);
        }catch (AuthenticationException e) {
            if (e instanceof UnknownAccountException) {
                return Result.fail("用户不存在");
            } else if (e instanceof LockedAccountException) {
                return Result.fail("用户被禁用");
            } else if (e instanceof IncorrectCredentialsException) {
                return Result.fail("密码错误");
            } else {
                return Result.fail("用户认证失败");
            }
        }
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        session.setAttribute("userId",user.getId() + "");
        Integer blSt = userService.getBlSt(user.getId());
        //如果在线，怎么干掉
        if(blSt == 1)return Result.fail("用户被禁用");
        return Result.success(user).action("/");
    }
    /*
    * 退出
    * */
    @RequestMapping("/logout")
    public String logout(){
        SecurityUtils.getSubject().logout();
        return "redirect:/index";
    }
    /*
    * 查询用户信息
    *   需要返回：用户基本信息 关注数 阅读量 粉丝数 最近9个访问（不足9个实际获取即可）
    * */
    @GetMapping("/{id}")
    public String userPage(@PathVariable("id")Integer id, HttpServletRequest request){
        //获取用户的基本信息
        User user = userService.getById(id);
        if(user == null)return "error";
        request.setAttribute("current_user",user);
        //从总阅读表获取数据
        Num nums = numService.getNumByUserId(id);
        request.setAttribute("nums",nums);
        //管理员处理
        User suadmin = (User) SecurityUtils.getSubject().getSession().getAttribute("profile");
        if(suadmin != null && suadmin.getId() == 7){
            //设置状态
            request.setAttribute("blogSt",userService.getBlSt(id));
            //设置博客
            request.setAttribute("blogNopay",userService.getBlNoPay(id));
            //设置付费
            request.setAttribute("blogPay",userService.getBlogPay(id));
        }
        //当前用户是不是这个所查询的用户
        if(suadmin != null){
            if(suadmin.getId() == id){
                request.setAttribute("isOwen",2);
            }else {
                request.setAttribute("isOwen",1);
            }
        }else {
            request.setAttribute("isOwen",1);

        }
        //获取最近9个访问者
        List<Visitor> visitors = visitorService.getByUserId(id);
        request.setAttribute("visitors",visitors);
        //获取第一页的数据，显示上去
        int pn = 1;
        int pnSize = 2;
        PageVo<Post> res = postService.getPostById(pn,pnSize,id);
        request.setAttribute("pages",res);
        request.setAttribute("current_id",id);
        return "person";
    }
    @ResponseBody
    @PostMapping("/get/more")
    public Result more(Integer pn,Integer pnSize,Integer id){
        PageVo<Post> res = postService.getPostById(pn,pnSize,id);
        return Result.success(res.getList());
    }
    @ResponseBody
    @RequestMapping("/f1")
    public Result f1(Integer pn,Integer pnSize,Integer id){
        PageVo<Post> res = postService.getPostByIdAnStaus(pn,pnSize,id);
        return Result.success(res);
    }

    /**
     *
     * @param pn  第几页
     * @param pnSize  页大小
     * @param id    用户id
     * @return
     */
    @ResponseBody
    @RequestMapping("/f2")
    public Result f2(Integer pn,Integer pnSize,Integer id){
        //查付费 无论status的状态
        PageVo<PayPostVo> list = payPostService.getByUserId(id,pn,pnSize);
        return Result.success(list);
    }
    @ResponseBody
    @RequestMapping("/f3")
    public Result f3(Integer pn,Integer pnSize,Integer id){
        //查付费 无论status的状态
        PageVo<CollVo> list = payPostService.getColl(id,pn,pnSize);
        return Result.success(list);
    }
    @ResponseBody
    @RequestMapping("/f4")
    public Result f4(Integer pn,Integer pnSize,Integer id){
        //查订单 无论status的状态
        PageVo<CollVo> list = payPostService.getCollOrder(id,pn,pnSize);
        return Result.success(list);
    }


    @RequestMapping("/s1")
    public String s1(Integer id){
        userService.stS1(id);
        return "redirect:/user/" + id;
    }
    @RequestMapping("/s2")
    public String s2(Integer id){
        userService.stS2(id);
        return "redirect:/user/" + id;
    }
    @RequestMapping("/s3")
    public String s3(Integer id){
        userService.stS3(id);
        return "redirect:/user/" + id;
    }
    @RequestMapping("/u1")
    public String u1(Integer id){
        userService.stu1(id);
        return "redirect:/user/" + id;
    }
    @RequestMapping("/u2")
    public String u2(Integer id){
        userService.stu2(id);
        return "redirect:/user/" + id;
    }
    @RequestMapping("/u3")
    public String u3(Integer id){
        userService.stu3(id);
        return "redirect:/user/" + id;
    }
}
