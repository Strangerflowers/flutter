import 'package:bid/models/goods/goods_detail_model.dart';
import 'package:flutter/material.dart';

import '../service/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {
  int currentSelect = 0;
  var goodsInfo;
  // 从后台获取数据
  getGoodsInfo(String id) {
    requestPostGetSpl('goodsDetail', spl: id.toString()).then((val) {
      // print('获取商品详情数据$val');
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
