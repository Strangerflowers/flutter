import 'package:bid/common/inconfont.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/models/quotation_model.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  List list = ['已报价', '全部通过', '部分通过', '全部不通过'];
  // 0：已报价，1：报价未通过,2：报价通过，3：部分通过
  var statusType = {0: 0, 1: 2, 2: 3, 3: 1};
  // status = statusType[index];
  @override
  void initState() {
    _getQuotationList();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    pageNum = 1;
    await _getQuotationList();
  }

  // 获取列表数据
  void _getQuotationList() async {
    if (pageNum == 1) {
      setState(() {
        _itemList = null;
      });
    }
    var data = {
      "limit": 10,
      "page": pageNum,
      "params": {
        "status": statusType[currentTabs],
      }
    };

    print('获取商品列表页数据参数${data}');
    await request('quotationQueryPage', formData: data).then((val) {
      if (val['code'] == 0) {
        QuotationHome goodsList = QuotationHome.fromJson(val);
        totalPage = goodsList.result.totalPage;

        if (pageNum == 1) {
          goodsList.result.list.forEach((element) {
            element.isOpen = false;
          });
          setState(() {
            _itemList = goodsList.result.list;
          });
        } else {
          goodsList.result.list.forEach((element) {
            element.isOpen = false;
          });
          setState(() {
            _itemList.addAll(goodsList.result.list);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          title: Text('报价单'),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            child: Column(
              children: <Widget>[
                _tabs(list),
                _recommedList(_itemList),
                // QuotationTabs(),
                // QuotationGoodsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs(list) {
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
    // bool isClick = false;
    // isClick =
    //     (index == Provide.value<QuotationGoodsListProvide>(context).childIndex
    //         ? true
    //         : false);
    return InkWell(
      onTap: () {
        // setState(() {
        preTabs = currentTabs;
        currentTabs = index;

        pageNum = 1;
        // });
        if (preTabs != currentTabs) {
          setState(() {});
          _getQuotationList();
        }

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

  // 商品列表
  Widget _goodsList(list) {
    return Expanded(
      child: Container(
        child: _recommedList(list),
      ),
    );
  }

  // 一级
  Widget _recommedList(list) {
    if (list != null && list.length >= 0) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: .0),
            itemCount: list.length + 1,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            itemBuilder: (contex, index) {
              //如果到了表尾
              if (index > (list.length - 1)) {
                //不足100条，继续获取数据
                if (pageNum < totalPage) {
                  print('获取更多$pageNum====$totalPage');
                  //获取数据
                  pageNum++;
                  _getQuotationList();
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
                  if (list.length == 0) {
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

              return _merge(list[index], index);
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
      // return Container(
      //   child: Text('暂无数据'),
      // );
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
            _expandedBotton(item),
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
                  child: Image.asset(
                    'images/companyLabel.png',
                    width: 20,
                    height: 20,
                  ),
                  // child: Icon(Iconfont.companyLabel,
                  //     color: Color(0xFF5A99FF), size: 20.0),
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
          _goodlsList(item.detailList, item),
        ],
      ),
    );
  }

  // 二级
  Widget _goodlsList(arr, item) {
    if (arr.length > 0) {
      return Container(
        // height: ScreenUtil().setHeight(1000),
        child: SizedBox(
          child: ListView.builder(
            itemCount: item.isOpen ? arr.length : 1,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
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

  // 收起展开按钮
  Widget _expandedBotton(item) {
    if (item.detailList != null && item.detailList.length > 1) {
      return Container(
        width: ScreenUtil().setWidth(750),
        child: InkWell(
          onTap: () {
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
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(item.skuUrl, '')),
            // child: item.skuUrl == null ||
            //         item.skuUrl == 'null' ||
            //         item.skuUrl == ''
            //     ? Image.asset('images/default.png')
            //     : Image.network(
            //         '${item.skuUrl}',
            //         fit: BoxFit.fill,
            //       ),
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
                  child: Image.asset(
                    'images/companyLabel.png',
                    width: 20,
                    height: 20,
                  ),
                  // child: Icon(Iconfont.companyLabel,
                  //     color: Color(0xFF5A99FF), size: 20.0),
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
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(150),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: item.skuUrl == null ||
                      item.skuUrl == 'null' ||
                      item.skuUrl == ''
                  ? Image.asset('images/default.png')
                  : Image.network(
                      '${item.skuUrl}',
                      fit: BoxFit.fill,
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
