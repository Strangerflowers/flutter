import 'package:bid/models/sales_order_list_model.dart';
import 'package:flutter/material.dart';

class SalesOrderListProvide with ChangeNotifier {
  // // GoodsSearchList goodsAllList; //在provide获取接口数据时，将返回数据保存在该变量
  int page = 1; //tabs的初始索引
  int childIndex = 0;
  // `status` int(2) DEFAULT NULL COMMENT '状态(0.待发送，1.待确认，2.待发货，3.已发货，4.已完成)',
  int status = 1;
  String noMoreText = '';

  List<SalesRoderList> goodsList; //存储需求列表数据

  //获取需求列表的数据
  getGoodsList(List<SalesRoderList> list) {
    print('获取数据接口1$list');
    goodsList = list;
    notifyListeners();
  }

  // 增加page方法
  addPage() {
    page++;
  }

  // 改变子类索引
  changeChildIndex(index) {
    page = 1; //切换小类时，page从1开始
    noMoreText = '';
    // 0：已报价，1：报价未通过,2：报价通过，3：部分通过
    // var statusType = {0: 0, 1: 2, 2: 3, 3: 1};
    status = index + 1;
    childIndex = index;
    notifyListeners();
  }

  // 加载更多的提示信息
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  //上拉加载列表
  addGoodsList(List<SalesRoderList> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
