import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/sales_order/add_infomation_provide.dart';
import '../../routers/application.dart';
import '../../pages/sales_order/sales_index_page.dart';

class SaleaUpdate extends StatelessWidget {
  final String id;
  // final String mainOrderId;
  // final String goodsId;
  // final String len;
  // final String returnId;
  SaleaUpdate(this.id);
  @override
  Widget build(BuildContext context) {
    // _getBackDetailInfo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('填写发货信息'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    AddHeader(),
                    // DatePickerWidget(),
                    ProductInformation(),
                    OkBotton(),
                  ],
                ),
              ),
            );
          } else {
            return Text('加载中......');
          }
        },
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<SalesAddPage>(context).getQuotationDetail(id);
    return '加载完成';
  }
}

class AddHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      var statusType = {0: '待发货', 1: '已发货', 2: '已收货'};
      var goodsInfo = Provide.value<SalesAddPage>(context).goodsList;
      if (goodsInfo != null) {
        var result = goodsInfo.result;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              _information('发货批次', result.batch),
              // _information('发货状态', statusType[result.status]),
              _information('计划发货时间', '${result.planDeliveryTime}'),
              DatePickerWidget(),
              UpdateForm(),
            ],
          ),
        );
      } else {
        return Text('暂无数据');
      }
    });
  }

  // 需求信息
  Widget _information(title, content) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text('$title'),
          ),
          Container(
            child: Text('$content'),
          )
        ],
      ),
    );
  }
}

class UpdateForm extends StatefulWidget {
  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final addFormKey = GlobalKey<FormState>();
  String logisticsCompanyName, logisticsNumber;
  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(200),
                  margin: EdgeInsets.only(top: 13.0, right: 5.0),
                  child: Text('物流公司'),
                ),
                hintText: "请输入物流公司名称",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
              onChanged: (value) {
                this.logisticsCompanyName = value;
                Provide.value<SalesAddPage>(context)
                    .changeCompanyName(this.logisticsCompanyName);
                // print('当前输入的公司名称----$username');
              },
              onSaved: (value) {
                this.logisticsCompanyName = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "物流公司不能为空";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(200),
                  margin: EdgeInsets.only(top: 13.0, right: 5.0),
                  child: Text('快递单号'),
                ),
                hintText: "请填写快递单号",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
              onChanged: (value) {
                this.logisticsNumber = value;
                Provide.value<SalesAddPage>(context)
                    .changeCompanyNumber(this.logisticsNumber);
                // print('当前输入的公司名称----$username');
              },
              onSaved: (value) {
                this.logisticsNumber = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "用户名不能为空";
                }
                return null;
              },
            ),
          ],
        ),
      );
    });
  }
}

// 发货时间使用有状态组件---时间控件
class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  var dayTime;
  @override
  void initState() {
    // 默认为当前日期
    DateTime now = new DateTime.now();
    dayTime = now.toString().substring(0, 10);
    // dayTime = "";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xFFEEEEEE),
            ),
          ),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: _onClick(context),
      );
    });
  }

  // 选择时间
  Widget _onClick(context) {
    return Container(
      child: InkWell(
        onTap: () {
          showDatePicker(
            // 设置禁用时间
            // selectableDayPredicate: (DateTime day) {
            //   return day.difference(DateTime.now()).inDays < 2;
            // },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            locale: Locale('zh', 'CH'),
            // locale: Locale('zh'),
            lastDate: DateTime(2030),
          ).then((DateTime val) {
            if (val != null) {
              setState(() {
                dayTime = val.toString().substring(0, 10);
                Provide.value<SalesAddPage>(context)
                    .changeDayTime(val.toString().substring(0, 10));
              });
            }
            print(val); // 2018-07-12 00:00:00.000
          }).catchError((err) {
            print(err);
          });
          // setState(() {
          //   dayTime = result.toString().substring(0, 10);
          //   Provide.value<SalesAddPage>(context)
          //       .changeDayTime(result.toString().substring(0, 10));
          // });
          // print('选择时间12345678--${result.toString().substring(0, 10)}');
          // 跳转到详情页面
          // Application.router.navigateTo(context, "/plan?id=$id");
        },
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(200),
              child: Text('实际发货时间'),
            ),
            Expanded(
              child: Text('$dayTime'),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black12,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 确定按钮
class OkBotton extends StatelessWidget {
  // final String mainOrderId;
  // final String goodsId;
  // final String len;
  // final String returnId;
  OkBotton();

  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      var result = Provide.value<SalesAddPage>(context).goodsList.result;
      var goodsInfo = Provide.value<SalesAddPage>(context).salesList;
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  //自定义按钮颜色
                  color: Color(0xFF2A83FF),
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.blue,
                  child: Text("确认"),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () {
                    var dispatchItems = [];
                    goodsInfo.forEach((element) {
                      dispatchItems.add({
                        'id': element.id,
                        'actualDeliveryNumber': element.actualDeliveryNumber
                      });
                    });
                    _dispatchAdd(dispatchItems, result, context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _dispatchAdd(dispatchItems, result, context) {
    DateTime now = new DateTime.now();
    var dayTime = now.toString().substring(0, 10);

    // if (Provide.value<SalesAddPage>(context).logisticsCompanyName == null ||
    //     Provide.value<SalesAddPage>(context).logisticsNumber == null) {
    //   Fluttertoast.showToast(
    //     msg: '物流公司名称以及快递单号不能为空',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    //   return '请填写完整信息';
    // }
    var formData = {
      "id": Provide.value<SalesAddPage>(context).goodsList.result.id,
      "actualDeliveryTime":
          Provide.value<SalesAddPage>(context).actualDeliveryTime == null
              ? dayTime
              : Provide.value<SalesAddPage>(context).actualDeliveryTime,
      "logisticsCompanyName":
          Provide.value<SalesAddPage>(context).logisticsCompanyName,
      "logisticsNumber": Provide.value<SalesAddPage>(context).logisticsNumber,
      "dispatchItems": dispatchItems
    };
    print('获取更新参数======$formData');
    request('update', formData: formData).then((val) {
      // Application.router.navigateTo(context, "/saleslist?status=2");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return SalesIndexPage();
      //     },
      //   ),
      // );
      // Navigator.pop(context, "我是返回值");
      print('响应数据---$val');
      if (val['code'] == 0) {
        Fluttertoast.showToast(
          msg: '成功填写发货信息',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SalesIndexPage();
            },
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: val['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      // goodsList = AddDeliverArrange.fromJson(val);
      // print('详情数据$goodsList');
    });
  }
}

// 产品信息
class ProductInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesAddPage>(context).salesList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: _recommedList(goodsInfo),
          ),
        );
      } else {
        return Container(child: Text(''));
      }
    });
  }

  // 循环渲染
  // 一级
  Widget _recommedList(list) {
    // if (list.length > 0) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // height: ScreenUtil().setHeight(1000),
      child: SizedBox(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
          itemBuilder: (contex, index) {
            return _productItem(list[index], index);
          },
        ),
      ),
    );
  }

  // 计划发货数量
  Widget _actualDelivery(title, item) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text('$title'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  // padding: EdgeInsets.only(right: 20),
                  child: Text('${item.planDeliveryNumber}'),
                  // child: CartCount(item, index),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // 实际发货数量
  Widget _shipmentquantity(item, index) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text('实际发货数量'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  // padding: EdgeInsets.only(right: 20),
                  child: CartCount(item, index),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
                '已发${item.totalActualDeliveryNumber}，剩余${item.number - item.totalActualDeliveryNumber}'),
          )
        ],
      ),
    );
  }

  // 合并
  Widget _productItem(item, index) {
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
      child: Column(
        children: <Widget>[
          _goodsItem(item),
          _actualDelivery('计划发货数量', item),
          _shipmentquantity(item, index),
        ],
      ),
    );
  }

  // 商品信息
  Widget _goodsItem(item) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(150),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: item.skuKey == 'null' ||
                      item.skuKey == null ||
                      item.skuKey == ''
                  ? Image.asset(
                      'images/default.png',
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      '${item.skuKey}',
                      fit: BoxFit.fill,
                    )),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    // '12323',
                    '${item.productName}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    // '规格：${item.skuValueList}',
                    '规格：${item.specification}',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(
                    '数量：${item.number}',
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

// 数量增加减少按钮
class CartCount extends StatelessWidget {
  var item;
  int index;

  CartCount(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Provide<SalesAddPage>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesAddPage>(context).goodsList;
      if (item.actualDeliveryNumber == null) {
        item.actualDeliveryNumber = 0;
      }
      return Container(
        width: ScreenUtil().setWidth(230),
        margin: EdgeInsets.only(top: 5.0),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
        child: Row(
          children: <Widget>[
            _reduceBtn(context),
            _countArea(),
            _addBtn(context, item),
          ],
        ),
      );
    });
  }

  // 减少按钮
  Widget _reduceBtn(context) {
    return InkWell(
      onTap: () {
        if (item.actualDeliveryNumber <= 0) {
          return;
        } else {
          var num = item.actualDeliveryNumber -= 1;
          Provide.value<SalesAddPage>(context).getSalessList(index, num);
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(65),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color:
                item.actualDeliveryNumber > 0 ? Colors.white : Colors.black12,
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: item.actualDeliveryNumber > 0 ? Text('-') : Text('-'),
      ),
    );
  }

  //添加按钮
  Widget _addBtn(context, item) {
    // 剩余存量
    int surplus = item.number - item.totalActualDeliveryNumber;
    var num;
    return InkWell(
      onTap: () {
        num = item.actualDeliveryNumber += 1;
        if (num <= surplus) {
          Provide.value<SalesAddPage>(context).getSalessList(index, num);
        } else {
          num = surplus;
          Provide.value<SalesAddPage>(context).getSalessList(index, num);
        }
        print(
            '比较${item.actualDeliveryNumber <= (item.number - item.totalActualDeliveryNumber)}');
      },
      child: Container(
        width: ScreenUtil().setWidth(65),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.actualDeliveryNumber < surplus
                ? Colors.white
                : Colors.black12,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: item.actualDeliveryNumber <= surplus ? Text('+') : Text('+'),
      ),
    );
  }

  //中间数量显示区域
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(95),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.actualDeliveryNumber}'),
    );
  }
}
