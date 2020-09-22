import 'package:bid/models/quotation_detail_model.dart';
import 'package:flutter/material.dart';

import '../service/service_method.dart';

class QuotationDetailProvide with ChangeNotifier {
  QuotationDetail goodsList;
  // 从后台获取数据
  getQuotationDetail(String id) {
    var formData = {'id': id};
    requestGet('quotationDetail', formData: formData).then((val) {
      // print('响应数据$val');
      goodsList = QuotationDetail.fromJson(val);
      // print('详情数据$goodsList');
      notifyListeners();
    });
  }
}
