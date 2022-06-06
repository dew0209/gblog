package com.example.gblog.service.impl;

import com.example.gblog.bean.HisMessage;
import com.example.gblog.mapper.ChatMapper;
import com.example.gblog.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    ChatMapper chatMapper;

    @Override
    public void insert(Integer id, Integer toId, String messInfo) {
        //存储到数据库
        chatMapper.insert(id,toId,messInfo);
    }

    @Override
    public List<HisMessage> getHis(Integer desId, Integer id) {
        //获取最新十条
        List<HisMessage> res1 = chatMapper.getHis(desId,id);
        return res1;
    }

    @Override
    public void updateSt(int parseInt, int parseInt1, int i) {
        chatMapper.upState(parseInt,parseInt1,i);
    }
}
