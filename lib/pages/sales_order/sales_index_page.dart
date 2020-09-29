import 'package:bid/common/inconfont.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/models/sales_order_list_model.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

import '../../provide/sales_order_list_provide.dart';
import '../../routers/application.dart';
import '../../service/service_method.dart';

class SalesIndexPage extends StatefulWidget {
  @override
  _SalesIndexPageState createState() => _SalesIndexPageState();
}

class _SalesIndexPageState extends State<SalesIndexPage> {
  var _itemList;
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];
  var scorllController = new ScrollController();
  int ststes;
  var getData;
  int currentTabs = 0;
  int preTabs = 0;
  int pageNum = 1;
  int totalPage;
  List list = ['待确认', '待发货', '已发货', '已完成'];

  void initState() {
    _getSaleasOrderList();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    pageNum = 1;
    await _getSaleasOrderList();
  }

  // 获取列表数据
  void _getSaleasOrderList() async {
    if (pageNum == 1) {
      setState(() {
        _itemList = null;
      });
    }
    var data = {
      "isAll": true,
      "limit": 10,
      "order": "string",
      "page": pageNum,
      "pageMap": {},
      "params": {"merchantId": "1", "status": currentTabs + 1}
    };
    await request('soQueryPage', formData: data).then((val) {
      SalesRoder goodsList = SalesRoder.fromJson(val);
      totalPage = goodsList.result.totalPage;

      if (pageNum == 1) {
        goodsList.result.list.forEach((element) {
          element.isOpen = false;
        });
        setState(() {
          _itemList = goodsList.result.list;
        });
        print('拿到的字段￥${_itemList}');
      } else {
        goodsList.result.list.forEach((element) {
          element.isOpen = false;
        });
        setState(() {
          _itemList.addAll(goodsList.result.list);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Container(
          child: Column(
            children: <Widget>[
              _salesTabs(list),
              _goodsList(_itemList),
              // SalesTabs(),
              // SalesGoodsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _salesTabs(list) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: ScreenUtil().setHeight(93),
      // width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _typeWell(list[index], index);
        },
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
      ),
      // ),
    );
  }

  Widget _typeWell(item, int index) {
    bool isClick = false;
    isClick = (index == currentTabs ? true : false);
    return InkWell(
      onTap: () {
        // setState(() {
        preTabs = currentTabs;
        pageNum = 1;
        // statuss = Provide.value<SalesOrderListProvide>(context).status;
        currentTabs = index;
        // });
        if (preTabs != currentTabs) {
          setState(() {});
          _getSaleasOrderList();
        }
      },
      child: Container(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(187),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 8.0),
                // padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isClick ? Color(0xFF4389ED) : Colors.black,
                    // decoration: TextDecoration.underline, //给文字添加下划线
                    fontSize: ScreenUtil().setSp(30),
                    // height: 1.5,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: isClick ? Color(0xFF4389ED) : Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 商品列表
  Widget _goodsList(result) {
    if (_itemList != null && _itemList.length >= 0) {
      try {
        if (pageNum == 1) {
          // 如果列表page==1，列表位置放到最顶部
          scorllController.jumpTo(0.0);
        }
      } catch (e) {
        print('进入页面第一次初始化：${e}');
      }
      return Container(
        child: Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: .0),

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
                  _getSaleasOrderList();
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
                    return Center(
                      child: Text('暂无数据'),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "没有更多了",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                }
              }
              return _mergeWidget(result[index]);
            },
          ),
        ),
      );
    } else {
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
    }
  }

  // 循环组件整个item（包括公司以及所属产品）
  Widget _salesOrderItem(list) {
    if (list.length > 0) {
      return Expanded(
        child: Container(
          child: SizedBox(
            child: ListView.builder(
              controller: scorllController,
              itemCount: list.length,
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
              itemBuilder: (contex, index) {
                return _mergeWidget(list[index]);
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无数据'),
      );
    }
  }

  // 合并一级组件
  Widget _mergeWidget(item) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // 跳转到详情页面
          Application.router.navigateTo(context, "/salesdetail?id=${item.id}");
          print('点击跳转采购页面');
        },
        child: Column(
          children: <Widget>[
            _company(item),
            _secondLevelListView(item.orderItems, item),
            _expandedBotton(item),
          ],
        ),
      ),
    );
  }

  // 遍历二级
  Widget _secondLevelListView(subList, item) {
    if (subList.length > 0) {
      return Container(
        child: SizedBox(
          child: ListView.builder(
            itemCount: item.isOpen ? subList.length : 1,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _mergeSecondLevel(subList[index]);
              // return Text('商品列表');
            },
          ),
        ),
        // ),
      );
    } else {
      return Container(
        child: Text('暂无商品数据'),
      );
    }
  }

  // 合并二级组件
  Widget _mergeSecondLevel(subItem) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
            // width: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(top: 0, right: 10, bottom: 10),
            child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(subItem.mainKey, '')),
            // child: subItem.mainKey == null
            //     ? Image.asset('images/default.png')
            //     : Image.network(
            //         subItem.mainKey,
            //         fit: BoxFit.fill,
            //       ),
          ),
          Expanded(
            child: _right(subItem),
          ),
        ],
      ),
    );
  }

  // 收起展开按钮
  Widget _expandedBotton(item) {
    if (item.orderItems != null && item.orderItems.length > 1) {
      return Container(
        width: ScreenUtil().setWidth(750),
        child: InkWell(
          onTap: () {
            print('点击展开收起${item.isOpen}');
            setState(() {
              item.isOpen = !item.isOpen;
            });
          },
          // child: Icon(Iconfont.down),
          child: item.isOpen
              ? Icon(
                  Icons.keyboard_arrow_up,
                  size: 35,
                  color: Color(0xFFCCCCCC),
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFCCCCCC),
                  size: 35,
                ),
        ),
      );
    } else {
      return Container(
        height: 0,
        child: Text(''),
      );
    }
  }

  // 需求公司
  Widget _company(item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Image.asset(
              'images/companyLabel.png',
              width: 20,
              height: 20,
            ),
            // child: Icon(Iconfont.companyLabel,
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
                '${item.demanderDeptName}',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: ScreenUtil().setSp(32),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '共${item.orderItems.length}种${item.totalNumber}件',
              style: TextStyle(
                color: Color(0xFFA1A0A3),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _right(subItem) {
    return Container(
      // width: ScreenUtil().setWidth(600),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${subItem.productName}',
              maxLines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              // '规格：${item.skuValueList}',
              '规格：${subItem.specification}',
              style: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '数量：${subItem.number}',
              style: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class SalesTabs extends StatefulWidget {
//   @override
//   _SalesTabsState createState() => _SalesTabsState();
// }

// class _SalesTabsState extends State<SalesTabs> {
//   List list = ['待确认', '待发货', '已发货', '已完成'];
//   int listIndex = 0;
//   int statuss = 1;
//   @override
//   void initState() {
//     _getSaleasOrderList();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Provide<SalesOrderListProvide>(builder: (context, child, data) {
//       if (listIndex == 0) {
//         Provide.value<SalesOrderListProvide>(context)
//             .changeChildIndex(listIndex);
//       }
//       if (data.goodsList != []) {
//         return Container(
//           margin: EdgeInsets.only(bottom: 20),
//           height: ScreenUtil().setHeight(93),
//           // width: ScreenUtil().setWidth(750),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border(
//               bottom: BorderSide(width: 1, color: Colors.black12),
//             ),
//           ),
//           child: ListView.builder(
//             itemBuilder: (context, index) {
//               return _typeWell(list[index], index);
//             },
//             itemCount: list.length,
//             scrollDirection: Axis.horizontal,
//           ),
//           // ),
//         );
//       } else {
//         return Container(
//           child: Text('暂无数据'),
//         );
//       }
//     });
//   }

//   Widget _typeWell(item, int index) {
//     bool isClick = false;
//     isClick = (index == Provide.value<SalesOrderListProvide>(context).childIndex
//         ? true
//         : false);
//     return InkWell(
//       onTap: () {
//         Provide.value<SalesOrderListProvide>(context).changeChildIndex(index);
//         setState(() {
//           statuss = Provide.value<SalesOrderListProvide>(context).status;
//           listIndex = index;
//         });
//         _getSaleasOrderList();
//         print('$isClick');
//       },
//       child: Container(
//         child: Container(
//           alignment: Alignment.center,
//           width: ScreenUtil().setWidth(187),
//           child: Column(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 8.0),
//                 // padding: EdgeInsets.only(bottom: 20),
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     color: isClick ? Color(0xFF4389ED) : Colors.black,
//                     // decoration: TextDecoration.underline, //给文字添加下划线
//                     fontSize: ScreenUtil().setSp(30),
//                     // height: 1.5,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 20,
//                 height: 2,
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                       color: isClick ? Color(0xFF4389ED) : Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 获取列表数据
//   void _getSaleasOrderList() async {
//     var data = {
//       "isAll": true,
//       "limit": 10,
//       "order": "string",
//       "page": 1,
//       "pageMap": {},
//       "params": {"merchantId": "1", "status": statuss}
//     };
//     await request('soQueryPage', formData: data).then((val) {
//       // var res = json.decode(val.toString());
//       // print('获取商品列表页数据1S$res------------------------------');
//       // print('123456${val}');

//       // 使用状态管理的方式
//       SalesRoder goodsList = SalesRoder.fromJson(val);
//       if (goodsList.result.list == null) {
//         Provide.value<SalesOrderListProvide>(context).getGoodsList([]);
//       } else {
//         Provide.value<SalesOrderListProvide>(context)
//             .getGoodsList(goodsList.result.list);
//       }

//       // setState(() {
//       //   list = goodsList.result.list;
//       // });
//       // print('获取商品列表页数据1S${list[0].orgName}');
//     });
//   }
// }

// // 商品列表
// class SalesGoodsList extends StatefulWidget {
//   @override
//   _SalesGoodsListState createState() => _SalesGoodsListState();
// }

// class _SalesGoodsListState extends State<SalesGoodsList> {
//   @override
//   void initState() {
//     // _getGoodsList();
//     // TODO: implement initState
//     super.initState();
//   }

//   GlobalKey<RefreshFooterState> _footerkey =
//       new GlobalKey<RefreshFooterState>();
//   var scorllController = new ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Provide<SalesOrderListProvide>(builder: (context, child, data) {
//       if (data.goodsList != null) {
//         return Expanded(
//           child: Container(
//             child: EasyRefresh(
//               refreshFooter: ClassicsFooter(
//                 key: _footerkey,
//                 bgColor: Colors.white,
//                 textColor: Colors.pink,
//                 moreInfoColor: Colors.pink,
//                 showMore: true,
//                 // noMoreText: Provide.value<ChildCategory>(context).noMoreText,
//                 moreInfo: '加载中',
//                 loadReadyText: '上拉加载',
//               ),
//               child: ListView.builder(
//                 itemCount: data.goodsList.length,
//                 shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
//                 // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
//                 itemBuilder: (contex, index) {
//                   return _mergeWidget(data.goodsList[index]);
//                 },
//               ),
//               loadMore: () async {
//                 // 上拉加载更多的回调方法
//                 _getMoreList();
//                 print('上拉加载更多......');
//               },
//             ),
//           ),
//         );
//       } else {
//         return Container(
//           child: Text('暂无数据'),
//         );
//       }
//     });
//   }

//   // 上拉加载更多
//   void _getMoreList() async {
//     Provide.value<SalesOrderListProvide>(context).addPage();
//     var data = {
//       "isAll": true,
//       "limit": 10,
//       "order": "string",
//       "page": Provide.value<SalesOrderListProvide>(context).page,
//       "pageMap": {},
//       "params": {
//         "merchantId": "1",
//         "status": Provide.value<SalesOrderListProvide>(context).status,
//       }
//     };
//     print('查看参数$data');
//     await request('soQueryPage', formData: data).then((val) {
//       // 使用状态管理的方式
//       SalesRoder goodsList = SalesRoder.fromJson(val);

//       if (goodsList.result.list.length <= 0 || goodsList.result.list == null) {
//         Fluttertoast.showToast(
//           msg: '已经到底了',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.pink,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//         Provide.value<SalesOrderListProvide>(context).changeNoMore('没有更多了');
//       } else {
//         // print('测试判断条件2');
//         Provide.value<SalesOrderListProvide>(context)
//             .addGoodsList(goodsList.result.list);
//       }
//     });
//   }

//   // 循环组件整个item（包括公司以及所属产品）
//   Widget _salesOrderItem(list) {
//     if (list.length > 0) {
//       return Expanded(
//         child: Container(
//           child: SizedBox(
//             child: ListView.builder(
//               itemCount: list.length,
//               shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
//               // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
//               itemBuilder: (contex, index) {
//                 return _mergeWidget(list[index]);
//               },
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         child: Text('暂无数据'),
//       );
//     }
//   }

//   // 合并一级组件
//   Widget _mergeWidget(item) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(10),
//       child: InkWell(
//         onTap: () {
//           // 跳转到详情页面
//           Application.router.navigateTo(context, "/salesdetail?id=${item.id}");
//           print('点击跳转采购页面');
//         },
//         child: Column(
//           children: <Widget>[
//             _company(item),
//             _secondLevelListView(item.orderItems),
//           ],
//         ),
//       ),
//     );
//   }

//   // 遍历二级
//   Widget _secondLevelListView(subList) {
//     if (subList.length > 0) {
//       return Container(
//         child: SizedBox(
//           child: ListView.builder(
//             itemCount: subList.length,
//             shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
//             physics: NeverScrollableScrollPhysics(), //禁用滑动事件
//             itemBuilder: (contex, index) {
//               return _mergeSecondLevel(subList[index]);
//               // return Text('商品列表');
//             },
//           ),
//         ),
//         // ),
//       );
//     } else {
//       return Container(
//         child: Text('暂无商品数据'),
//       );
//     }
//   }

//   // 合并二级组件
//   Widget _mergeSecondLevel(subItem) {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Container(
//             width: ScreenUtil().setWidth(150),
//             height: ScreenUtil().setHeight(150),
//             // width: ScreenUtil().setWidth(120),
//             padding: EdgeInsets.only(top: 0, right: 10, bottom: 10),
//             child: subItem.mainKey == null
//                 ? Image.asset('images/default.png')
//                 : Image.network(
//                     subItem.mainKey,
//                     fit: BoxFit.fill,
//                   ),
//           ),
//           Expanded(
//             child: _right(subItem),
//           ),
//         ],
//       ),
//     );
//   }

//   // 需求公司
//   Widget _company(item) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: Row(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(right: 10.0),
//             child: Icon(Iconfont.companyLabel,
//                 color: Color.fromARGB(
//                   255,
//                   82,
//                   160,
//                   255,
//                 ),
//                 size: 20.0),
//           ),
//           Expanded(
//             child: Container(
//               child: Text(
//                 '${item.demanderDeptName}',
//                 style: TextStyle(
//                   color: Color(0xFF333333),
//                   fontSize: ScreenUtil().setSp(32),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerRight,
//             child: Text(
//               '共${item.orderItems.length}种${item.totalNumber}件',
//               style: TextStyle(
//                 color: Color(0xFFA1A0A3),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _right(subItem) {
//     return Container(
//       // width: ScreenUtil().setWidth(600),
//       child: Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '${subItem.productName}',
//               maxLines: 2,
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               // '规格：${item.skuValueList}',
//               '规格：${subItem.specification}',
//               style: TextStyle(
//                 color: Color(0xFFCCCCCC),
//                 fontSize: ScreenUtil().setSp(30),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '数量：${subItem.number}',
//               style: TextStyle(
//                 color: Color(0xFFCCCCCC),
//                 fontSize: ScreenUtil().setSp(30),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
