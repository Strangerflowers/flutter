import 'package:bid/common/inconfont.dart';
import 'package:bid/common/toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../../routers/application.dart';
import '../../../provide/demand_detail_provide.dart';
import '../select_products/select_skul.dart';

class AddQuoteBody extends StatefulWidget {
  @override
  _AddQuoteBodyState createState() => _AddQuoteBodyState();
}

class _AddQuoteBodyState extends State<AddQuoteBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class AddQuoteBody extends StatelessWidget {
  var error;
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).offerPageData;
      // print('报价选择商品页面${goodsInfo}');
      return Container(
        // margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(20),
        color: Colors.white,
        width: ScreenUtil().setWidth(750),
        child: Column(
          children: <Widget>[
            _dataListView(goodsInfo, context),
            // 描述
            _planMark(context),
          ],
        ),
      );
    });
  }

  //循环一级数据
  Widget _dataListView(list, context) {
    if (list != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (context, index) {
              return _merge(list[index], index, context);
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

  // 合并一二级数据
  Widget _merge(item, index, context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border(
      //     bottom: BorderSide(width: 1, color: Colors.black12),
      //   ),
      // ),
      // padding: EdgeInsets.only(bottom: 10, top: 10),
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          _firstStage(item),
          _datasecondsListView(item['demandDetailDtoList'], item, context),
          // _secondLevel(),
        ],
      ),
    );
  }

  // 一级数据
  Widget _firstStage(item) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(Iconfont.productIcon, color: Color(0xFF52A0FF), size: 20.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('${item['productCategroyPath']}'),
            ),
          ),
        ],
      ),
    );
  }

  //遍历二级数据
  Widget _datasecondsListView(subList, item, context) {
    if (subList != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: subList.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (context, index) {
              return _secondLevel(subList[index], item, context);
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

  // 二级数据
  Widget _secondLevel(subItem, item, context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text('对应产品：${subItem.productDescript}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('需求数量：${subItem.num}${subItem.type}'),
          ),
          _showAddProduct(subItem, context),
          _buttom(subItem, item, context),
        ],
      ),
    );
  }

  Widget _showAddProduct(subItem, context) {
    if (subItem.subjectItemList != null) {
      return _productItem(subItem, context);
    } else {
      return _addShipment(subItem, context);
    }
  }

  // 添加产品
  Widget _addShipment(subItem, context) {
    return InkWell(
      onTap: () {
        // 跳转到商品列表页面
        // Navigator.pop(context);
        Application.router.navigateTo(context,
            "/selectproduct?id=${subItem.productCategroyId}&subId=${subItem.id}");
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //设置四周边框
          border: new Border.all(
            width: 1,
            color: Color(0xFFF6F5F8),
          ),
          color: Color(0xFFF6F5F8),
        ),
        height: ScreenUtil().setHeight(160),
        margin: EdgeInsets.only(top: 20),
        // color: Color(0xFFF6F5F8),
        child: Row(
          children: <Widget>[
            Icon(Icons.add),
            Text('添加报价产品'),
          ],
        ),
      ),
    );
  }

  // 已选择的商品组件
  Widget _productItem(subItem, context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(120),
                padding: EdgeInsets.only(top: 0, right: 10),
                // child: Image.asset('images/icon.png'),
                child: subItem.subjectItemList[0].image == '' ||
                        subItem.subjectItemList[0].image == 'null' ||
                        subItem.subjectItemList[0].image == null
                    ? Image.asset('images/default.png')
                    : Image.network(subItem.subjectItemList[0].image),
              ),
              Expanded(
                child: _right(subItem.subjectItemList[0]),
              ),
              InkWell(
                onTap: () {
                  // 跳转到商品列表页面
                  Application.router.navigateTo(context,
                      "/selectproduct?id=${subItem.productCategroyId}&subId=${subItem.id}");
                },
                child: Container(
                  child: Text('替换产品'),
                ),
              ),
            ],
          ),
          SelectSkul(subItem),
          // specificationList
          _goodsPrice(subItem, context),
          // GoodsPrice(subItem),
        ],
      ),
    );
  }

  // 产品右边信息描述
  Widget _right(childItem) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${childItem.name}',
              maxLines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "",
              // '${childItem.priceRange}',
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

  Widget _goodsPrice(subItem, context) {
    return Container(
      child: TextFormField(
        inputFormatters: [
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入小数
          // WhitelistingTextInputFormatter(
          //     RegExp("((^[0])|(^[1-9]\\d{0,11}))(\.\\d{0,})?\$")), //只允许输入小数
        ],
        keyboardType: TextInputType.number,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: '${subItem.goodsPrice == 'null' ? "" : subItem.goodsPrice}',
            // 保持光标在最后
            selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset:
                      '${subItem.goodsPrice == 'null' ? "" : subItem.goodsPrice}'
                          .length),
            ),
          ),
        ),
        // autofocus: false,
        autofocus: false,
        onChanged: (value) {
          RegExp exp = RegExp("((^[0])|(^[1-9]\\d{0,11}))(\.\\d{0,2})?\$");
          if (value == '') {
            Provide.value<DemandDetailProvide>(context)
                .modifyPrice(subItem, '');
          } else {
            if (exp.hasMatch(value) && double.parse(value) <= 99999999.99) {
              Provide.value<DemandDetailProvide>(context)
                  .modifyPrice(subItem, value);
            } else {
              Provide.value<DemandDetailProvide>(context)
                  .modifyPrice(subItem, subItem.goodsPrice);
            }
          }
        },
        onSaved: (value) {},
        decoration: InputDecoration(
          hintText: "请输入报价单价",
          prefixIcon: Container(
            width: ScreenUtil().setWidth(150),
            margin: EdgeInsets.only(top: 15.0, right: 5.0),
            child: Text('报价'),
          ),
          suffixIcon: Container(
            width: ScreenUtil().setWidth(80),
            margin: EdgeInsets.only(top: 15.0, right: 5.0),
            child: Text('元/${subItem.type}'),
          ),
        ),
      ),
    );
  }

  // 删除按钮
  Widget _buttom(subItem, item, context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: OutlineButton(
              //自定义按钮颜色
              color: Color(0xFF666666),
              highlightColor: Colors.blue[700],
              // colorBrightness: Brightness.dark,
              splashColor: Color(0xFF333333),
              child: Text("删除产品"),
              textColor: Color(0xFF333333),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                print('点击删除拿到的id${subItem.id}');
                var goodsInfo =
                    Provide.value<DemandDetailProvide>(context).offerPageData;
                if (goodsInfo.length <= 1 &&
                    goodsInfo[0]['demandDetailDtoList'].length <= 1) {
                  return Toast.toast(context, msg: '不可删除');
                }
                _removeConfirm(context, subItem);
                print('点击提交报价');
              },
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                  '小计：￥${subItem.goodsPrice == 'null' || subItem.goodsPrice == '' ? 0 : NumUtil.multiplyDecStr(subItem.goodsPrice, subItem.num.toString())}'),
            ),
          ),
        ],
      ),
    );
  }

  // 删除产品二次确认弹框
  void _removeConfirm(context, item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('确定删除该产品？'),
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
                  Provide.value<DemandDetailProvide>(context)
                      .removeProduct(item, context);
                  Navigator.of(context).pop('cancel');
                },
              ),
            ],
          );
        });
  }

  // 备注
  Widget _planMark(context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        margin: EdgeInsets.only(bottom: 40),
        // padding: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '备注',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Color(0xFF423F42),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                decoration: InputDecoration(
                  errorText: error,
                ),
                keyboardType: TextInputType.multiline,
                autovalidate: true,
                // maxLines: whatever,
                maxLines: 10,
                minLines: 1,
                autofocus: false,
                onChanged: (value) {
                  if (value.length > 200) {
                    setState(() {
                      error = "长度不能超过200个字符";
                    });
                  } else {
                    Provide.value<DemandDetailProvide>(context)
                        .remarkFunc(value);
                    setState(() {
                      error = null;
                    });
                  }
                },
                validator: (value) {
                  if (value.length > 200) {
                    return "长度不能超过200";
                  }
                  return null;
                },
                // controller: _unameController,
              ),
            )
          ],
        ));
  }
}

class GoodsPrice extends StatefulWidget {
  final skulList;
  GoodsPrice(this.skulList);
  @override
  _GoodsPriceState createState() => _GoodsPriceState();
}

TextEditingController _priceController = new TextEditingController();

class _GoodsPriceState extends State<GoodsPrice> {
  var result;
  var goodsItem;
  var skugoodsItem;
  List<String> skuldataList;
  List skulObjectData = new List(); //先保存一份放价格
  void initState() {
    skuldataList = [];
    result = widget.skulList;

    goodsItem = widget.skulList.subjectItemList[0];
    goodsItem.skuList.forEach((ele) {
      var obj = {
        'id': ele.id,
        "price": ele.price,
      };
      return skulObjectData.add(obj);
    });
    super.initState();
  }

  final priceFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      return Form(
        key: priceFormKey,
        child: TextFormField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: '${result.goodsPrice == 'null' ? "" : result.goodsPrice}',
              // 保持光标在最后
              selection: TextSelection.fromPosition(
                TextPosition(
                    affinity: TextAffinity.downstream,
                    offset:
                        '${result.goodsPrice == 'null' ? "" : result.goodsPrice}'
                            .length),
              ),
            ),
          ),
          // autofocus: false,
          autofocus: false,
          onChanged: (value) {
            // setState(() {
            print('是否进入修改页面${value}1');
            Provide.value<DemandDetailProvide>(context)
                .modifyPrice(result, value);
          },
          onSaved: (value) {
            this.result = value;
            if (result.specificaId != null)
              goodsItem.skuList.forEach((ele) {
                var obj = {
                  'id': ele.id,
                  "price": ele.price,
                };
                return skulObjectData.add(obj);
              });
          },
          decoration: InputDecoration(
            hintText: "请输入报价单价",
            prefixIcon: Container(
              width: ScreenUtil().setWidth(150),
              margin: EdgeInsets.only(top: 15.0, right: 5.0),
              child: Text('报价'),
            ),
            suffixIcon: Container(
              width: ScreenUtil().setWidth(80),
              margin: EdgeInsets.only(top: 15.0, right: 5.0),
              child: Text('元'),
            ),
          ),
        ),
      );
    });
  }
}
