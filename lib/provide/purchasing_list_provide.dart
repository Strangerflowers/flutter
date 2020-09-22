import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/purchasing_list_model.dart';

class PurchasingListProvide with ChangeNotifier {
  // // GoodsSearchList goodsAllList; //在provide获取接口数据时，将返回数据保存在该变量
  // int provideIndex = 0; //tabs的初始索引

  List<PurchasingList> goodsList; //存储需求列表数据

  //获取需求列表的数据
  getGoodsList(List<PurchasingList> list) {
    print('获取数据接口1$list');
    goodsList = list;
    notifyListeners();
  }

  // activeIndex(int index) {
  //   provideIndex = index;
  //   // 内部方法--可以通知听众，局部刷新
  //   notifyListeners();
  // }
  // QuotationDetail goodsList;
  // // 从后台获取数据
  // getQuotationDetail(String id) {
  //   var formData = {'id': id};
  //   requestGet('quotationDetail', formData: formData).then((val) {
  //     // print('响应数据$val');
  //     goodsList = QuotationDetail.fromJson(val);
  //     // print('详情数据$goodsList');
  //     notifyListeners();
  //   });
  // }
}
