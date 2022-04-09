package com.example.gblog.service.impl;

import com.example.gblog.bean.Num;
import com.example.gblog.mapper.NumMapper;
import com.example.gblog.service.NumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NumServiceImpl implements NumService {
    @Autowired
    NumMapper numMapper;
    @Override
    public Num getNumByUserId(Integer id) {
        return numMapper.getNumByUserId(id);
    }

    @Override
    public void add(Integer id) {
        numMapper.add(id);
    }
}
