import 'package:bid/common/inconfont.dart';
import 'package:bid/models/quotation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

import '../../provide/quotation_list.dart';
import '../../routers/application.dart';
import '../../service/service_method.dart';

class QuotationIndexPage extends StatefulWidget {
  @override
  _QuotationIndexPageState createState() => _QuotationIndexPageState();
}

class _QuotationIndexPageState extends State<QuotationIndexPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('报价单'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            QuotationTabs(),
            QuotationGoodsList(),
          ],
        ),
      ),
    );
  }
}

// tabs切换

class QuotationTabs extends StatefulWidget {
  @override
  _QuotationTabsState createState() => _QuotationTabsState();
}

class _QuotationTabsState extends State<QuotationTabs> {
  List list = ['已报价', '全部通过', '部分通过', '全部不通过'];
  // int listIndex = 0;
  @override
  void initState() {
    _getQuotationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<QuotationGoodsListProvide>(builder: (context, child, data) {
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
    isClick =
        (index == Provide.value<QuotationGoodsListProvide>(context).childIndex
            ? true
            : false);
    return InkWell(
      onTap: () {
        Provide.value<QuotationGoodsListProvide>(context)
            .changeChildIndex(index);
        _getQuotationList();
        print(
            '状态参数${Provide.value<QuotationGoodsListProvide>(context).status}');
        // _getGoodsList(item.mallSubId);
        // setState(() {
        //   listIndex = index;
        // });
        // print('$isClick');
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

  // 获取列表数据
  void _getQuotationList() async {
    var data = {
      "limit": 10,
      "page": Provide.value<QuotationGoodsListProvide>(context).page,
      "params": {
        "status": Provide.value<QuotationGoodsListProvide>(context).status,
      }
    };
    print('获取商品列表页数据参数${data}');
    await request('quotationQueryPage', formData: data).then((val) {
      // var res = json.decode(val.toString());
      // print('获取商品列表页数据1S$res------------------------------');

      // 使用状态管理的方式
      QuotationHome goodsList = QuotationHome.fromJson(val);
      if (goodsList.result.list == null) {
        Provide.value<QuotationGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<QuotationGoodsListProvide>(context)
            .getGoodsList(goodsList.result.list);
      }

      // setState(() {
      //   list = goodsList.result.list;
      // });
      // print('获取商品列表页数据1S${list[0].orgName}');
    });
  }
}

// 列表
class QuotationGoodsList extends StatefulWidget {
  @override
  _QuotationGoodsListState createState() => _QuotationGoodsListState();
}

class _QuotationGoodsListState extends State<QuotationGoodsList> {
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();
  List<QuotationHomeList> list = [];
  // @override
  void initState() {
    // _getQuotationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<QuotationGoodsListProvide>(builder: (context, child, data) {
      if (data.goodsList != null) {
        // if (data.goodsList != []) {
        return Expanded(
          child: Container(
            // height: ,
            // margin: EdgeInsets.only(bottom: 200),
            child: EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerkey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中',
                loadReadyText: '上拉加载',
              ),
              child: _recommedList(data.goodsList),
              loadMore: () async {
                // 上拉加载更多的回调方法
                print('上拉加载更多......');
              },
            ),
          ),
        );

        // return Container(
        //   child: _recommedList(data.goodsList),
        // );
      } else {
        return Container(
          child: Text('暂无数据'),
        );
      }
      // } else {
      //   return Container(
      //     child: Text('暂无数据'),
      //   );
      // }
    });
  }

  // 一级
  Widget _recommedList(list) {
    if (list.length > 0) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            itemBuilder: (contex, index) {
              return _merge(list[index], index);
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

  Widget _merge(item, index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: InkWell(
        onTap: () {
          // 跳转到详情页面
          Application.router.navigateTo(context, "/detail?id=${item.id}");
        },
        child: Column(
          children: <Widget>[
            _information(item, index),
          ],
        ),
      ),
    );
  }

  //公司资料
  Widget _information(item, index) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Iconfont.companyLabel,
                      color: Color(0xFF5A99FF), size: 20.0),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '${item.orgName}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xFF333333),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120),
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text(
                    '联系人',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: Color(0xFF3333333),
                      height: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '${item.linkPerson}-${item.linkPhone}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xFF3333333),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120),
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text('合计'),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '￥${double.parse(item.totalAmount) / 100}（共${item.categoryNum}种${item.total}件）',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _goodlsList(item.detailList),
        ],
      ),
    );
  }

  // 二级
  Widget _goodlsList(arr) {
    if (arr.length > 0) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: arr.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            itemBuilder: (contex, index) {
              return _mergeGoods(arr[index]);
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

  Widget _mergeGoods(item) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _goodsItem(item),
        ],
      ),
    );
  }

  // 商品信息
  Widget _goodsItem(item) {
    //  replace
    String str = '';
    if (item.skuValueList.length > 0) {
      str = (item.skuValueList.join(",")).replaceAll(",", ";");
      print('字符串拼接$str');
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
              // width: ScreenUtil().setWidth(120),
              // height: ScreenUtil().setHeight(120),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: Image.network(
                '${item.skuUrl}',
                fit: BoxFit.cover,
                width: ScreenUtil().setWidth(150),
                height: ScreenUtil().setHeight(150),
              )
              //  Image.asset('images/icon.png'),
              ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '${item.productDescript}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // '规格：${item.skuValueList}',
                    '规格：$str',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '数量：${item.num}',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 获取列表数据
  void _getQuotationList() async {
    var data = {
      "limit": 10,
      "page": Provide.value<QuotationGoodsListProvide>(context).page,
      "params": {
        "status": Provide.value<QuotationGoodsListProvide>(context).status,
      }
    };

    await request('quotationQueryPage', formData: data).then((val) {
      print('获取商品列表页数据--${val}');
      // var res = json.decode(val.toString());
      // print('获取商品列表页数据1S$res------------------------------');

      // 使用状态管理的方式
      QuotationHome goodsList = QuotationHome.fromJson(val);
      if (goodsList.result.list == null) {
        Provide.value<QuotationGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<QuotationGoodsListProvide>(context)
            .getGoodsList(goodsList.result.list);
      }

      setState(() {
        list = goodsList.result.list;
      });
      print('获取商品列表页数据1S${list[0].orgName}');
    });
  }
}
