import 'package:flutter/material.dart';
// import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  int currentSelect = 0;
  // DetailsModle goodsInfo = null;
  var goodsInfo = null; //临时存放
  // 从后台获取数据
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      print('$responseData');
      // goodsInfo = DetailsModle.fromJson(responseData);
      notifyListeners();
    });
  }

  selectTabs(text) {
    currentSelect = text;
    print('当前选中的规格$text====$currentSelect');
    notifyListeners();
  }
}
