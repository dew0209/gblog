package com.example.gblog.service;

public interface CollService {
    void add(Integer postId);
    void remove(Integer postId);
    Integer getById(Integer postId);
}
