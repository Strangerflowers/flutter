import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:bid/common/toast.dart';

import 'dart:convert';
import '../models/demand_detail_model.dart';

class DemandDetailProvide with ChangeNotifier {
  DemandDetailHome goodsList;
  var remark; //备注输入信息；
  var speciesNumber; //几种
  var totalNumber; //共几件
  var offerPageData; //报价整合数据的数据，用于渲染报价提交页面
  var selectData = [];
  var quotationData; //报价页面数据
  var parentFlagList = []; //存放父级勾选的值，用于对全选是否勾上
  var childFlagList = [];
  var tranData; //中转
  bool selectAllFlag = false;
  var arr = [];
  // 从后台获取数据
  getDemandDetailData(String id) {
    // FormData formData = FormData.fromMap({'demandId': id});
    // var formData = {'demandId': id};
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    request1('demandDetail', id: id).then((val) {
      print('获取详情页数据$val');
      if (val['code'] == 0) {
        // goodsList = DemandDetailHome.fromJson(val);
        if (val['result'] != null) {
          goodsList = DemandDetailHome.fromJson(val);
          tranData = goodsList.result.demandSkuDtoList;
          quotationData = [];
          // 获取报价页面数据，遍历多加一个checkBoxFlag字段，用于判断是否处于勾选状态
          tranData.forEach((ele) {
            ele.checkBoxFlag = false;
            selectAllFlag = false;
            if (ele.demandDetailDtoList != null) {
              List<DemandDetailDtoList> wherearr = new List();
              ele.demandDetailDtoList.forEach((subele) {
                subele.checkBoxFlag = false;
                if (subele.isQuotation == 0) {
                  return wherearr.add(subele);
                  // return quotationData.add(ele);
                }
              });
              // 只展示可报价的
              if (wherearr.length > 0) {
                ele.demandDetailDtoList = wherearr;
                quotationData.add(ele);
              }
            }
            // return arr.add(ele);
          });
          // quotationData = arr;
        } else {
          // Toast.toast()
          // Fluttertoast.showToast(
          //   msg: '暂无数据',
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
        }
      } else {
        goodsList = null;
        // Fluttertoast.showToast(
        //   msg: val['message'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
      notifyListeners();
    });
  }

  // 全选/取消全选报价商品的规格
  selectAll(flag) {
    // selectAllFlag = flag;
    selectAllFlag = !selectAllFlag;

    quotationData.forEach((ele) {
      ele.checkBoxFlag = selectAllFlag;
      if (ele.demandDetailDtoList != null) {
        ele.demandDetailDtoList.forEach((ele) {
          ele.checkBoxFlag = selectAllFlag;
        });
      }
    });

    print('全选状态$selectAllFlag');
    notifyListeners();
  }

  // 勾选父级下面的子级全部勾上
  selectParentAll(flag, index) {
    // 父级全选，子级全部勾选，父级取消，子级全部取消
    // quotationData = goodsList.result.demandSkuDtoList;
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
    // quotationData = goodsList.result.demandSkuDtoList;
    // 判断全选是否勾上
    quotationData.forEach((ele) {
      if (ele.demandDetailDtoList != null) {
        // 用于存放true的个数
        childFlagList = [];
        ele.demandDetailDtoList.forEach((sub) {
          if (sub.checkBoxFlag == true) {
            childFlagList.add(sub.checkBoxFlag);
          }
        });
        if (childFlagList.length == ele.demandDetailDtoList.length) {
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
    speciesNumber = offerPageData.length;
    totalNumber = 0;
    offerPageData.forEach((ele) {
      totalNumber += ele['demandDetailDtoList'].length;
    });

    notifyListeners();
  }

  // 选择规格时，默认单价
  changeGoodsPrice(price, specificaId) {
    // print('-------------->${specificaId}---$price');

    offerPageData.forEach((ele) {
      ele['demandDetailDtoList'].forEach((item) {
        if (item.specificaId == specificaId) {
          item.goodsPrice = price;
        }
      });
    });
    notifyListeners();
  }

  // 修改单个价格
  modifyPrice(producet, price) {
    offerPageData.forEach((ele) {
      ele['demandDetailDtoList'].forEach((item) {
        if (item.id == producet.id) {
          item.goodsPrice = price;
        }
      });
    });
    notifyListeners();
  }

  // 输入价格时跟随价格浮动
  // 法一，每次输入改变都进行一次遍历，然后计算总价格
  // 法二，找到对应位置，只改对应的价格，
  // 法三：先计算小计，由小计来相加，计算总价格数
  changeTotalAmount(price, specificaId) {
    notifyListeners();
  }

  remarkFunc(text) {
    remark = text;
    notifyListeners();
  }

  // 删除产品
  removeProduct(item, context) {
    var arr = [];
    offerPageData.forEach((ele) {
      if (ele['demandDetailDtoList'] != null) {
        var brr = [];
        ele['demandDetailDtoList'].forEach((subele) {
          if (subele.id == item.id) {
            if (offerPageData.length <= 1 &&
                ele['demandDetailDtoList'].length <= 1) {
              brr.add(subele);
              return Toast.toast(context, msg: '不可删除');
            }
          } else {
            brr.add(subele);
          }
        });
        ele['demandDetailDtoList'] = brr;
        if (ele['demandDetailDtoList'].length > 0) {
          arr.add(ele);
        }
      }
    });
    offerPageData = arr;
    // offerPageData.remove(item);
    notifyListeners();
  }

  // 清空勾选
  cleanCheck() {
    // quotationData = goodsList.result.demandSkuDtoList;
    // 获取报价页面数据，遍历多加一个checkBoxFlag字段，用于判断是否处于勾选状态,//清空选择的产品
    quotationData.forEach((ele) {
      ele.checkBoxFlag = false;
      selectAllFlag = false;
      if (ele.demandDetailDtoList != null) {
        ele.demandDetailDtoList.forEach((ele) {
          ele.subjectItemList = null; //清空选择的产品
          ele.checkBoxFlag = false;
        });
      }
      // return arr.add(ele);
    });
    // quotationData = arr;
    notifyListeners();
  }

  //清空报价页面
  cleanProduct() {
    offerPageData = [];
    notifyListeners();
  }
}
