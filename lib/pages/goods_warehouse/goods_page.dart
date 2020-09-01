import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  Widget build(BuildContext context) {
    // _getCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('商品库'),
      ),
      body: Column(
        children: <Widget>[
          GoodsPage(),
          CategoryGoodsList(),
        ],
      ),
    );
  }
}

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  @override
  void initState() {
    _getGoodsList();
    super.initState();
  }

  List list = ['售卖中', '待审核', '审核未通过', '已下架'];
  // int listIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsWarehose>(builder: (context, child, counter) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        height: ScreenUtil().setHeight(83),
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
      'pageSize': 10,
      "status": 0,
    };
    await requestGet('goodsList', formData: formData).then((val) {
      // var data = json.decode(val.toString());
      GoodsSearchList goodsList = GoodsSearchList.fromJson(val);
      Provide.value<GoodsWarehose>(context).getGoodsList(goodsList.list);
    });
  }

  Widget _typeWell(item, int index) {
    bool isClick = false;
    isClick = (index == Provide.value<GoodsWarehose>(context).provideIndex
        ? true
        : false);
    // isClick = (index == listIndex ? true : false);
    return InkWell(
      onTap: () {
        // setState(() {
        //   listIndex = index;
        // });
        print('$isClick');
        Provide.value<GoodsWarehose>(context).activeIndex(index);
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
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: _recommedList(data.goodsList),
        );
      } else {
        return Container(
          child: Text('加载中......'),
        );
      }
    });

// )
  }

  //ListViewzujian
  Widget _recommedList(list) {
    print('判断拿到的数据$list');
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
        child: Text('加载中。。。。。'),
      );
    }
  }

  // 合并商品
  Widget _mergeItem(item) {
    return Container(
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
    );
  }

  // 左侧商品
  Widget _right(item) {
    return Container(
      // width: ScreenUtil().setWidth(600),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              '${item.name}',
              maxLines: 2,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '￥200.00',
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
                    child: Text(
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
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _getGoodsBackList(BuildContext context) async {
    // Future _getBackDetailInfo(BuildContext context) async {
    // await Provide.value<GoodsWarehose>(context).getGoodsList();
    print('加载完成');
    // return '加载完成';
    // }
  }

  // void _getGoodsList() async {
  //   var data = {'categoryId': '4', 'CategorySubId': '', 'page': 1};
  //   await request('getMallGoods', formData: data).then((val) {
  //     print('获取商品列表页数据$val');
  //     var data = json.decode(val);
  //     CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
  //     // CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
  //     print('>>>>>>>>>>>>>>>>>>>>${goodsList}');
  //   });
  // }
}
