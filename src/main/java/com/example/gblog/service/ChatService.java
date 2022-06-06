package com.example.gblog.service;

import com.example.gblog.bean.HisMessage;

import java.util.List;

public interface ChatService {
    void insert(Integer id, Integer toId, String messInfo);

    List<HisMessage> getHis(Integer desId, Integer id);

    void updateSt(int parseInt, int parseInt1, int i);
}
