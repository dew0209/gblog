package com.example.gblog.ws;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.server.standard.SpringConfigurator;
import sun.misc.MessageUtils;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint(value = "/chatLJ")
@Component
public class ChatEndpoint {

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
    }

    /**
     * 接收到客户端发送的数据时调用.
     * @param message 客户端发送的数据
     * @param session session对象
     * @return void
     */
    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println(message);
    }


    /**关闭时调用*/
    @OnClose
    public void onClose(Session session) {

    }
}
