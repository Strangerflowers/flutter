import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../models/quotation_detail_plan_model.dart';

class QuotationPlanProvide with ChangeNotifier {
  QuotationPlan goodsList;
  // 从后台获取数据
  getQuotationPlan(String id) {
    var formData = {'id': id};
    requestGet('quotationDetailPlan', formData: formData).then((val) {
      print('采购计划响应数据$val');
      goodsList = QuotationPlan.fromJson(val);
      print('采购计划详情数据$goodsList');
      notifyListeners();
    });
  }
}
