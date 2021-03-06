import 'package:bid/common/string_utils.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:bid/common/toast.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/sales_order_detail_provide.dart';
import '../../routers/application.dart';

class SalesOrderDetails extends StatelessWidget {
  final String goodsId;
  SalesOrderDetails(this.goodsId);
  @override
  Widget build(BuildContext context) {
    // _getBackDetailInfo(context);
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF242526),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '销售订单详情',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF242526),
            ),
          ),
          backgroundColor: Colors.white,
          // title: Text('销售订单详情'),
        ),
        body: FutureBuilder(
          future: _getBackDetailInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  color: Color(0xFFF5F6F8),
                  child: Column(
                    children: <Widget>[
                      SalesOrderBasic(),
                      ProductInformation(),
                      DeliveryArrangement(goodsId),
                    ],
                  ),
                ),
              );
            } else {
              return Text('暂无数据');
            }
          },
        ),
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<SalesOrderDetailProvide>(context)
        .getQuotationDetail(goodsId);
    return '加载完成';
  }
}

// 基础信息
class SalesOrderBasic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderDetailProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 20),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 19,
                  // bottom: 15,
                  child: Container(
                    height: ScreenUtil().setHeight(46),
                    width: ScreenUtil().setWidth(10),
                    color: Color(0xFF2A83FF),
                    child: Text(''),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: ExpansionTile(
                    title: Text(
                      '基础信息',
                      style: TextStyle(
                        color: Color(0XFF242526),
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      _mergeInformation(goodsInfo.result, context),
                    ],
                    initiallyExpanded: true, //是否默认打开？
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: Text('暂无数据'),
        );
      }
    });
  }

  Widget _mergeInformation(detailData, context) {
    var type = {0: '待发送', 1: '待确认', 2: '待发货', 3: '已发货', 4: '已完成'};
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          _information('订单编号', detailData.subOrderCode),
          _information('订单状态', type[detailData.status]),
          _information('需求方名称', detailData.demanderDeptName),
          _planClick(
              '报价单', detailData.quotationCode, detailData.quotationId, context),
          // _information('收货地址', detailData.consigneeAdress),
          _address('收货地址', detailData),
          _information('期望交货时间', detailData.expectedDeliveryTime),
          _information('备注', detailData.notes),
          _information('支付状态', '支付成功'),
        ],
      ),
    );
  }

  // 报价单
  Widget _planClick(title, content, id, context) {
    if (id == 'null') {
      return Container(
        height: 0,
        child: Text(''),
      );
    } else {
      return Container(
        child: InkWell(
          onTap: () {
            // 跳转到报价单详情页面
            Application.router
                .navigateTo(context, "/detail?id=$id", replace: true);
            // Application.router.navigateTo(context, "/plan?id=$id");
            print('点击跳转采购页面');
          },
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(200),
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: Color(0XFF242526),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${content == 'null' ? '' : content}',
                  style: TextStyle(
                    color: Color(0XFF242526),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black12,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _address(title, item) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text(
              '$title',
              style: TextStyle(
                color: Color(0XFF242526),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8.0, //chip之间的间距大小
                    runSpacing: 4.0, //行之间的间距大小
                    children: <Widget>[
                      Text(
                        item.consigneeName,
                        style: TextStyle(
                          color: Color(0XFF242526),
                          fontSize: ScreenUtil().setSp(28),
                          height: 1.1,
                        ),
                      ),
                      Text(
                        item.consigneeMobile,
                        style: TextStyle(
                          color: Color(0XFF242526),
                          fontSize: ScreenUtil().setSp(28),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item.consigneeAdress,
                    style: TextStyle(
                      color: Color(0XFF242526),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 需求信息
  Widget _information(title, content) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text(
              '$title',
              style: TextStyle(
                color: Color(0XFF242526),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                '${content == 'null' || content == null ? '' : content}',
                style: TextStyle(
                  color: Color(0XFF242526),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 产品信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderDetailProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 19,
                  // bottom: 15,
                  child: Container(
                    height: ScreenUtil().setHeight(46),
                    width: ScreenUtil().setWidth(10),
                    color: Color(0xFF2A83FF),
                    child: Text(''),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: ExpansionTile(
                    title: Text(
                      '产品信息',
                      style: TextStyle(
                        color: Color(0XFF242526),
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      _recommedList(goodsInfo.result.orderItems),
                      _sumAllPrice(goodsInfo.result),
                    ],
                    initiallyExpanded: true, //是否默认打开？
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(child: Text(''));
      }
    });
  }

  // 循环渲染
  // 一级
  Widget _recommedList(list) {
    // if (list.length > 0) {
    return Container(
      // height: ScreenUtil().setHeight(1000),
      child: SizedBox(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            return _productItem(list[index]);
          },
        ),
      ),
    );
    // }
    //  else {
    //   return Container(
    //     child: Text('加载中。。。。。'),
    //   );
    // }
  }

  // 合并头部跟产品信息
  Widget _productItem(item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEAECF0),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          _goodsItem(item),
          _sumPrice(item),
        ],
      ),
    );
  }

  Widget _productTitle(item) {
    var statusType = {0: 0xe643, 1: 0xe641, 2: 0xe63f};
    var statusColor = {0: 0xFF378AFF, 1: 0xFFA1A4A7, 2: 0xFF00C290};
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(150),
                          child: Text('对应产品：'),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(350),
                          child: Text(
                            '${item.productName}',
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(150),
                          child: Text('需求数量：'),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(350),
                          child: Text(
                            '${item.num} ${item.typeName}',
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 商品信息
  Widget _goodsItem(item) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // alignment: Alignment.topCenter,
              width: ScreenUtil().setWidth(140),
              height: ScreenUtil().setHeight(140),
              padding: EdgeInsets.only(right: 10),
              child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(item.mainKey, ''),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      // '12323',
                      '${item.productName}',
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0XFF242526),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      '￥ ${MoneyUtil.changeYWithUnit((item.price / 100).toString(), MoneyUnit.NORMAL, format: MoneyFormat.NORMAL)} 元/${item.unit}',
                      style: TextStyle(
                        color: Color(0xFF242526),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      // '规格：${item.skuValueList}',
                      '规格：${item.specification}',
                      style: TextStyle(
                        color: Color(0xFF9C9FA2),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      '数量：${item.number} ${item.unit}',
                      style: TextStyle(
                        color: Color(0xFF9C9FA2),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 合计
  Widget _sumPrice(item) {
    double sum = 0.0;
    sum = item.number * item.price;
    var priceSum = (sum / 100).toStringAsFixed(2).split('.');
    // print('计算${item.number}*${item.price}=${sum}');
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      alignment: Alignment.bottomRight,
      width: ScreenUtil().setWidth(750),
      child: RichText(
        text: TextSpan(
            text: '小计：',
            style: TextStyle(
              color: Color(0xFF242526),
              fontSize: ScreenUtil().setSp(24),
            ),
            children: <TextSpan>[
              TextSpan(
                text: '￥',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
              TextSpan(
                // text: '${(sum / 100).toStringAsFixed(2)}',
                text: '${priceSum[0]}.',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
              TextSpan(
                // text: '${(sum / 100).toStringAsFixed(2)}',
                text: priceSum[1],
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
            ]),
      ),
      // child: Expanded(
      // child: Row(
      //   children: <Widget>[
      //     Text('小计：'),
      //     Text(
      //       '￥${sum.toStringAsFixed(2)}',
      //       style: TextStyle(
      //         color: Color(0xFFF2A631),
      //       ),
      //     ),
      //   ],
      // ),
      // ),
    );
  }

  // 共计
  Widget _sumAllPrice(item) {
    var totalSum = (item.totalMoney / 100).toStringAsFixed(2).split('.');
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      alignment: Alignment.bottomRight,
      width: ScreenUtil().setWidth(750),
      child: RichText(
        text: TextSpan(
            text: '共计：',
            style: TextStyle(
              color: Color(0xFF242526),
              fontSize: ScreenUtil().setSp(24),
            ),
            children: <TextSpan>[
              TextSpan(
                text: '￥',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
              TextSpan(
                text: '${totalSum[0]}.',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
              TextSpan(
                text: '${totalSum[1]}',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(24),
                ),
              ),
            ]),
      ),
      // child: Expanded(
      // child: Row(
      //   children: <Widget>[
      //     Text('共计：'),
      //     Text(
      //       '￥${item.totalMoney}',
      //       style: TextStyle(
      //         color: Color(0xFFF2A631),
      //       ),
      //     ),
      //   ],
      // ),
      // ),
    );
  }
}

// 发货安排
class DeliveryArrangement extends StatelessWidget {
  final String goodsId;
  DeliveryArrangement(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderDetailProvide>(context).goodsList;
      var len;

      if (goodsInfo != null) {
        if (goodsInfo.result.dispatchVos == null) {
          len = 0;
        } else {
          len = goodsInfo.result.dispatchVos.length;
        }
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 19,
                  // bottom: 15,
                  child: Container(
                    height: ScreenUtil().setHeight(46),
                    width: ScreenUtil().setWidth(10),
                    color: Color(0xFF2A83FF),
                    child: Text(''),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: ExpansionTile(
                    title: Text(
                      '发货安排',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF242526),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      _deliverList(
                          goodsInfo.result.dispatchVos, goodsInfo.result),
                      _addShipment(goodsInfo.result, context, len),
                      _shipmentButtom(context, goodsInfo.result),
                    ],
                    initiallyExpanded: true, //是否默认打开？
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        return Container(child: Text(''));
      }
    });
  }

  // 循环渲染
  // 一级
  Widget _deliverList(list, result) {
    if (list != null) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              // return Text('测试测试');
              return _productItem(list[index], index, contex, result);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('当前无安排'),
      );
    }
  }

  // 合并头部跟产品信息
  Widget _productItem(item, index, context, result) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0XFFEAECF0),
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          _productTitle(item, index, context, result),
          _salesOrderProductChild(item.dispatchItemVos),
        ],
      ),
    );
  }

  Widget _productTitle(item, index, context, result) {
    var statusType = {0: '发货', 1: '已发货', 2: '已收货'};
    var statusColor = {0: 0xFF378AFF, 1: 0xFFA1A4A7, 2: 0xFF00C290};
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(top: 5, bottom: 5),
                          // width: ScreenUtil().setWidth(300),
                          child: Text(
                            '第${item.batch}次计划发货时间:',
                            style: TextStyle(
                              color: Color(0xFF242526),
                              fontSize: ScreenUtil().setSp(28),
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(width: 5), // 50宽度
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            // width: ScreenUtil().setWidth(350),
                            child: Text(
                              '${item.planDeliveryTime}',
                              style: TextStyle(
                                color: Color(0xFF242526),
                                fontSize: ScreenUtil().setSp(28),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        _deliverButtom(item, context, statusType, result),
                        // InkWell(
                        //   onTap: () {
                        //     // 跳转到详情页面
                        //     if (item.status == 0) {
                        //       Application.router
                        //           .navigateTo(context, "/add?id=${item.id}");
                        //       print('跳转到更新发货信息');
                        //     }
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.centerRight,
                        //     decoration: BoxDecoration(
                        //       //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(5.0)),
                        //       //设置四周边框
                        //       border: new Border.all(
                        //         width: 1,
                        //         color: Color(0xFFDAEDFE),
                        //       ),
                        //       color: Color(0xFFDAEDFE),
                        //     ),
                        //     margin: EdgeInsets.only(right: 10, top: 10),
                        //     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        //     // width: ScreenUtil().setWidth(120),
                        //     child: Text(
                        //       '${statusType[item.status]}',
                        //       style: TextStyle(
                        //           color: Color(0xFF5696D2),
                        //           fontSize: ScreenUtil().setSp(24)),
                        //       maxLines: 1,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    height: item.status == 0 ? 0 : null,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  item.logisticsNumber == 'null'
                                      ? ''
                                      : '${item.logisticsCompanyName}${item.logisticsNumber}',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              _copy(item, context),
                            ],
                          ),
                        ),
                        _seeInfo(item, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 发货按钮控制
  Widget _deliverButtom(item, context, statusType, result) {
    if (result.status == 1 || result.status == 0) {
      return Container(
        child: Text(''),
      );
    } else {
      return InkWell(
        onTap: () {
          if (item.status == 0) {
            Application.router.navigateTo(
                context, "/add?id=${item.id}&detailId=$goodsId",
                replace: true);
            print('跳转到更新发货信息');
          }
        },
        child: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //设置四周边框
            border: new Border.all(
              width: 1,
              color: item.status == 0 ? Color(0xFF2A83FF) : Color(0xFFDCEEFC),
            ),
            // color: Color(0xFFDAEDFE),
            color: item.status == 0 ? Color(0xFFFFFFFF) : Color(0xFFDCEEFC),
          ),
          margin: EdgeInsets.only(right: 10, top: 10),
          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
          // width: ScreenUtil().setWidth(120),
          child: Text(
            '${statusType[item.status]}',
            style: TextStyle(
              color: Color(0xFF2A83FF),
              fontSize: ScreenUtil().setSp(28),
            ),
            maxLines: 1,
          ),
        ),
      );
    }
  }

  Widget _copy(item, context) {
    if (item.logisticsNumber.trim() == 'null') {
      return Container(child: Text(''));
    } else {
      return InkWell(
        onTap: () {
          ClipboardData data =
              new ClipboardData(text: "${item.logisticsNumber}");
          Clipboard.setData(data);
          Toast.toast(
            context,
            msg: "已复制",
          );
        },
        child: Text(
          "复制",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(24),
            color: Color(0xFF2A83FF),
          ),
        ),
      );
      // return Container(
      //   child: FlatButton(
      //     child: Text(
      //       "复制",
      //       style: TextStyle(
      //         fontSize: ScreenUtil().setSp(24),
      //         color: Color(0xFF5696D2),
      //       ),
      //     ),
      //     onPressed: () {
      //       ClipboardData data =
      //           new ClipboardData(text: "${item.logisticsNumber}");
      //       Clipboard.setData(data);
      //       Toast.toast(
      //         context,
      //         msg: "已复制",
      //       );
      //     },
      //   ),
      // );
    }
  }

  Widget _seeInfo(item, context) {
    if (item.status != 0) {
      return Container(
        padding: EdgeInsets.only(right: 10),
        child: InkWell(
          child: Text(
            "查看发货信息",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              color: Color(0xFF2A83FF),
            ),
          ),
          onTap: () {
            if (item.status == 0) {
              Application.router
                  .navigateTo(context, "/add?id=${item.id}", replace: true);
            } else {
              // 跳转到详情页面
              Application.router.navigateTo(context, "/look?id=${item.id}");
              print('查看发货信息详情');
            }
          },
          // padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          // child: FlatButton(
          //   //自定义按钮颜色
          //   color: Color(0xFFDAEDFE),
          //   highlightColor: Color(0xFFDAEDFE),
          //   colorBrightness: Brightness.dark,
          //   splashColor: Colors.blue,
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          //     child: Text(
          //       "查看发货信息",
          //       style: TextStyle(
          //         fontSize: ScreenUtil().setSp(24),
          //         color: Color(0xFF5696D2),
          //       ),
          //     ),
          //   ),

          //   textColor: Colors.white,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(5.0)),
          //   onPressed: () {
          //     if (item.status == 0) {
          //       Application.router.navigateTo(context, "/add?id=${item.id}");
          //     } else {
          //       // 跳转到详情页面
          //       Application.router.navigateTo(context, "/look?id=${item.id}");
          //       print('查看发货信息详情');
          //     }
          //   },
          // ),
        ),
      );

      // ),
      // child: InkWell(
      //   // onTap: () {
      //   //   if (item.status == 0) {
      //   //     Application.router.navigateTo(context, "/add?id=${item.id}");
      //   //   } else {
      //   //     // 跳转到详情页面
      //   //     Application.router.navigateTo(context, "/look?id=${item.id}");
      //   //     print('查看发货信息详情');
      //   //   }
      //   // },
      //   child: Container(
      //     alignment: Alignment.centerRight,
      //     decoration: BoxDecoration(
      //       //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
      //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
      //       //设置四周边框
      //       border: new Border.all(
      //         width: 1,
      //         color: Color(0xFFDAEDFE),
      //       ),
      //       color: Color(0xFFDAEDFE),
      //     ),
      //     margin: EdgeInsets.only(right: 10, top: 10),
      //     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      //     // width: ScreenUtil().setWidth(120),
      //     child: Text(
      //       '${item.status == 0 ? '' : '查看发货信息'}',
      //       style: TextStyle(
      //           color: Color(0xFF5696D2), fontSize: ScreenUtil().setSp(24)),
      //       maxLines: 1,
      //     ),
      //   ),
      // ),
      // );
    } else {
      return Container(child: Text(''));
    }
  }

  //二级需求信息变量渲染
  Widget _salesOrderProductChild(item) {
    if (item != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: item.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _goodsItem(item[index]);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无发货数据'),
      );
    }
  }

  // 商品信息
  Widget _goodsItem(item) {
    // String str = '';
    // if (item.skuValueList.length > 0) {
    //   str = (item.skuValueList.join(",")).replaceAll(",", "-");
    //   print('字符串拼接$str');
    // }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF5F6F8)),
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffF5F6F8),
      ),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // alignment: Alignment.topCenter,
              width: ScreenUtil().setWidth(140),
              height: ScreenUtil().setHeight(140),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: ImageWidgetBuilder.loadImage(
                  StringUtils.defaultIfEmpty(item.mainKey, '')),
              // child: item.mainKey == 'null'
              //     ? Image.asset('images/default.png')
              //     : Image.network(
              //         '${item.mainKey}',
              //         fit: BoxFit.cover,
              //         width: ScreenUtil().setWidth(150),
              //         height: ScreenUtil().setHeight(150),
              //       )
              // Image.asset('images/icon.png'),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      // '12323',
                      '${item.productName}',
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF242526),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   padding: EdgeInsets.only(top: 3, bottom: 3),
                  //   child: Text(
                  //     '￥${item.amount}',
                  //     // '${item.productDescript}',
                  //     maxLines: 2,
                  //     style: TextStyle(
                  //       fontSize: ScreenUtil().setSp(30),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      // '规格：${item.skuValueList}',
                      '规格：${item.specification}',
                      style: TextStyle(
                        color: Color(0xFF9C9FA2),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Text(
                      '数量：${item.number}',
                      style: TextStyle(
                        color: Color(0xFF9C9FA2),
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 添加发货安排
  Widget _addShipment(item, context, len) {
    if (item.status == 1) {
      return InkWell(
        onTap: () {
          // 跳转到详情页面

          Application.router.navigateTo(context,
              "/addshipment?id=${item.id}&len=$len&mainOrderId=${item.mainOrderId}&returnId=$goodsId",
              replace: true);
          print('点击跳转采购页面');
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //设置四周边框
            border: new Border.all(
              width: 1,
              color: Color(0xFFF6F5F8),
            ),
            color: Color(0xFFF6F5F8),
          ),
          height: ScreenUtil().setHeight(160),
          margin: EdgeInsets.all(20),
          // color: Color(0xFFF6F5F8),
          child: Row(
            children: <Widget>[
              Icon(Icons.add),
              Text('添加发货安排'),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Text(''),
      );
    }
  }

  // 发货按钮
  Widget _shipmentButtom(context, result) {
    if (result.status == 1) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          // width:200.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  //自定义按钮颜色
                  color: Color(0xFF2A83FF),
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.blue,
                  child: Text("确认并发送"),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () {
                    _confirm(context, result);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(child: Text(''));
    }
  }

  void _confirm(context, result) {
    if (result.dispatchVos.length <= 0) {
      return Toast.toast(context, msg: '请先添加发货安排');
    }
    var formData = {
      'subOrderId': goodsId,
    };
    requestGet('confirm', formData: formData).then((val) {
      print('响应数据---$val');
      if (val['code'] == 0) {
        Toast.toast(context, msg: '发送成功!');
        Application.router
            .navigateTo(context, "/salesdetail?id=$goodsId", replace: true);
        // Fluttertoast.showToast(
        //   msg: '发送成功!',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      } else {
        Toast.toast(context, msg: val['message']);
        // Fluttertoast.showToast(
        //   msg: val['message'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
      // goodsList = AddDeliverArrange.fromJson(val);
      // print('详情数据$goodsList');
    });
  }
}
