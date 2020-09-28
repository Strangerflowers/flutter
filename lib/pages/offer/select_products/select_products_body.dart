import 'package:bid/models/demand_quotation/demand_quotation_model.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../../provide/demand_quotation/demand_quotation_provide.dart';
import '../round_checkbox.dart';

class SelectProductsBody extends StatefulWidget {
  final String id;
  SelectProductsBody(this.id);
  @override
  _SelectProductsBodyState createState() => new _SelectProductsBodyState();
}

class _SelectProductsBodyState extends State<SelectProductsBody> {
  var scorllController = new ScrollController();
  QuotataionData goodsList = null;
  String id;
  int pageNum = 1;
  int totalPage;
  var quotationData;
  void initState() {
    id = widget.id;
    pageNum = 1;
    setState(() {});
    super.initState();

    _getBackDetailInfo();
  }

  Future<void> _handleRefresh() async {
    print('下拉刷新');
    pageNum = 1;
    await _getBackDetailInfo();
  }

  var flag = false;
  void _getBackDetailInfo() async {
    if (pageNum == 1) {
      setState(() {
        goodsList = null;
        // Provide.value<DemandQuotationProvide>(context).getList([]);
      });
    }
    print('商品列表选择============');
    var formData = {
      "isAll": true,
      "limit": 15,
      "order": "string",
      "page": pageNum,
      "params": {"productCategroy": id}
    };
    // FormData formData = FormData.fromMap({'demandId': id});
    // request('http://osapi-dev.gtland.cn/os_kernel_bid/app/suppliers/demandDetail?demandId=$id')
    // print('获选带选择产品$formData');
    await request('selectGoodsByProductId', formData: formData).then((val) {
      print('商品列表$val');
      if (val['code'] == 0) {
        goodsList = QuotataionData.fromJson(val);
        totalPage = goodsList.result.totalPage;

        quotationData = goodsList.result.list;

        quotationData.forEach((ele) {
          ele.checkBoxFlag = false;
        });
        if (pageNum == 1) {
          setState(() {});
          Provide.value<DemandQuotationProvide>(context).getList(goodsList);
        } else {
          Provide.value<DemandQuotationProvide>(context).aAddList(goodsList);
          setState(() {});
        }
      }
    });
    print('查看是否执行');
    // await Provide.value<DemandQuotationProvide>(context)
    //     .getDemandDetailData(id);
    // return '加载完成';
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (pageNum == 1) {
        // 如果列表page==1，列表位置放到最顶部
        scorllController.jumpTo(0.0);
      }
    } catch (e) {
      print('进入页面第一次初始化：${e}');
    }
    return Provide<DemandQuotationProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandQuotationProvide>(context).goodsList;
      if (goodsInfo != null) {
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            // child: Container(
            //   child: Column(
            //     children: <Widget>[
            child: _checkboxTitleListView(goodsInfo.result.list),
            //   ],
            // ),
            // ),
          ),
        );
      } else {
        return Center(
          child: Text('暂无数据'),
        );
      }
    });
  }

  //一级需求信息变量渲染
  Widget _checkboxTitleListView(list) {
    if (list != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: .0),
            itemCount: list.length + 1,
            controller: scorllController,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: AlwaysScrollableScrollPhysics(),
            // physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              //如果到了表尾

              if (index > (list.length - 1)) {
                //不足100条，继续获取数=据
                print('判断是否到了未部$index======${list.length - 1}');
                if (pageNum < totalPage) {
                  //获取数据
                  pageNum++;
                  _getBackDetailInfo();
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
              // return _mergeWidget(result[index]);
              return _checkboxTitle(list[index], index);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无发货数据'),
      );
    }
  }

  Widget _checkboxTitle(item, index) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          RoundCheckBox(
            value: item.checkBoxFlag,
            onChanged: (selectedList) {
              setState(() {
                item.checkBoxFlag = !item.checkBoxFlag;
              });
              if (item.checkBoxFlag == true) {
                Provide.value<DemandQuotationProvide>(context)
                    .changeSelectItem(index);
              }
            },
          ),
          Expanded(
            child: _productItem(item),
          ),
        ],
      ),
    );
  }

  Widget _productItem(item) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(100),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: Image.network(
              item.image,
              fit: BoxFit.fill,
            ),
            // child: Image.asset('images/icon.png'),
          ),
          Expanded(
            child: _right(item),
          ),
          // _right(),
        ],
      ),
    );
  }

  // 产品右边信息描述
  Widget _right(item) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item.name}',
              maxLines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '￥${item.priceRange}',
              style: TextStyle(
                color: Color(0xFFF4AB36),
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
