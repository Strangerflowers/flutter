// import 'package:bid/pages/component/showPicker.dart';
import 'package:bid/common/toast.dart';
import 'package:bid/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../../models/purchasing_list_model.dart';
import '../../pages/offer/choice_index_page.dart';
import 'package:bid/common/inconfont.dart';

class PurchasingDemand extends StatefulWidget {
  @override
  _PurchasingDemandState createState() => _PurchasingDemandState();
}

class _PurchasingDemandState extends State<PurchasingDemand> {
  var inputText;
  int totalPage;
  var _itemList;
  int pageNum = 1;
  var currentText;
  @override
  void initState() {
    _getdata();
    super.initState();
  }

  // 获取响应数据
  void _getdata() async {
    var formData = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": pageNum,
      "params": {
        "name": currentText,
      }
    };
    await request('listDemand', formData: formData).then((val) {
      if (val['code'] == 0) {
        var goodsList = val;
        totalPage = goodsList['result']['totalPage'];

        if (pageNum == 1) {
          setState(() {
            _itemList = goodsList['result']['list'];
          });
        } else {
          setState(() {
            _itemList.addAll(goodsList['result']['list']);
          });
        }
      } else {
        _itemList = [];
        Toast.toast(context, msg: val['message']);
      }
    });
  }

  Future<void> _handleRefresh() async {
    pageNum = 1;
    await _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            color: Color(0xFFF5F6F8),
            child: Column(
              children: <Widget>[
                _orderType(inputText),
                _goodsList(),
              ],
            ),
          ),
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
            new LinearGradient(colors: [Color(0xFF4CAEFF), Color(0xFF2A83FF)]),
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
          Search(inputText, (val) {
            pageNum = 1;
            setState(() {
              currentText = val;
            });
            _getdata();
          }),
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
                      Image.asset(
                        'images/warehouse.png',
                        width: 30,
                        height: 30,
                      ),
                      // Icon(Iconfont.warehouse, color: Colors.white, size: 30.0),
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
                      Image.asset(
                        'images/quotation.png',
                        width: 30,
                        height: 30,
                      ),
                      // Icon(Iconfont.quotation, color: Colors.white, size: 30.0),
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
                      Image.asset(
                        'images/salesorder.png',
                        width: 30,
                        height: 30,
                      ),
                      // Icon(Iconfont.salesorder,
                      //     color: Colors.white, size: 30.0),
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

  Widget _goodsList() {
    if (_itemList != null && _itemList.length >= 0) {
      return Container(
        child: _demandListView(_itemList),
      );
    } else {
      return Center(
        child: Text('暂无数据'),
      );
    }
  }

  // 一级
  Widget _demandListView(result) {
    return Provide<PurchasingListProvide>(builder: (context, child, data) {
      if (result.length > 0) {
        return Container(
          // height: ScreenUtil().setHeight(1000),
          child: Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Color(0XFFF5F6F8),
              ),
              itemCount: result.length + 1,
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              physics: AlwaysScrollableScrollPhysics(),
              // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
              itemBuilder: (contex, index) {
                //如果到了表尾
                if (index > (result.length - 1)) {
                  //不足100条，继续获取数据
                  if (pageNum < totalPage) {
                    print('获取更多$pageNum====$totalPage');
                    //获取数据
                    pageNum++;
                    _getdata();
                    //加载时显示loading
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 2.0)),
                    );
                  } else {
                    if (result.length == 0) {
                      return Center(child: Text('暂无数据'));
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 16.0, top: 6),
                        child: Text(
                          "没有更多了",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                  }
                }
                return _demandItem(result[index], context);
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
      margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          // 跳转到详情页面
          Application.router
              .navigateTo(context, "/demanddetail?id=${item['id']}");
        },
        child: Column(
          children: <Widget>[
            _title(item['name']),
            _attributes(item),
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      color: Colors.white,
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color(0xFF242526),
          fontSize: ScreenUtil().setSp(28),
          // height: 1.3,
          fontWeight: FontWeight.bold,
          // fontFamily: "Courier",
        ),
      ),
    );
  }

  // 产品属性合并
  Widget _attributes(item) {
    var arr = item['categoryMap'].values;
    // print('修改bug====${item.categoryMap.toJson().values.toList()}');
    return Container(
      alignment: Alignment.bottomLeft,
      child: _attributesItem(arr),
    );
  }

  //单个产品属性
  Widget _attributesItem(item) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    var arr = [];
    item.forEach((val) {
      tiles.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFEAECF0)),
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFFEAECF0),
        ),
        margin: EdgeInsets.only(right: 5.0, bottom: 5),
        padding: EdgeInsets.all(4.0),
        child: Container(
          // alignment: Alignment.centerLeft,
          child: Text(
            '${val}',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              fontWeight: FontWeight.w400,
              color: Color(0xFF656769),
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

  // 需求公司
  Widget _company(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Image.asset(
                'images/companyLabel.png',
                width: ScreenUtil().setWidth(32),
                height: ScreenUtil().setHeight(32),
              )
              // Icon(Iconfont.companyLabel,
              //     color: Color.fromARGB(
              //       255,
              //       82,
              //       160,
              //       255,
              //     ),
              //     size: 20.0),
              ),
          Expanded(
            child: Container(
              child: Text(
                '${item['orgName']}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  color: Color(0xFF9C9FA2),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '${item['announceTimeStr']}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(24),
                color: Color(0xFF9C9FA2),
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
  final Function(String) onChanged;
  Search(
    this.inputText,
    this.onChanged,
  );
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
    // currentText = widget.inputText;
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
          widget.onChanged(currentText);
          // _getSearch();
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
        child: TextField(
          textInputAction: TextInputAction.search,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '搜一搜',
            icon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onEditingComplete: () {
            print('test');
          },
          onSubmitted: (value) {
            setState(() {
              currentText = value;
            });
            _focusNode.unfocus();
            widget.onChanged(currentText);
            // _getSearch();

            print('点击搜索键触发搜索条件value$value');
          },
          onChanged: (value) {
            setState(() {
              currentText = value;
            });
          },
          // onSaved: (value) {
          //   setState(() {
          //     currentText = value;
          //   });
          // },
        ),
      ),
    );
  }

  // // 获取响应数据
  // void _getSearch() async {
  //   var formData = {
  //     "isAll": true,
  //     "limit": 10,
  //     "order": "string",
  //     "page": 1,
  //     "params": {"name": currentText, "productDescript": ""}
  //   };
  //   await request('listDemand', formData: formData).then((val) {
  //     print('采购需求=====$val');
  //     // var data = json.decode(val.toString());
  //     // print('采购需求转换数据json.decode$data');
  //     Purchasing goodsList = Purchasing.fromJson(val);
  //     print('采购需求$val');
  //     Provide.value<PurchasingListProvide>(context)
  //         .getGoodsList(goodsList.result.list);

  //     return Provide.value<PurchasingListProvide>(context).goodsList;
  //   });
  // }
}
