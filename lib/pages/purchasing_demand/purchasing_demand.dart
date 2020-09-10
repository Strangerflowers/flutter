// import 'package:bid/pages/component/showPicker.dart';
import 'package:bid/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bid/common/home_loading.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:provide/provide.dart';
import '../../provide/purchasing_list_provide.dart';
import '../../routers/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../signup/signin.dart';
import '../signup/register.dart';
import '../goods_warehouse/goods_detail_page.dart';
import '../goods_warehouse/goods_page.dart';
import '../sales_order/sales_index_page.dart';
import '../quotation/quotation_index_page.dart';
import '../../service/service_method.dart';
import '../../model/purchasing_list_model.dart';
import '../../pages/offer/choice_index_page.dart';

class PurchasingDemand extends StatefulWidget {
  @override
  _PurchasingDemandState createState() => _PurchasingDemandState();
}

class _PurchasingDemandState extends State<PurchasingDemand> {
  // FocusNode myFocusNode;
  var inputText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            _orderType(inputText),
            DemandContent(inputText),
          ],
        ),
      ),
    );
  }

//类别
  Widget _orderType(inputText) {
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
          Search(inputText),
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
}

// 获取需求列表数据
// 需求列表
class DemandContent extends StatefulWidget {
  final inputText;
  DemandContent(this.inputText);
  @override
  _DemandContentState createState() => _DemandContentState();
}

class _DemandContentState extends State<DemandContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// class DemandContent extends StatelessWidget {
  var hasToken;
  @override
  Widget build(BuildContext context) {
    // return Provide<PurchasingListProvide>(builder: (context, child, data) {
    //   if (data.goodsList != null) {
    return InkWell(
      child: Container(
        child: FutureBuilder(
          future: _getBackDetailInfo(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              print(
                  '99999111111${snapshot.hasData}===${hasToken != null}==${widget.inputText}');
              var data = snapshot.data;
              if (null != data && data['success'] == true) {
                return Container(
                  child: _demandListView(),
                );
              } else {
                if (hasToken != '') {
                  return Container(
                    child: Text('暂无数据'),
                  );
                } else {
                  return _logOut(context);
                }
              }
            }

            return SizedBox(
              width: 24.0,
              height: 24.0,
              child: Text('正在加载中。。。。。。'),
              // child: CircularProgressIndicator(strokeWidth: 2.0),
            );
          },
        ),
      ),
    );
  }

  _getToken() async {
    hasToken = null;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    hasToken = token;
    return token;
  }

  Widget _logOut(context) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    return AlertDialog(
      title: Text('提示'),
      content: Text('您还未登录，请先登录'),
      actions: <Widget>[
        FlatButton(
          child: Text('确认'),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final result = await prefs.clear();
            if (result) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/loginPage", ModalRoute.withName("/loginPage"));
              // Navigator.of(context).pop('cancel');
              // Application.router.navigateTo(context, '/sigin');
            }
          },
        ),
      ],
    );
    //   },
    // );
  }

  // 循环渲染

  // 获取响应数据
  Future _getBackDetailInfo(BuildContext context) async {
    hasToken = null;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    hasToken = token;
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

      return Provide.value<PurchasingListProvide>(context).goodsList;
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

class Search extends StatefulWidget {
  final inputText;
  Search(this.inputText);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  final _searchKey = new GlobalKey<FormState>();
  FocusNode _focusNode;
  // 当前键盘是否是激活状态
  bool isKeyboardActived = false;
  var currentText;
  @override
  void initState() {
    super.initState();
    currentText = widget.inputText;
    _focusNode = FocusNode();
    // 监听输入框焦点变化
    _focusNode.addListener(_onFocus);
    // 创建一个界面变化的观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 当前是安卓系统并且在焦点聚焦的情况下
      if (Platform.isAndroid && _focusNode.hasFocus) {
        if (isKeyboardActived) {
          isKeyboardActived = false;
          _searchKey.currentState.save();
          _getSearch();
          // 使输入框失去焦点
          _focusNode.unfocus();
          return;
        }
        isKeyboardActived = true;
      }
    });
  }

  // 既然有监听当然也要有卸载，防止内存泄漏嘛
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // 焦点变化时触发的函数
  _onFocus() {
    if (_focusNode.hasFocus) {
      // 聚焦时候的操作
      return;
    }

    // 失去焦点时候的操作
    isKeyboardActived = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(70),
      padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(bottom: 15.0, top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: Form(
        key: _searchKey,
        child: TextFormField(
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search',
            icon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              currentText = value;
            });
          },
          onSaved: (value) {
            setState(() {
              currentText = value;
            });
          },
        ),
      ),
    );
  }

  // 获取响应数据
  void _getSearch() async {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": 1,
      "params": {"name": currentText, "productDescript": ""}
    };
    await request('listDemand', formData: formData).then((val) {
      print('采购需求=====$val');
      // var data = json.decode(val.toString());
      // print('采购需求转换数据json.decode$data');
      Purchasing goodsList = Purchasing.fromJson(val);
      print('采购需求$val');
      Provide.value<PurchasingListProvide>(context)
          .getGoodsList(goodsList.result.list);

      return Provide.value<PurchasingListProvide>(context).goodsList;
    });
  }
}
