import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/sales_order/look.dart';

class SalesOrderLook with ChangeNotifier {
  Look goodsList;
  LookDispatchItemVos salesList;

  // 从后台获取数据
  getQuotationDetail(String id) {
    var formData = {'dispatchId': id};
    requestGet('look', formData: formData).then((val) {
      print('查询发货数据响应$val');
      goodsList = Look.fromJson(val);
      print('查询发货信息goodsList$goodsList');
      // goodsList = val;
      // // salesList = goodsList.result.dispatchItemVos;
      notifyListeners();
    });
  }
}
