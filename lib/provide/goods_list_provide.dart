import 'package:bid/models/goods_list.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class GoodsWarehose with ChangeNotifier {
  // GoodsSearchList goodsAllList; //在provide获取接口数据时，将返回数据保存在该变量
  int provideIndex = 0; //tabs的初始索引
  int status = 1;
  String noMoreText = '';
  int page = 1; //页码

  List<GoodsSearchResultList> goodsList; //将每个tabs的列表存放在此处

  //点击切换tabs时获取对应的列表数据
  getGoodsList(List<GoodsSearchResultList> list) {
    print('获取数据接口$list');
    goodsList = list;
    notifyListeners();
  }

  activeIndex(int index) {
    print('修改tabs$index');
    provideIndex = index;
    // 内部方法--可以通知听众，局部刷新
    notifyListeners();
  }

  // 增加page方法
  addPage() {
    page++;
  }

  // 加载更多的提示信息
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  //上拉加载列表
  addGoodsList(List<GoodsSearchResultList> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
