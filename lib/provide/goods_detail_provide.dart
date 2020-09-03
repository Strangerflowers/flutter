import 'package:flutter/material.dart';
import '../model/goods/goods_detail_model.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  int currentSelect = 0;
  var goodsInfo;
  // 从后台获取数据
  getGoodsInfo(String id) {
    requestGet('goodsDetail').then((val) {
      print('获取商品详情数据$val');
      // var responseData = json.decode(val);
      // print('===========>$responseData');
      goodsInfo = GoodsDetail.fromJson(val);
      notifyListeners();
    });
  }

  selectTabs(text) {
    currentSelect = text;
    print('当前选中的规格$text====$currentSelect');
    notifyListeners();
  }
}
