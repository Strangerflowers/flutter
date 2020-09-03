import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/quotation_detail_plan_provide.dart';
import '../../routers/application.dart';
import './procurement_plan.dart';
import '../../model/quotation_detail_plan_model.dart';

class ProcurementPlan extends StatelessWidget {
  final String goodsId;
  ProcurementPlan(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('采购计划'),
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
    await Provide.value<QuotationPlanProvide>(context)
        .getQuotationPlan(goodsId);
    return '加载完成';
  }
}

// 企业信息
class ExpansionTileDome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<QuotationPlanProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<QuotationPlanProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: ExpansionTile(
              title: Text(
                '基础信息',
                style: TextStyle(color: Colors.black),
              ),
              // trailing: Icon(
              //   Icons.keyboard_arrow_down,
              //   color: Colors.black,
              // ),
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
          child: Text('正在加载...'),
        );
      }
    });
  }

  Widget _mergeInformation(detailData, context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          _purchaseInformation('采购计划编号', detailData.code),
          _purchaseInformation('公司名称', detailData.companyName),
          _purchaseInformation('联系人', detailData.linkPerson),
          _purchaseInformation('联系电话', detailData.linkPhone),
          _purchaseInformation('发布日期', detailData.announceTime),
          _purchaseInformation('采购计划', detailData.name),
          _purchaseInformation('期望交货时间', detailData.deliveryDate),
        ],
      ),
    );
  }

  // 采购计划基础信息
  Widget _purchaseInformation(title, content) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
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

// 信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<QuotationPlanProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<QuotationPlanProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            child: ExpansionTile(
              title: Text(
                '需求商品',
                style: TextStyle(color: Colors.black),
              ),
              // trailing: Icon(
              //   Icons.keyboard_arrow_down,
              //   color: Colors.black,
              // ),
              backgroundColor: Colors.white,
              children: <Widget>[
                _recommedList(goodsInfo.result.groupDetailList),
                _planMark(goodsInfo.result)
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

  // 一级循环渲染
  Widget _recommedList(list) {
    // if (list.length > 0) {
    return Container(
      alignment: Alignment.bottomLeft,
      // height: ScreenUtil().setHeight(1000),
      child: SizedBox(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            // return _planProductHeader(list[index]);
            return _mergePlan(list[index]);
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

  // 合并一二级
  Widget _mergePlan(item) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(children: <Widget>[
        _planProductHeader(item),
        _planProductChild(item.detailList),
        // _planMark(item),
      ]),
    );
  }

  //一级需求产品
  Widget _planProductHeader(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      // padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        '${item.productCategoryName}（共${item.categoryNum}种${item.total}件）',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(32),
          color: Color(0xFF423F42),
        ),
      ),
    );
  }

  //二级需求信息
  Widget _planProduct(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Text(
        '${item.productCategoryName}（${item.num}${item.typeName}）',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
          color: Color(0xFF969497),
        ),
      ),
    );
  }

  //二级需求信息变量渲染
  Widget _planProductChild(item) {
    return Container(
      // padding: EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: ListView.builder(
          itemCount: item.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            return _planProduct(item[index]);
          },
        ),
      ),
      // child: Text('蓝牙无线耳头戴氏可充电（120个）'),
    );
  }

  // 备注
  Widget _planMark(item) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                  fontSize: ScreenUtil().setSp(32),
                  color: Color(0xFF423F42),
                ),
              ),
            ),
            Container(
              child: Text(
                '${item.remark}',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color(0xFF575558),
                    height: 1.5),
              ),
            )
          ],
        ));
  }
}
