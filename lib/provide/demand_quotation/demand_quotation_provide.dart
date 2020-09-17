import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import '../../model/demand_quotation/demand_quotation_model.dart';

class DemandQuotationProvide with ChangeNotifier {
  QuotataionData goodsList;
  var quotationData;
  int currentindex;

  // 从后台获取数据
  getDemandDetailData(String productCategroyId) {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": 1,
      "params": {"productCategroy": productCategroyId}
    };
    // FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    // print('获选带选择产品$formData');
    request('selectGoodsByProductId', formData: formData).then((val) {
      print('商品列表$val');
      if (val['code'] == 0) {
        goodsList = QuotataionData.fromJson(val);
        quotationData = goodsList.result.list;
        // print('99555559999---==${quotationData}');
        quotationData.forEach((ele) {
          ele.checkBoxFlag = false;
        });
      }

      // print('999999---==${quotationData}');
      // print('采购需求详情11111${quotationData[0].checkBoxFlag}');
      notifyListeners();
    });
  }

  // 单选控制
  changeSelectItem(index) {
    currentindex = index;
    quotationData = goodsList.result.list;
    quotationData.forEach((ele) {
      ele.checkBoxFlag = false;
    });
    quotationData[index].checkBoxFlag = true;

    notifyListeners();
  }

  selectIndex(index) {
    currentindex = index;
    notifyListeners();
  }
}
