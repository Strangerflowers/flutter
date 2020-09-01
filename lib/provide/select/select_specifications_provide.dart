import 'package:flutter/material.dart';

class Selects with ChangeNotifier {
  String specifications; //选中的商品规格

  activeIndex(String text) {
    specifications = text;
    // 内部方法--可以通知听众，局部刷新
    notifyListeners();
  }
}
