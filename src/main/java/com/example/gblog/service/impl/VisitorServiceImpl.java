package com.example.gblog.service.impl;

import com.example.gblog.bean.Visitor;
import com.example.gblog.mapper.VisitorMapper;
import com.example.gblog.service.VisitorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VisitorServiceImpl implements VisitorService {
    @Autowired
    VisitorMapper visitorMapper;

    @Override
    public List<Visitor> getByUserId(Integer id) {
        return visitorMapper.getByUserId(id);
    }
}
