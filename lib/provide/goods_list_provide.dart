import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/goods_list.dart';

class GoodsWarehose with ChangeNotifier {
  // GoodsSearchList goodsAllList; //在provide获取接口数据时，将返回数据保存在该变量
  int provideIndex = 0; //tabs的初始索引

  List<GoodsSearchResultList> goodsList; //将每个tabs的列表存放在此处

  //点击切换tabs时获取对应的列表数据
  getGoodsList(List<GoodsSearchResultList> list) {
    print('获取数据接口$list');
    goodsList = list;
    notifyListeners();
  }

  activeIndex(int index) {
    provideIndex = index;
    // 内部方法--可以通知听众，局部刷新
    notifyListeners();
  }

  // // 从后台获取数据
  // getGoodsAllList() {
  //   var formData = {'pageNum': 1, 'pageSize': 10};
  //   requestGet('goodsList', formData: formData).then((val) {
  //     print('商品库响应数据$val');
  //     goodsAllList = GoodsSearchList.fromJson(val);
  //     // print('详情数据$goodsList');
  //     notifyListeners();
  //   });
  // }
}
