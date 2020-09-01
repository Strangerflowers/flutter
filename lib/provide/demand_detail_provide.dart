import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/demand_detail_model.dart';

class DemandDetailProvide with ChangeNotifier {
  DemandDetailHome goodsList;
  var selectData = [];
  var quotationData;
  var arr = [];
  // 从后台获取数据
  getDemandDetailData(String id) {
    FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    request('demandDetail', formData: formData).then((val) {
      goodsList = DemandDetailHome.fromJson(val);
      quotationData = goodsList.result.demandSkuDtoList;

      quotationData.forEach((ele) {
        ele.checkBoxFlag = false;
        if (ele.demandDetailDtoList != null) {
          ele.demandDetailDtoList.forEach((ele) {
            ele.checkBoxFlag = false;
          });
        }
        return arr.add(ele);
      });
      quotationData = arr;
      print('转化报价数据===$arr=====${quotationData[0].checkBoxFlag}');
      notifyListeners();
    });
  }

  changeCheckBoxFlag() {
    notifyListeners();
  }
}
