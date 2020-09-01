import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provide/provide.dart';
import '../../provide/purchasing_list_provide.dart';
import '../../routers/application.dart';

import '../signup/signin.dart';
import '../signup/register.dart';
import '../goods_warehouse/goods_detail_page.dart';
import '../goods_warehouse/goods_page.dart';
import '../sales_order/sales_index_page.dart';
import '../quotation/quotation_index_page.dart';
import '../../service/service_method.dart';
import '../../model/purchasing_list_model.dart';
import '../../pages/offer/choice_index_page.dart';
// import '../../pages/offer/index.dart';

class PurchasingDemand extends StatefulWidget {
  @override
  _PurchasingDemandState createState() => _PurchasingDemandState();
}

class _PurchasingDemandState extends State<PurchasingDemand> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new PreferredSize(
      //   child: new Container(
      //     padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      //     child: new Padding(
      //       padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
      //       child: new Text(
      //         '需求',
      //         style: new TextStyle(
      //           fontSize: 20.0,
      //           // fontWeight: FontWeight.w500,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //     decoration: new BoxDecoration(
      //         gradient: new LinearGradient(
      //             colors: [Color(0xFF53AEFE), Color(0xFF2B85FF)]),
      //         boxShadow: [
      //           new BoxShadow(
      //             color: Color(0xFF2B85FF),
      //             blurRadius: 20.0,
      //             spreadRadius: 1.0,
      //           )
      //         ]),
      //   ),
      //   preferredSize: new Size(MediaQuery.of(context).size.width, 150.0),
      // ),
      body:
          // FutureBuilder(
          //     future: _getBackDetailInfo(context),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         //
          //         return ListView(
          //           children: <Widget>[
          //             _orderType(),
          //             DemandContent(),
          //           ],
          //         );
          //       } else {
          //         return Container(
          //           child: Text('暂无数据'),
          //         );
          //       }
          //     })
          Center(
        child: ListView(
          children: <Widget>[
            // Search(),
            _orderType(),
            DemandContent(),
            // _logout(),
            // _login(),
            _detail(),
            _choice(),
          ],
        ),
      ),
    );
  }

//类别
  Widget _orderType() {
    return Container(
      // margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      // height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
      decoration: new BoxDecoration(
        gradient:
            new LinearGradient(colors: [Color(0xFF53AEFE), Color(0xFF2B85FF)]),
        boxShadow: [
          new BoxShadow(
            color: Color(0xFF2B85FF),
            blurRadius: 20.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(70),
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 15.0, top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(29.5),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                icon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GoodsIndexPage();
                      },
                    ),
                  );
                },
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  child: Column(
                    children: <Widget>[
                      Icon(IconData(0xe650, fontFamily: 'iconfont'),
                          color: Colors.white, size: 30.0),
                      Text(
                        '商品库',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return QuotationIndexPage();
                      },
                    ),
                  );
                },
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  child: Column(
                    children: <Widget>[
                      Icon(IconData(0xe64b, fontFamily: 'iconfont'),
                          color: Colors.white, size: 30.0),
                      Text(
                        '报价单',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SalesIndexPage();
                      },
                    ),
                  );
                },
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  child: Column(
                    children: <Widget>[
                      Icon(IconData(0xe651, fontFamily: 'iconfont'),
                          color: Colors.white, size: 30.0),
                      Text(
                        '销售订单',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      // color: Colors.blueAccent,
    );
  }

// 跳转登录页面
  Widget _logout() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                // return FormTestRoute();
                return Register();
              },
            ),
          );
        },
        child: Text('注册'),
      ),
    );
  }

  // 跳转登录页面
  Widget _login() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormTestRoute();
                // return Register();
              },
            ),
          );
        },
        child: Text('登录'),
      ),
    );
  }

  // 跳转登录页面
  Widget _choice() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChoiceIndex('1');
                // return Register();
              },
            ),
          );
        },
        child: Text('登录'),
      ),
    );
  }

  // 跳转到商品详情页面
  Widget _detail() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return GoodsDetailsPage('1');
                // return Register();
              },
            ),
          );
        },
        child: Text('商品详情'),
      ),
    );
  }

  // 获取需求列表数据
}

// 需求列表
class DemandContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Provide<PurchasingListProvide>(builder: (context, child, data) {
    //   if (data.goodsList != null) {
    return InkWell(
      child: Container(
        child: FutureBuilder(
          future: _getBackDetailInfo(context),
          builder: (context, snapshot) {
            print('99999${snapshot.hasData}');
            return Container(
              child: _demandListView(),
            );
          },
        ),
      ),
    );
    //   } else {
    //     return Container(
    //       child: Text('暂无数据'),
    //     );
    //   }
    // });
  }

  // 循环渲染

  // 获取响应数据
  Future _getBackDetailInfo(BuildContext context) async {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": 1,
      "params": {"name": "", "productDescript": ""}
    };
    await request('listDemand', formData: formData).then((val) {
      print('采购需求=====$val');
      // var data = json.decode(val.toString());
      // print('采购需求转换数据json.decode$data');
      Purchasing goodsList = Purchasing.fromJson(val);
      print('采购需求$val');
      Provide.value<PurchasingListProvide>(context)
          .getGoodsList(goodsList.result.list);

      return '加载完成';
    });
  }

  // 一级
  Widget _demandListView() {
    return Provide<PurchasingListProvide>(builder: (context, child, data) {
      if (data.goodsList != null) {
        return Container(
          height: ScreenUtil().setHeight(1000),
          child: SizedBox(
            child: ListView.builder(
              itemCount: data.goodsList.length,
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              physics: NeverScrollableScrollPhysics(), //禁用滑动事件
              itemBuilder: (contex, index) {
                return _demandItem(data.goodsList[index], context);
              },
            ),
          ),
        );
      } else {
        return Container(
          child: Text('暂无数据'),
        );
      }
    });
  }

  // 单项列表数据
  Widget _demandItem(item, context) {
    // var str = '我需要卓越Q3电子产品采购咨询价需求紧急尽快报价主要需求需要耳机和笔记本电脑';
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          // 跳转到详情页面
          Application.router.navigateTo(context, "/demanddetail?id=${item.id}");
        },
        child: Column(
          children: <Widget>[
            _title(item.name),
            _attributes(item),
            // _attributes(),
            _company(item),
          ],
        ),
      ),
    );
  }

  // 标题内容
  Widget _title(title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color(0xFF252527),
          fontSize: 16.0,
          height: 1.3,
          fontWeight: FontWeight.w500,
          fontFamily: "Courier",
        ),
      ),
    );
  }

  // Widget buildGrid() {
  //   List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
  //   Widget content; //单独一个widget组件，用于返回需要生成的内容widget
  //   for (var item in formList) {
  //     tiles.add(new Row(children: <Widget>[
  //       new Icon(Icons.alarm),
  //       new Text(item['title']),
  //     ]));
  //   }
  //   content = new Column(
  //       children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
  //       //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
  //       );
  //   return content;
  // }

  // 产品属性合并
  Widget _attributes(item) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: _attributesItem(item),
    );
  }

  //单个产品属性
  Widget _attributesItem(item) {
    // var arr = [];
    // item.demandDetailDtoList.forEach((val) {
    //   arr.add(val.productCategroyPath.substring(1));
    //   // print('遍历数组$val');
    // });

    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    var arr = [];
    item.demandDetailDtoList.forEach((val) {
      tiles.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE9E2EE)),
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFFECECEE),
        ),
        margin: EdgeInsets.only(right: 5.0, bottom: 5),
        padding: EdgeInsets.all(3.0),
        child: Container(
          // alignment: Alignment.centerLeft,
          child: Text(
            '${val.productCategroyPath.substring(1)}',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              color: Color(0xFF78777A),
            ),
          ),
        ),
      ));
    });
    content = new Wrap(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
        );
    return content;

    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Color(0xFFE9E2EE)),
    //     borderRadius: BorderRadius.circular(5),
    //     color: Color(0xFFECECEE),
    //   ),
    //   margin: EdgeInsets.only(right: 5.0),
    //   padding: EdgeInsets.all(3.0),
    //   child: Text(
    //     '${arr.toString()}',
    //     style: TextStyle(
    //       color: Color(0xFF78777A),
    //     ),
    //   ),
    // );
    // }
  }

  Widget _text(item) {
    return Container(
      child: Text(
        '1232',
        style: TextStyle(
          color: Color(0xFF78777A),
        ),
      ),
    );
  }

  // 需求公司
  Widget _company(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(IconData(0xe64e, fontFamily: 'iconfont'),
                color: Color.fromARGB(
                  255,
                  82,
                  160,
                  255,
                ),
                size: 20.0),
          ),
          Expanded(
            child: Container(
              child: Text(
                '${item.orgName}',
                style: TextStyle(
                  color: Color(0xFFA1A0A3),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '${item.announceTime}',
              style: TextStyle(
                color: Color(0xFFA1A0A3),
              ),
            ),
          )
        ],
      ),
    );
  }
}
