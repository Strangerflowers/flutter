import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/sales_add_shipment_model.dart';

class SalesOrderAddProvide with ChangeNotifier {
  AddDeliverArrange goodsList;
  List<AddDeliverArrangeResult> salesList; //存储需求列表数据
  String planDeliveryTime; //计划发货时间
  String mainOrderId = '0';
  String subOrderId = '0';
  String batch = '0';
  var dispatchItems = [];
  var orderItems = [];
  // 从后台获取数据
  getQuotationDetail(String id) {
    var formData = {'subOrderId': id};
    requestGet('queryItemById', formData: formData).then((val) {
      // // print('响应数据${val['result']}');
      // orderItems = val['result'];
      // orderItems.forEach((element) {
      //   // print('遍历方法${element['id']}');
      //   dispatchItems
      //       .add({'orderItemId': element['id'], 'planDeliveryNumber': 0});
      // });
      var res = val['result'].map((ele) {
        ele['planDeliveryNumber'] = 0;
        return ele;
      });
      val['result'] = res;
      // print('获-返回数据是否改变${val['result']}');
      // print('查看总的数据$val');
      goodsList = AddDeliverArrange.fromJson(val);
      salesList = goodsList.result;
      // print('详情数据$goodsList');
      notifyListeners();
    });
  }

  //更改发货数量
  getSalessList(index, num) {
    // print('获取数据接口1$list');
    salesList[index].planDeliveryNumber = num;
    notifyListeners();
  }

  //发货时间修改
  changeDayTime(time) {
    // print('获取数据接口1$list');
    planDeliveryTime = time;
    notifyListeners();
  }

  // 接口传参
  changeData(String time) {
    planDeliveryTime = time;
    notifyListeners();
  }
}
