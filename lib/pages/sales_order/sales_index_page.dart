import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:async';
import 'package:provide/provide.dart';
import '../../provide/sales_order_list_provide.dart';
import '../../model/sales_order_list_model.dart';
import '../../service/service_method.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../routers/application.dart';

class SalesIndexPage extends StatefulWidget {
  @override
  _SalesIndexPageState createState() => _SalesIndexPageState();
}

class _SalesIndexPageState extends State<SalesIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SalesTabs(),
            SalesGoodsList(),
          ],
        ),
      ),
    );
  }
}

class SalesTabs extends StatefulWidget {
  @override
  _SalesTabsState createState() => _SalesTabsState();
}

class _SalesTabsState extends State<SalesTabs> {
  List list = ['待确认', '待发货', '已发货', '已完成'];
  int listIndex = 0;
  int statuss = 1;
  @override
  void initState() {
    _getSaleasOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderListProvide>(builder: (context, child, data) {
      if (data.goodsList != []) {
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
      } else {
        return Container(
          child: Text('暂无数据'),
        );
      }
    });
  }

  Widget _typeWell(item, int index) {
    bool isClick = false;
    isClick = (index == Provide.value<SalesOrderListProvide>(context).childIndex
        ? true
        : false);
    return InkWell(
      onTap: () {
        Provide.value<SalesOrderListProvide>(context).changeChildIndex(index);
        setState(() {
          statuss = Provide.value<SalesOrderListProvide>(context).status;
        });
        _getSaleasOrderList();
        print('$isClick');
      },
      child: Expanded(
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

  // 获取列表数据
  void _getSaleasOrderList() async {
    var data = {
      "isAll": true,
      "limit": 3,
      "order": "string",
      "page": 1,
      "pageMap": {},
      "params": {"merchantId": "1", "status": statuss}
    };
    await request('soQueryPage', formData: data).then((val) {
      // var res = json.decode(val.toString());
      // print('获取商品列表页数据1S$res------------------------------');
      // print('123456${val}');

      // 使用状态管理的方式
      SalesRoder goodsList = SalesRoder.fromJson(val);
      if (goodsList.result.list == null) {
        Provide.value<SalesOrderListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<SalesOrderListProvide>(context)
            .getGoodsList(goodsList.result.list);
      }

      // setState(() {
      //   list = goodsList.result.list;
      // });
      // print('获取商品列表页数据1S${list[0].orgName}');
    });
  }
}

// 商品列表
class SalesGoodsList extends StatefulWidget {
  @override
  _SalesGoodsListState createState() => _SalesGoodsListState();
}

class _SalesGoodsListState extends State<SalesGoodsList> {
  @override
  void initState() {
    // _getGoodsList();
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();
  var scorllController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderListProvide>(builder: (context, child, data) {
      if (data.goodsList != null) {
        return Expanded(
          child: Container(
            child: EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerkey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                // noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                moreInfo: '加载中',
                loadReadyText: '上拉加载',
              ),
              child: ListView.builder(
                itemCount: data.goodsList.length,
                shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                itemBuilder: (contex, index) {
                  return _mergeWidget(data.goodsList[index]);
                },
              ),
              loadMore: () async {
                // 上拉加载更多的回调方法
                _getMoreList();
                print('上拉加载更多......');
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

  // 上拉加载更多
  void _getMoreList() async {
    Provide.value<SalesOrderListProvide>(context).addPage();
    var data = {
      "isAll": true,
      "limit": 3,
      "order": "string",
      "page": Provide.value<SalesOrderListProvide>(context).page,
      "pageMap": {},
      "params": {
        "merchantId": "1",
        "status": Provide.value<SalesOrderListProvide>(context).status,
      }
    };
    print('查看参数$data');
    await request('soQueryPage', formData: data).then((val) {
      // 使用状态管理的方式
      SalesRoder goodsList = SalesRoder.fromJson(val);

      if (goodsList.result.list.length <= 0 || goodsList.result.list == null) {
        Fluttertoast.showToast(
          msg: '已经到底了',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Provide.value<SalesOrderListProvide>(context).changeNoMore('没有更多了');
      } else {
        // print('测试判断条件2');
        Provide.value<SalesOrderListProvide>(context)
            .addGoodsList(goodsList.result.list);
      }
    });
  }

  // 循环组件整个item（包括公司以及所属产品）
  Widget _salesOrderItem(list) {
    if (list.length > 0) {
      return Expanded(
        child: Container(
          child: SizedBox(
            child: ListView.builder(
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
            _secondLevelListView(item.orderItems),
          ],
        ),
      ),
    );
  }

  // 遍历二级
  Widget _secondLevelListView(subList) {
    if (subList.length > 0) {
      return Container(
        child: SizedBox(
          child: ListView.builder(
            itemCount: subList.length,
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
            width: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: Image.asset('images/icon.png'),
          ),
          Expanded(
            child: _right(subItem),
          ),
        ],
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
