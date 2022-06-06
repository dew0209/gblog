package com.example.gblog.ws;

import com.alibaba.fastjson.JSONObject;
import com.example.gblog.bean.FromMess;
import com.example.gblog.bean.User;
import com.example.gblog.service.ChatService;
import com.example.gblog.util.SpringCtxUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.server.standard.SpringConfigurator;
import sun.misc.MessageUtils;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint(value = "/chatLJ",configurator = GetHttpSessionConfigurator.class)
@Component
public class ChatEndpoint {



    private static ConcurrentHashMap<String, Session> mess = new ConcurrentHashMap<>();

    public ChatEndpoint(){
        System.out.println("注入websocket！！！！！！！！！！！！！！！！");
    }

    /**
     * 用来给客户端发送消息
     */
    private Session session;

    /*建立时调用*/
    @OnOpen
    public void onOpen(Session session, EndpointConfig endpointConfig) {
        System.out.println("建立连结");
        HttpSession httpSession = (HttpSession) endpointConfig.getUserProperties().get(HttpSession.class.getName());
        String userId = (String)httpSession.getAttribute("userId");
        mess.put(userId + "",session);
    }

    /**
     * 接收到客户端发送的数据时调用.
     * @param message 客户端发送的数据
     * @param session session对象
     * @return void
     */
    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        System.out.println(session);
        System.out.println(message);
        JSONObject parse = (JSONObject) JSONObject.parse(message);
        String toId = parse.get("toId") + "";
        String messInfo = (String)parse.get("message");
        String id = parse.get("id") + "";

        System.out.println(id + " 发给 " + toId + " 信息为： " + messInfo);
        //存储之前改变状态  已读
        SpringCtxUtils.getBean(ChatService.class).updateSt(Integer.parseInt(toId),Integer.parseInt(id),1);
        //统一存储到数据库  发送人，接收人，消息主体
        SpringCtxUtils.getBean(ChatService.class).insert(Integer.parseInt(id),Integer.parseInt(toId),messInfo);
        Session session1 = mess.get(toId);
        if(session1 == null || !session1.isOpen()){
            //没有登录
            //我觉得应该使用
            /**
             * 定时任务？
             */
            mess.remove(toId);
            return;
        }

            //提醒--->闪烁？  发送信息  注意  无论用户当前是否处于聊天界面，一旦用户刷新页面，websocket对象就变了 session就变了，所以不能这样弄
            /**
             * 如何解决呢？
             * 第一：发送肯定要，如果再聊天页面，一切好说
             * 第二：存储到数据库，标识为没有阅读
             * 第三：何时为已经阅读状态？  头像显示一栏变为红色，红色为有新的消息。点击红色消息，已经阅读。发送新的消息，已经阅读
             */
        FromMess fromMess = new FromMess();
        fromMess.setFromUser(id);
        fromMess.setToId(toId);
        fromMess.setMessage(messInfo);
        Object json = JSONObject.toJSON(fromMess);
        session1.getBasicRemote().sendText(json.toString());
    }


    /**关闭时调用*/
    @OnClose
    public void onClose(Session session) {
        //刷新就关闭了
        System.out.println("我被关闭了~~~~~~~~" + session);

    }
}
