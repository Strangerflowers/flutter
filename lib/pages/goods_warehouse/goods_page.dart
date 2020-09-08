import 'package:bid/pages/goods_warehouse/goods_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../provide/goods_list.dart';
import '../../provide/goods_list_provide.dart';
import '../../service/service_method.dart';
import '../../model/goods_list.dart';

class GoodsIndexPage extends StatefulWidget {
  @override
  _GoodsIndexPageState createState() => _GoodsIndexPageState();
}

class _GoodsIndexPageState extends State<GoodsIndexPage> {
  int ststes;
  void initState() {
    _getGoodsList();
    super.initState();
  }

  // 获取商品库列表数据
  void _getGoodsList() async {
    var formData = {
      'pageNum': 1,
      "status": 1,
      'pageSize': 10,
    };
    print('商品库列表数据传参$formData');
    await requestGet('goodsList', formData: formData).then((val) {
      // var data = json.decode(val.toString());
      GoodsSearchList goodsList = GoodsSearchList.fromJson(val);
      if (goodsList.result.list == null) {
        Provide.value<GoodsWarehose>(context).getGoodsList([]);
      } else {
        Provide.value<GoodsWarehose>(context)
            .getGoodsList(goodsList.result.list);
      }
      // Provide.value<GoodsWarehose>(context).getGoodsList(goodsList.result.list);
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('商品库'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GoodsPage(),
            CategoryGoodsList(),
          ],
        ),
      ),
    );
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
    // _getGoodsList();
    super.initState();
  }

  List list = ['售卖中', '草稿', '已下架'];
  //  {0: '草稿', 1: '售卖中', -1: '已下架'};
  var strtusType = {0: 1, 1: 0, 2: -1};
  // int listIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsWarehose>(builder: (context, child, counter) {
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
    return InkWell(
      onTap: () {
        Provide.value<GoodsWarehose>(context).activeIndex(index);
        setState(() {
          currentStatus =
              strtusType[Provide.value<GoodsWarehose>(context).provideIndex];
        });
        _getGoodsList();
      },
      child: Expanded(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(187),
          // padding: EdgeInsets.fromLTRB(5.0, 10.0, 0, 10.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 12.0),
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
}

// 商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();
  var scorllController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getGoodsBackList(context);
    return Provide<GoodsWarehose>(builder: (context, child, data) {
      print('provide======${data.goodsList}');
      if (data.goodsList != null) {
        return Expanded(
          child: Container(
            width: ScreenUtil().setWidth(570),
            child: EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerkey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: Provide.value<GoodsWarehose>(context).noMoreText,
                moreInfo: '加载中',
                loadReadyText: '上拉加载',
              ),
              child: ListView.builder(
                controller: scorllController,
                itemCount: data.goodsList.length,
                shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                itemBuilder: (context, index) {
                  return _recommedList(data.goodsList);
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
        // return Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.all(10),
        //   child: EasyRefresh(
        //     refreshFooter: ClassicsFooter(
        //       key: _footerkey,
        //       bgColor: Colors.white,
        //       textColor: Colors.pink,
        //       moreInfoColor: Colors.pink,
        //       showMore: true,
        //       noMoreText: '无',
        //       moreInfo: '加载中',
        //       loadReadyText: '上拉加载',
        //     ),
        //     child: ListView.builder(
        //       itemCount: data.goodsList.length,
        //       shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
        //       // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
        //       itemBuilder: (contex, index) {
        //         return _recommedList(data.goodsList);
        //       },
        //     ),
        //     loadMore: () async {
        //       // 上拉加载更多的回调方法
        //       // _getMoreList();
        //       print('上拉加载更多......');
        //     },
        //   ),
        // );
      } else {
        return Container(
          child: Text('暂无数据'),
        );
      }
    });

// )
  }

  //ListViewzujian
  Widget _recommedList(list) {
    // print('判断拿到的数据$list');
    if (list.length > 0) {
      return Container(
        height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
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
                padding: EdgeInsets.only(right: 10),
                child: Image.network('${item.image}')
                // Image.asset('images/icon.png'),
                ),
            Expanded(child: _right(item)),
          ],
        ),
      ),
    );
  }

  // 左侧商品
  Widget _right(item) {
    return Container(
      // width: ScreenUtil().setWidth(600),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item.name}',
              maxLines: 2,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '${item.priceRange}',
                style: TextStyle(color: Color(0xFFF0B347)),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    // color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    // colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: item.status == 1
                        ? Text(
                            '上架',
                            style: TextStyle(
                              color: Color(0xFF4389ED),
                            ),
                          )
                        : Text(
                            '下架',
                            style: TextStyle(
                              color: Color(0xFF4389ED),
                            ),
                          ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFF4389ED),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('退出登录提示'),
                            content: Text(
                                '${item.status == 1 ? '确定要下架吗？' : '确定要上架吗？'}'),
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
                                  _onOrOffline(item.id, item.status);
                                  // }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onOrOffline(id, status) {
    var url;
    if (status == 1) {
      url = 'offline';
    } else {
      url = 'online';
    }
    print('上下架传参${id}');
    requestPostSpl(url, spl: id.toString()).then((val) {
      print('上下架状态$val');
      if (val['code'] == 0) {
        // _getGoodsList();
        Fluttertoast.showToast(
          msg: val['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          textColor: Colors.white,
          fontSize: 16.0,
        );
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

  void _getGoodsBackList(BuildContext context) async {
    // Future _getBackDetailInfo(BuildContext context) async {
    // await Provide.value<GoodsWarehose>(context).getGoodsList();
    print('加载完成');
    // return '加载完成';
    // }
  }

  // 上拉加载更多
  void _getMoreList() async {
    var strtusType = {0: 1, 1: 0, 2: -1};
    var numb = Provide.value<GoodsWarehose>(context).provideIndex == null
        ? 1
        : Provide.value<GoodsWarehose>(context).provideIndex;

    Provide.value<GoodsWarehose>(context).addPage();
    var data = {
      'pageNum': Provide.value<GoodsWarehose>(context).page,
      "status": strtusType[numb],
      'pageSize': 10,
    };
    print('查看参数====>$data');
    await requestGet('goodsList', formData: data).then((val) {
      print('上拉加载更多$val');
      // 使用状态管理的方式
      GoodsSearchList goodsList = GoodsSearchList.fromJson(val);
      if (goodsList.result.list.length <= 0 || goodsList.result.list == null) {
        Fluttertoast.showToast(
          msg: '已经到底了',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Provide.value<GoodsWarehose>(context).changeNoMore('没有更多了');
      } else {
        print('测试判断条件2');
        Provide.value<GoodsWarehose>(context)
            .addGoodsList(goodsList.result.list);
      }
    });
  }
}
