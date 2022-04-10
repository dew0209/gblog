package com.example.gblog.service;

public interface ReadingService {

    int getByPostIdAndUserId(Integer postId, Integer userId);

    void insert(Integer id, Integer userId);
}
