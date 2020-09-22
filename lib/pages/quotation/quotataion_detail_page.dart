import 'dart:async';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('报价单详情'),
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
            child: ExpansionTile(
              title: Text(
                '需求方信息',
                style: TextStyle(color: Colors.black),
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
                child: Text('$title'),
              ),
              Expanded(
                child: Text('$content'),
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
            child: Text('$title'),
          ),
          Container(
            child: Text('$content'),
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
            child: ExpansionTile(
              title: Text(
                '产品信息',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              // Container(
              //   width: ScreenUtil().setWidth(80),
              //   child: Row(
              //     children: <Widget>[
              //       Text('收起'),
              //       Icon(
              //         Icons.keyboard_arrow_down,
              //         color: Colors.black,
              //       ),
              //     ],
              //   ),
              // ),

              backgroundColor: Colors.white,
              children: <Widget>[
                _recommedList(goodsInfo.result.detailList)
                // _productItem(),
              ],
              initiallyExpanded: true, //是否默认打开？
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
    // if (list.length > 0) {
    return Container(
      height: ScreenUtil().setHeight(1000),
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
                          width: ScreenUtil().setWidth(160),
                          child: Text('对应产品：'),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: ScreenUtil().setWidth(350),
                          child: Text(
                            '${item.productDescript}',
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
          Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(120),
            margin: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            // 0:审核中  1:审核不通过  2:审核通过
            child: Icon(
                IconData(statusType[item.status], fontFamily: 'iconfont'),
                color: Color(statusColor[item.status]),
                size: 42.0),
            // child: Image.asset('images/icon.png'),
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
              // width: ScreenUtil().setWidth(120),
              // height: ScreenUtil().setHeight(120),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: Image.network(
                '${item.skuUrl}',
                fit: BoxFit.cover,
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(150),
              )
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
                    '${item.skuName}',
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
                    '￥${item.amount}',
                    // '${item.productDescript}',
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
                    '规格：$str',
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
                    '数量：${item.num} ${item.typeName}',
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

  // 合计
  Widget _sumPrice(item) {
    double sum = 0.0;
    sum = item.num * item.amount;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      alignment: Alignment.centerRight,
      width: ScreenUtil().setWidth(700),
      // child: Expanded(
      child: Row(
        children: <Widget>[
          Text('小计：'),
          Text(
            '￥$sum',
            style: TextStyle(
              color: Color(0xFFF2A631),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
