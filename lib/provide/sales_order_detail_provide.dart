import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/sales_order_detail_model.dart';

class SalesOrderDetailProvide with ChangeNotifier {
  SalesOrderDetail goodsList;
  // 从后台获取数据
  getQuotationDetail(String id) {
    var formData = {'id': id};
    requestGet('queryById', formData: formData).then((val) {
      // print('响应数据${val['result']}');
      goodsList = SalesOrderDetail.fromJson(val);
      // print('详情数据$goodsList');
      notifyListeners();
    });
  }
}
