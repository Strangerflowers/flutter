import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/demand_detail_model.dart';

class DemandQuotationProvide with ChangeNotifier {
  DemandDetailHome goodsList;
  // 从后台获取数据
  getDemandDetailData(String id) {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": 1,
      "params": {
        "productCategroyId": "AIF",
        "userId": "0e08e153b04a11e9b31bb06ebf14a476"
      }
    };
    // FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    request('selectGoodsByProductId', formData: formData).then((val) {
      print('采购需求详情$val');
      goodsList = DemandDetailHome.fromJson(val);
      print('采购需求详情11111$goodsList');
      notifyListeners();
    });
  }
}
