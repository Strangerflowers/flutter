import 'package:bid/models/shipping_information_add_model.dart';
import 'package:flutter/material.dart';

import '../service/service_method.dart';

class SalesOrderAddProvide with ChangeNotifier {
  GoodsNewsObj goodsList;
  List<GoodsNewsObjResult> salesList; //存储需求列表数据
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
      var res = val['result'].map((ele) {
        ele['planDeliveryNumber'] = 0;
        return ele;
      });
      val['result'] = res;
      // print('获-返回数据是否改变${val['result']}');
      // print('查看总的数据$val');
      goodsList = GoodsNewsObj.fromJson(val);
      // salesList = goodsList.result;
      // print('详情数据$goodsList');
      notifyListeners();
    });
  }

  // //更改发货数量
  // getSalessList(index, num) {
  //   // print('获取数据接口1$list');
  //   salesList[index].planDeliveryNumber = num;
  //   notifyListeners();
  // }

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
