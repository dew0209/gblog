package com.example.gblog.service.impl;

import com.example.gblog.mapper.ReadingMapper;
import com.example.gblog.service.ReadingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReadingServiceImpl implements ReadingService {

    @Autowired
    ReadingMapper readingMapper;

    @Override
    public int getByPostIdAndUserId(Integer postId, Integer userId) {
        return readingMapper.getByPostIdAndUserId(postId,userId);
    }

    @Override
    public void insert(Integer id, Integer userId) {
        readingMapper.insert(id,userId);
    }
}
