import 'dart:async';
import 'dart:convert';

import 'package:bid/common/string_utils.dart';
import 'package:bid/models/goods_list.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:bid/pages/goods_warehouse/goods_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

import '../../provide/goods_list_provide.dart';
import '../../service/service_method.dart';

class GoodsIndexPage extends StatefulWidget {
  @override
  _GoodsIndexPageState createState() => _GoodsIndexPageState();
}

class _GoodsIndexPageState extends State<GoodsIndexPage> {
  // List<GoodsSearchList> _itemList;
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
  void initState() {
    _getGoodsList();
    super.initState();
  }

  List list = ['售卖中', '未发布', '已下架'];
  var strtusType = {0: 1, 1: 0, 2: -1};
  var auditStatusType = {1: '审核通过', 0: '待审核', -1: '不通过'};

  void _getGoodsList() async {
    if (pageNum == 1) {
      setState(() {
        _itemList = [];
      });
      print('获取长度￥${_itemList.length}');
    }
    var formData = {
      'pageNum': pageNum,
      "status": strtusType[currentTabs],
      'pageSize': 10,
    };
    print('======$formData');

    await requestGet('goodsList', formData: formData).then((value) {
      totalPage = value['result']['totalPage'];
      GoodsSearchList goodsList = GoodsSearchList.fromJson(value);

      if (pageNum == 1) {
        setState(() {
          _itemList = goodsList.result.list;
        });
        print('获取长度￥${_itemList.length}');
      } else {
        setState(() {
          _itemList.addAll(goodsList.result.list);
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    pageNum = 1;
    await _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    if (_itemList != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('商品库'),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            child: Column(
              children: <Widget>[
                _goodsPage(list),
                _goodsList(_itemList),
              ],
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

  Widget _goodsPage(list) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: ScreenUtil().setHeight(90),
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
        shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
        scrollDirection: Axis.horizontal,
      ),
      // ),
    );
  }

  Widget _typeWell(item, int index) {
    bool isClick = false;
    isClick = (index == currentTabs ? true : false);
    return Container(
      child: InkWell(
        onTap: () {
          // setState(() {
          preTabs = currentTabs;
          currentTabs = index;

          pageNum = 1;
          // });
          // scorllController.jumpTo(0.0);
          if (preTabs != currentTabs) {
            setState(() {});
            print('查看是否执行该程序$preTabs----$currentTabs');
            _getGoodsList();
          }
        },
        child: Container(
          // flex: 1,
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(250),
            // padding: EdgeInsets.fromLTRB(5.0, 10.0, 0, 10.0),
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
      ),
    );
  }

  Widget _goodsList(result) {
    if (result != null && _itemList.length > 0) {
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
            controller: scorllController,
            itemCount: result.length + 1,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              //如果到了表尾
              if (index > (result.length - 1)) {
                //不足100条，继续获取数据
                if (pageNum < totalPage) {
                  print('获取更多$pageNum====$totalPage');
                  //获取数据
                  pageNum++;
                  _getGoodsList();
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
              return _mergeItem(result[index]);
              // return _recommedList(list);
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

  //ListViewzujian
  Widget _recommedList(list) {
    // print('判断拿到的数据$list');
    if (list.length > 0) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            itemBuilder: (contex, index) {
              return _mergeItem(list[index]);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无数据'),
      );
    }
  }

  // 合并商品
  Widget _mergeItem(item) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return GoodsDetailsPage(item.id.toString());
              },
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setHeight(100),
              padding: EdgeInsets.only(right: 10),
              child: ImageWidgetBuilder.loadImage(
                  StringUtils.defaultIfEmpty(item.imageUrl, '')),
            ),
            Expanded(child: _right(item)),
          ],
        ),
      ),
    );
  }

  // 左侧商品
  Widget _right(item) {
    var actionType = {'online': '上架', 'offline': '下架', 'change': '商品变更'};
    return Container(
      // width: ScreenUtil().setWidth(600),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              '${item.name}',
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '${item.priceRange}',
                style: TextStyle(color: Color(0xFFF0B347)),
              ),
              _buttom(item),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '请求：${item.action == 'null' ? '' : actionType[item.action]}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '状态：${item.auditStatus == 'null' || item.auditStatus == null ? '' : auditStatusType[item.auditStatus]}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 上下架按钮
  Widget _buttom(item) {
    String text;
    String url;
    if (item.status == 0 && item.auditStatus == -1 && item.action == 'null') {
      text = '上架';
      url = 'online';
    } else if (item.status == 1 &&
        item.auditStatus == 1 &&
        item.action == 'online') {
      // text = '上架';
      // url = 'online';
      text = '下架';
      url = 'offline';
    } else if (item.status == -1 &&
        item.auditStatus == 1 &&
        item.action == 'offline') {
      text = '上架';
      url = 'online';
    } else {
      return Container(
        child: Text(''),
      );
    }

    return Expanded(
      child: Container(
        alignment: Alignment.topRight,
        child: SizedBox(
          height: ScreenUtil().setHeight(50),
          width: ScreenUtil().setWidth(130),
          child: FlatButton(
            // color: Colors.blue,
            highlightColor: Colors.blue[700],
            // colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text(
              '$text',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(24),
                // color: Color(0xFF4389ED),
                color: Color(0xFF4389ED),
              ),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                // color: Color(0xFF4389ED),
                color: Color(0xFF4389ED),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            onPressed: () {
              _showStatusAlert(item, url, text);
            },
          ),
        ),
      ),
    );
  }

  _showStatusAlert(item, url, text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${text}提示'),
          content: Text('${text}需提交审核，确定要$text吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                _onOrOffline(item.id, url);
                Navigator.of(context).pop('cancel');
                // }
              },
            ),
          ],
        );
      },
    );
  }

  void _onOrOffline(id, url) {
    print('上下架传参${id}');
    requestPostSpl(url, spl: id.toString()).then((val) {
      print('上下架状态$val');
      if (val['code'] == 0) {
        Fluttertoast.showToast(
          msg: '操作成功!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        pageNum = 1;
        _getGoodsList();
      } else {
        // goodsList = null;
        Fluttertoast.showToast(
          msg: val['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }
}

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  int currentStatus = 1;
  @override
  void initState() {
    super.initState();
  }

  List list = ['售卖中', '未发布', '已下架'];
  //  {0: '草稿', 1: '售卖中', -1: '已下架'};
  var strtusType = {0: 1, 1: 0, 2: -1};
  // int listIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsWarehose>(builder: (context, child, counter) {
      if (Provide.value<GoodsWarehose>(context).provideIndex != null &&
          currentStatus == 1) {
        Provide.value<GoodsWarehose>(context).activeIndex(0);
      }
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        height: ScreenUtil().setHeight(90),
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
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          scrollDirection: Axis.horizontal,
        ),
        // ),
      );
    });
  }

  // 获取商品库列表数据
  void _getGoodsList() async {
    var formData = {
      'pageNum': 1,
      "status": currentStatus,
      'pageSize': 10,
    };
    print('商品库列表数据传参$formData');
    await requestGet('goodsList', formData: formData).then((val) {
      // var data = json.decode(val.toString());
      GoodsSearchList goodsList = GoodsSearchList.fromJson(val);
      Provide.value<GoodsWarehose>(context).getGoodsList(goodsList.result.list);
    });
  }

  Widget _typeWell(item, int index) {
    bool isClick = false;
    isClick = (index == Provide.value<GoodsWarehose>(context).provideIndex
        ? true
        : false);
    return Container(
      child: InkWell(
        onTap: () {
          Provide.value<GoodsWarehose>(context).activeIndex(index);
          setState(() {
            currentStatus =
                strtusType[Provide.value<GoodsWarehose>(context).provideIndex];
          });
          _getGoodsList();
        },
        child: Container(
          // flex: 1,
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(250),
            // padding: EdgeInsets.fromLTRB(5.0, 10.0, 0, 10.0),
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
      ),
    );
  }
}
