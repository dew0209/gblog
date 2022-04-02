package com.example.gblog.service;


import com.example.gblog.bean.Visitor;

import java.util.List;

public interface VisitorService {
    List<Visitor> getByUserId(Integer id);
}
