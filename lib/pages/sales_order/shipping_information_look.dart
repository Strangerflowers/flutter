import 'package:bid/common/string_utils.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/sales_order/look.dart';
import '../../routers/application.dart';

class ShippingInformationLook extends StatelessWidget {
  final String id;
  ShippingInformationLook(this.id);
  @override
  Widget build(BuildContext context) {
    // _getBackDetailInfo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('发货信息'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    LookHeader(),
                    ProductInformation(),
                    Quotation(),
                  ],
                ),
              ),
            );
          } else {
            return Text('加载中......');
          }
        },
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<SalesOrderLook>(context).getQuotationDetail(id);
    return '加载完成';
  }
}

class LookHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderLook>(builder: (context, child, val) {
      var statusType = {0: '待发货', 1: '已发货', 2: '已收货'};
      var goodsInfo = Provide.value<SalesOrderLook>(context).goodsList;
      if (goodsInfo != null) {
        var result = goodsInfo.result;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              _information('发货批次', result.batch),
              _information('发货状态', statusType[result.status]),
              _information('计划发货时间', '${result.planDeliveryTime}'),
              _information('实际发货时间', result.actualDeliveryTime),
              _information('物流公司', result.logisticsCompanyName),
              _information('快递单号', result.logisticsNumber),
            ],
          ),
        );
      } else {
        return Text('暂无数据');
      }
    });
  }

  // 需求信息
  Widget _information(title, content) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text('$title'),
          ),
          Container(
            child: Text('${content == 'null' ? '' : content}'),
          )
        ],
      ),
    );
  }
}

// // 产品信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderLook>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderLook>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: _recommedList(
                goodsInfo.result.dispatchItemVos, goodsInfo.result),
          ),
        );
      } else {
        return Container(child: Text('加载中......'));
      }
    });
  }

  // 循环渲染
  // 一级
  Widget _recommedList(list, result) {
    // if (list.length > 0) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // height: ScreenUtil().setHeight(1000),
      child: SizedBox(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            // return _goodsItem(list[index]);
            return _productItem(list[index], index, result);
          },
        ),
      ),
    );
  }

  // 计划发货数量
  Widget _shipmentquantity(title, text) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text('$title'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  // padding: EdgeInsets.only(right: 20),
                  child: Text('${text == 'null' ? '' : text}'),
                  // child: CartCount(item, index),
                ),
              )
            ],
          ),
          // Container(
          //   alignment: Alignment.centerRight,
          //   child: Text('已安排123}'),
          // )
        ],
      ),
    );
  }

  // 合并
  Widget _productItem(item, index, result) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          _goodsItem(item),
          _shipmentquantity('计划发货数量', item.planDeliveryNumber),
          _shipmentquantity('实际发货数量', item.actualDeliveryNumber),
          _isReceived(item, result),
          // _shipmentquantity('实际收货数量', item.actualConsigneeNumber),
        ],
      ),
    );
  }

  Widget _isReceived(item, result) {
    if (result.status == 2) {
      return Container(
        padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text('实际收获数量'),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    // padding: EdgeInsets.only(right: 20),
                    child: Text(
                        '${item.actualConsigneeNumber == 'null' ? '' : item.actualConsigneeNumber}'),
                    // child: CartCount(item, index),
                  ),
                )
              ],
            ),
          ],
        ),
      );
      // return _shipmentquantity('实际收货数量', item.actualConsigneeNumber);
    } else {
      return Container(
        child: Text(''),
      );
    }
  }

  // 商品信息
  Widget _goodsItem(item) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(item.skuKey, '')),
            // child: item.skuKey == null || item.skuKey == 'null'
            //     ? Image.asset('images/default.png')
            //     : Image.network(
            //         '${item.skuKey}',
            //         fit: BoxFit.fill,
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
                      fontSize: ScreenUtil().setSp(30),
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
                      color: Color(0xFFCCCCCC),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    '数量：${item.number}',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: ScreenUtil().setSp(30),
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
}

class Quotation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderLook>(builder: (context, child, val) {
      var statusType = {0: '待发货', 1: '已发货', 2: '已收货'};
      var goodsInfo = Provide.value<SalesOrderLook>(context).goodsList;
      if (goodsInfo != null) {
        var result = goodsInfo.result;
        if (result.status == 2) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                _information('质检情况', result.qualityCondition),
                _imageInfomation('收货单', result.consigneeUrls),
              ],
            ),
          );
        } else {
          return Container(
            child: Text(''),
          );
        }
      } else {
        return Text('暂无数据');
      }
    });
  }

  // 组件
  Widget _information(title, content) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text('$title'),
          ),
          Container(
            child: Text('${content == 'null' ? '' : content}'),
          )
        ],
      ),
    );
  }

  Widget _imageInfomation(title, urls) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text('$title'),
          ),
          Container(
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setHeight(300),
            child: urls != null
                ? Image.network(urls[0])
                : Image.asset('images/icon.png'),
            // child: Image.network('${urls != null ? urls[0] : ''}'),
            // 轮播图
            // child: Swiper(
            //   itemBuilder: (BuildContext context, int index) {
            //     return Image.network(
            //         'https://avatar.csdnimg.cn/6/D/B/3_ulddfhv.jpg');
            //   },
            //   itemCount: 1,
            //   itemWidth: 100.0,
            //   pagination: new SwiperPagination(
            //       builder: DotSwiperPaginationBuilder(
            //     color: Colors.black54,
            //     activeColor: Colors.white,
            //   )),
            //   control: new SwiperControl(),
            //   scrollDirection: Axis.horizontal,
            //   autoplay: true,
            //   // layout: SwiperLayout.STACK,
            // ),
          )
        ],
      ),
    );
  }
}
