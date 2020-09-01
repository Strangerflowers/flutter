import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int provideIndex = 0;

  activeIndex(int index) {
    provideIndex = index;
    // 内部方法--可以通知听众，局部刷新
    notifyListeners();
  }
}
