import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/demand_detail_model.dart';

class DemandDetailProvide with ChangeNotifier {
  DemandDetailHome goodsList;
  var offerPageData; //报价整合数据的数据
  var selectData = [];
  var quotationData;
  var parentFlagList = []; //存放父级勾选的值，用于对全选是否勾上
  var childFlagList = [];
  bool selectAllFlag = false;
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
        selectAllFlag = false;
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

  // 全选/取消全选报价商品的规格
  selectAll(flag) {
    // selectAllFlag = flag;
    selectAllFlag = !selectAllFlag;
    quotationData = goodsList.result.demandSkuDtoList;
    quotationData.forEach((ele) {
      ele.checkBoxFlag = selectAllFlag;
      if (ele.demandDetailDtoList != null) {
        ele.demandDetailDtoList.forEach((ele) {
          ele.checkBoxFlag = selectAllFlag;
        });
      }
      return arr.add(ele);
    });
    quotationData = arr;

    print('全选状态$selectAllFlag');
    notifyListeners();
  }

  // 勾选父级下面的子级全部勾上
  selectParentAll(flag, index) {
    // 父级全选，子级全部勾选，父级取消，子级全部取消
    quotationData = goodsList.result.demandSkuDtoList;
    quotationData[index].demandDetailDtoList.forEach((ele) {
      ele.checkBoxFlag = flag;
      return arr.add(ele);
    });
    // 判断全选是否勾上
    parentFlagList = [];
    quotationData.forEach((ele) {
      print('11111$ele');
      if (ele.checkBoxFlag == true) {
        return parentFlagList.add(ele);
      }
    });

    if (quotationData.length == parentFlagList.length) {
      selectAllFlag = true;
    } else {
      selectAllFlag = false;
    }
    print('全选状态变量$selectAllFlag');
    notifyListeners();
  }

  // 子级勾选
  selectChild() {
    quotationData = goodsList.result.demandSkuDtoList;
    // 判断全选是否勾上
    quotationData.forEach((ele) {
      if (ele.demandDetailDtoList != null) {
        childFlagList = [];
        ele.demandDetailDtoList.forEach((sub) {
          if (sub.checkBoxFlag == true) {
            childFlagList.add(sub.checkBoxFlag);
          }
        });
        if (childFlagList.length > 0) {
          ele.checkBoxFlag = true;
        } else {
          ele.checkBoxFlag = false;
        }
      }
      return arr.add(ele);
    });
    parentFlagList = [];
    quotationData.forEach((ele) {
      if (ele.checkBoxFlag == true) {
        return parentFlagList.add(ele);
      }
    });
    if (quotationData.length == parentFlagList.length) {
      selectAllFlag = true;
    } else {
      selectAllFlag = false;
    }
    notifyListeners();
  }

  // 报价页面数据
  changeorderPageData(list) {
    offerPageData = list;
    notifyListeners();
  }
}
