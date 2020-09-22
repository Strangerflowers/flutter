import 'package:bid/models/quotation_model.dart';
import 'package:flutter/material.dart';

class QuotationGoodsListProvide with ChangeNotifier {
  // QuotationHomeList goodsList;
  List<QuotationHomeList> goodsList = [];
  int status = 1; //报价tabs切换
  int page = 1; //列表页页数
  int childIndex = 0;

  //点击切换tabs
  getGoodsList(List<QuotationHomeList> list) {
    goodsList = list;
    print('得到的数据集$list');
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index) {
    page = 1; //切换小类时，page从1开始
    // noMoreText = '';
    // 0：已报价，1：报价未通过,2：报价通过，3：部分通过
    var statusType = {0: 0, 1: 2, 2: 3, 3: 1};
    status = statusType[index];
    childIndex = index;
    notifyListeners();
  }

  // //上拉加载列表
  // addGoodsList(List<QuotationHomeList> list) {
  //   goodsList.addAll(list);
  //   notifyListeners();
  // }
}
