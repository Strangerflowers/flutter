import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/demand_detail_model.dart';

class DemandDetailProvide with ChangeNotifier {
  DemandDetailHome goodsList;
  // 从后台获取数据
  getDemandDetailData(String id) {
    // var formData = {'demandId': id};
    FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    request('demandDetail', formData: formData).then((val) {
      // print('采购需求详情$val');
      goodsList = DemandDetailHome.fromJson(val);
      print('采购需求详情11111$goodsList');
      notifyListeners();
    });
  }
}
