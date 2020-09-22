// 添加发货信息
import 'dart:convert';

import 'package:bid/models/sales_order/add_infomation_model.dart';
import 'package:flutter/material.dart';

import '../../service/service_method.dart';

class SalesAddPage with ChangeNotifier {
  SalesAdd goodsList;
  String logisticsCompanyName, logisticsNumber; //物流公司以及物流订单号
  List<AddDispatchItemVos> salesList; //存储需求列表数据
  String actualDeliveryTime; //实际发货时间
  String planDeliveryTime; //计划发货时间
  String mainOrderId = '0';
  String subOrderId = '0';
  String batch = '0';
  var dispatchItems = [];
  var orderItems = [];
  // 从后台获取数据
  getQuotationDetail(String id) {
    var formData = {'dispatchId': id};
    requestGet('showDispatchProduct', formData: formData).then((val) {
      goodsList = SalesAdd.fromJson(val);
      salesList = goodsList.result.dispatchItemVos;
      print('详情数据$goodsList');
      notifyListeners();
    });
  }

  //更改发货数量
  getSalessList(index, num) {
    // print('获取数据接口1$list');
    salesList[index].actualDeliveryNumber = num;
    notifyListeners();
  }

  //发货时间修改
  changeDayTime(time) {
    // print('获取数据接口1$list');
    actualDeliveryTime = time;
    notifyListeners();
  }

  // 接口传参
  changeData(String time) {
    planDeliveryTime = time;
    notifyListeners();
  }

  // 修改物流公司
  changeCompanyNumber(value) {
    logisticsNumber = value;
    notifyListeners();
  }

  // 修改快递单号
  changeCompanyName(value) {
    logisticsCompanyName = value;
    notifyListeners();
  }
}
