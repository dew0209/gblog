package com.example.gblog.service;

public interface LoveService {
    void add(Integer postId);

    void remove(Integer postId);

    Integer getById(Integer id);
}
