import 'dart:async';

import 'package:bid/common/string_utils.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

import '../../provide/quotation_detail.dart';
import '../../routers/application.dart';

class QuotationDetailPage extends StatelessWidget {
  final String goodsId;
  QuotationDetailPage(this.goodsId);
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
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '报价单详情',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF242526),
            ),
          ),
          backgroundColor: Colors.white,
          // title: Text('报价单详情'),
        ),
        body: FutureBuilder(
          future: _getBackDetailInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ExpansionTileDome(),
                      ProductInformation(),
                    ],
                  ),
                ),
              );
            } else {
              return Text('加载中......');
            }
          },
        ),
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<QuotationDetailProvide>(context)
        .getQuotationDetail(goodsId);
    return '加载完成';
  }
}

// 企业信息
class ExpansionTileDome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<QuotationDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<QuotationDetailProvide>(context).goodsList;
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
                      '需求方信息',
                      style: TextStyle(
                        color: Color(0xff242526),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    // leading: Icon(Icons.ac_unit),
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
        return Container(
          child: Text('正在加载11...'),
        );
      }
    });
  }

  Widget _mergeInformation(detailData, context) {
    var statusType = {0: '已报价', 1: '报价未通过', 2: '报价通过', 3: '部分通过'};
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          _information('报价单编号', detailData.code),
          _information('报价单状态', statusType[detailData.status]),
          _information('需求方名称', detailData.orgName),
          _information('联系人', detailData.linkPerson),
          _information('联系电话', detailData.linkPhone),
          _planClick(
              '采购计划', detailData.demandName, detailData.demandId, context),
        ],
      ),
    );
  }

  // 采购计划
  Widget _planClick(title, content, id, context) {
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: InkWell(
          onTap: () {
            // 跳转到详情页面
            Application.router.navigateTo(context, "/plan?id=$id");
            print('点击跳转采购页面');
          },
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(180),
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: Color(0xff242526),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '$content',
                  style: TextStyle(
                    color: Color(0xff242526),
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
        ));
  }

  // 需求信息
  Widget _information(title, content) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(180),
            child: Text(
              '$title',
              style: TextStyle(
                color: Color(0xff242526),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
          Container(
            child: Text(
              '$content',
              style: TextStyle(
                color: Color(0xff242526),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 产品信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<QuotationDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<QuotationDetailProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
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
                        color: Color(0xff242526),
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
                      _recommedList(goodsInfo.result.detailList),
                      _totalPrice(goodsInfo.result),
                      _planMark(goodsInfo.result),
                      // _productItem(),
                    ],
                    initiallyExpanded: true, //是否默认打开？
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(child: Text('加载中......'));
      }
    });
  }

  // 循环渲染
  // 一级
  Widget _recommedList(list) {
    return Container(
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
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          _productTitle(item),
          _goodsItem(item),
          _sumPrice(item),
        ],
      ),
    );
  }

  Widget _productTitle(item) {
    var statusType = {
      0: 'images/r643.png',
      1: 'images/r641.png',
      2: 'images/r63f.png'
    };
    // var statusType = {0: 0xe643, 1: 0xe641, 2: 0xe63f};  images/r643.png
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
                          width: ScreenUtil().setWidth(160),
                          child: Text(
                            '对应产品：',
                            style: TextStyle(
                              color: Color(0xff242526),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(350),
                          child: Text(
                            '${item.productDescript}',
                            style: TextStyle(
                              color: Color(0xff242526),
                              fontSize: ScreenUtil().setSp(28),
                            ),
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
                          width: ScreenUtil().setWidth(160),
                          child: Text(
                            '需求数量：',
                            style: TextStyle(
                              color: Color(0xff242526),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(350),
                          child: Text(
                            '${item.num} ${item.typeName}',
                            style: TextStyle(
                              color: Color(0xff242526),
                              fontSize: ScreenUtil().setSp(28),
                            ),
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
          Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(120),
            margin: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            // 0:审核中  1:审核不通过  2:审核通过
            // child: Icon(
            //     IconData(statusType[item.status], fontFamily: 'iconfont'),
            //     color: Color(statusColor[item.status]),
            //     size: 42.0),
            child: Image.asset(
              statusType[item.status],
              width: 40,
              height: 40,
            ),
          )
        ],
      ),
    );
  }

  // 商品信息
  Widget _goodsItem(item) {
    String str = '';
    if (item.skuValueList.length > 0) {
      str = (item.skuValueList.join(",")).replaceAll(",", ";");
      print('字符串拼接$str');
    }
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Container(
            // alignment: Alignment.topCenter,
            width: ScreenUtil().setWidth(140),
            height: ScreenUtil().setHeight(140),
            padding: EdgeInsets.only(right: 10),
            child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(item.skuUrl, '')),
            // child: Image.network(
            //   '${item.skuUrl}',
            //   fit: BoxFit.cover,
            //   width: ScreenUtil().setWidth(150),
            //   height: ScreenUtil().setHeight(150),
            // ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    // '12323',
                    '${item.skuName}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xff242526),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    '￥${(item.amount / 100).toStringAsFixed(2)}',
                    // '${item.productDescript}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xff242526),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    // '规格：${item.skuValueList}',
                    '规格：$str',
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
                    '数量：${item.num} ${item.typeName}',
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
    );
  }

  // 小计
  Widget _sumPrice(item) {
    double sum = 0.0;
    sum = item.num * item.amount / 100;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      alignment: Alignment.centerRight,
      width: ScreenUtil().setWidth(700),
      child: RichText(
        text: TextSpan(
            text: '小计：',
            style: TextStyle(
              color: Color(0xFF242526),
              fontSize: ScreenUtil().setSp(24),
            ),
            children: <TextSpan>[
              TextSpan(
                text: '￥${sum.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Color(0xFFFF9B00),
                ),
              ),
            ]),
      ),
    );
  }

  // 合计
  Widget _totalPrice(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 30, 20),
      alignment: Alignment.bottomRight,
      // width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5, //宽度
            color: Colors.grey, //边框颜色
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
            text: '共计：',
            style: TextStyle(
              color: Color(0xFF242526),
              fontSize: ScreenUtil().setSp(24),
            ),
            children: <TextSpan>[
              TextSpan(
                text: '￥${(item.totalAmount / 100).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Color(0xFFFF9B00),
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ]),
      ),
    );
  }

  // 备注
  Widget _planMark(item) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        margin: EdgeInsets.only(bottom: 40),
        // padding: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '备注',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242526),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${item.remark == 'null' || item.remark == null ? '' : item.remark}',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Color(0xFF242526),
                    height: 1.5),
              ),
            )
          ],
        ));
  }
}
