import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/demand_quotation/demand_quotation_model.dart';

class DemandQuotationProvide with ChangeNotifier {
  QuotataionData goodsList;
  // 从后台获取数据
  getDemandDetailData(String id) {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": 1,
      "params": {"productCategroyId": "AIF"}
    };
    // FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    request('selectGoodsByProductId', formData: formData).then((val) {
      print('报价选择产品$val');
      goodsList = QuotataionData.fromJson(val);
      print('采购需求详情11111$goodsList');
      notifyListeners();
    });
  }
}
