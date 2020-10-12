import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/demand_detail_provide.dart';
import './details/detail_bottom.dart';
import '../../models/demand_detail_model.dart';
import '../../routers/application.dart';

class DemandDetails extends StatelessWidget {
  final String demandId;
  DemandDetails(this.demandId);
  @override
  Widget build(BuildContext context) {
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
              Application.router
                  .navigateTo(context, "/demandList", clearStack: true);
              // Navigator.pop(context);
            },
          ),
          title: Text(
            '需求详情',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: _getBackDetailInfo(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              print(
                  'snapshot.hasData====================================>${Provide.value<DemandDetailProvide>(context).goodsList}');
              // if (snapshot.data != null) {
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      color: Color(0XFFF5F6F8),
                      margin: EdgeInsets.only(bottom: 40),
                      constraints: BoxConstraints(
                        // minWidth: 180,
                        minHeight: MediaQuery.of(context).size.height - 126,
                      ),
                      child: Column(
                        children: <Widget>[
                          ExpansionTileDome(),
                          ProductInformation(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    left: 0,
                    right: 0,
                    child: DemandDetailBottom(demandId),
                  )
                ],
              );
              // } else {
              //   return Text('暂无数据');
              // }
            }
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .7,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<DemandDetailProvide>(context)
        .getDemandDetailData(demandId);
    return Provide.value<DemandDetailProvide>(context).goodsList;
    // return "加载完成";
  }
}

// 企业信息
class ExpansionTileDome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: Column(
              // title: Text(
              //   '基础信息',
              //   style: TextStyle(
              //     color: Color(0XFF242526),
              //     fontSize: ScreenUtil().setSp(32),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // backgroundColor: Colors.white,
              children: <Widget>[
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 17,
                      // bottom: 10,
                      child: Container(
                        width: ScreenUtil().setWidth(10),
                        height: ScreenUtil().setHeight(46),
                        color: Color(0xFF2A83FF),
                        child: Text(''),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 16, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '基础信息',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff242526),
                        ),
                      ),
                    )
                  ],
                ),
                _mergeInformation(goodsInfo.result, context),
              ],
              // initiallyExpanded: true, //是否默认打开？
            ),
          ),
        );
      } else {
        return Container(
          child: Text(''),
        );
      }
    });
  }

  Widget _mergeInformation(detailData, context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          _purchaseInformation('需求方名称', detailData.orgName),
          _purchaseInformation('联系人', detailData.linkPerson),
          _purchaseInformation('联系电话', detailData.linkPhone),
          _purchaseInformation('发布日期', detailData.announceTimeStr),
          _purchaseInformation('采购计划', detailData.name),
          _purchaseInformation('期望交货时间', detailData.deliveryDateStr),
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
            child: Text(
              '$title',
              style: TextStyle(
                color: Color(0XFF242526),
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text('$content'),
            ),
          ),
        ],
      ),
    );
  }
}

// 信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).goodsList;
      // print('7899${goodsInfo.result.demandSkuDtoList}');
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              // title: Text(
              //   '需求产品',
              //   style: TextStyle(color: Colors.black),
              // ),
              // backgroundColor: Colors.white,
              children: <Widget>[
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 17,
                      // bottom: 0,
                      child: Container(
                        width: ScreenUtil().setWidth(10),
                        height: ScreenUtil().setHeight(46),
                        color: Color(0xFF2A83FF),
                        child: Text(''),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '需求产品',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff242526),
                        ),
                      ),
                    )
                  ],
                ),
                _recommedList(goodsInfo.result.demandSkuDtoList),
                _planMark(goodsInfo.result),
              ],
              // initiallyExpanded: true, //是否默认打开？
            ),
          ),
        );
      } else {
        return Container(child: Text('暂无数据'));
      }
    });
  }

  // 一级循环渲染
  Widget _recommedList(result) {
    // if (list.length > 0) {
    return Container(
      alignment: Alignment.bottomLeft,
      // height: ScreenUtil().setHeight(1000),
      child: SizedBox(
        child: ListView.builder(
          itemCount: result.length,
          // itemCount: result.demandDetailDtoList.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            return _mergePlan(result[index], index);
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
  Widget _mergePlan(item, index) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
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
        _planProductChild(item.demandDetailDtoList),
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
        '${item.productCategroyPath}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(28),
          color: Color(0xFF242526),
        ),
      ),
    );
  }

  //二级需求信息
  Widget _planProduct(item) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(550.0),
            child: Text(
              '${item.productDescript}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(28),
                color: Color(0xFF242526),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text(
                '${item.num}${item.type}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(28),
                  color: Color(0xFF9C9FA2),
                ),
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
    );
  }

  // 备注
  Widget _planMark(item) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 5),
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
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(28),
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
