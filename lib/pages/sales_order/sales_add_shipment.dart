import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/sales_add_shipment_provide.dart';
import '../../routers/application.dart';

// class AddShipmentSchedule extends StatefulWidget {
//   final String mainOrderId;
//   final String goodsId;
//   final String len;
//   final String returnId;
//   AddShipmentSchedule(this.goodsId, this.mainOrderId, this.len, this.returnId);
//   @override
//   _AddShipmentScheduleState createState() => _AddShipmentScheduleState();
// }

// class _AddShipmentScheduleState extends State<AddShipmentSchedule> {
//   String mainOrderId;
//   String goodsId;
//   String len;
//   String returnId;
//   void initState() {
//     mainOrderId = widget.mainOrderId;
//     goodsId = widget.goodsId;
//     len = widget.len;
//     returnId = widget.returnId;
//     super.initState();
//   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }

class AddShipmentSchedule extends StatelessWidget {
  final String mainOrderId;
  final String goodsId;
  final String len;
  final String returnId;
  AddShipmentSchedule(this.goodsId, this.mainOrderId, this.len, this.returnId);
  @override
  Widget build(BuildContext context) {
    // _getBackDetailInfo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('添加发货安排'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    ShipmentBatch(len),
                    DatePickerWidget(),
                    ProductInformation(),
                    OkBotton(mainOrderId, goodsId, len, returnId),
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
    await Provide.value<SalesOrderAddProvide>(context)
        .getQuotationDetail(goodsId);
    return '加载完成';
  }
}

class ShipmentBatch extends StatelessWidget {
  final String len;
  ShipmentBatch(this.len);

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.all(20),
      // color: Colors.white,
      child: _information('发货批次', len),
    );
  }

  // 发货批次组件
  Widget _information(title, content) {
    print('content$content');
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Text('$title'),
          ),
          Container(
            child: Text('${int.parse(content) + 1}'),
          )
        ],
      ),
    );
  }
}

// 发货时间使用有状态组件
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
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20),
        color: Colors.white,
        child: _onClick(context),
      );
    });
  }

  // 采购计划
  Widget _onClick(context) {
    return Container(
      child: InkWell(
        onTap: () async {
          var result = await showDatePicker(
            // selectableDayPredicate: (DateTime day) {
            //   return day.difference(DateTime.now()).inDays < 2;
            // },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            locale: Locale('zh'),
            lastDate: DateTime(2030),
          );
          if (result != null) {
            setState(() {
              dayTime = result.toString().substring(0, 10);
              Provide.value<SalesOrderAddProvide>(context)
                  .changeDayTime(result.toString().substring(0, 10));
            });
          }

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
              child: Text('计划发货时间'),
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

// // 选择发货时间
// class DatePickerWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
//       return Container(
//         padding: EdgeInsets.all(20),
//         margin: EdgeInsets.only(bottom: 20),
//         color: Colors.white,
//         child: _onClick(context),
//       );
//     });
//   }

//   // 采购计划
//   Widget _onClick(context) {
//     return Container(
//       child: InkWell(
//         onTap: () async {
//           var result = await showDatePicker(
//             selectableDayPredicate: (DateTime day) {
//               return day.difference(DateTime.now()).inDays < 2;
//             },
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2020),
//             locale: Locale('zh'),
//             lastDate: DateTime(2030),
//           );

//           Provide.value<SalesOrderAddProvide>(context)
//               .changeDayTime(result.toString().substring(0, 10));
//           print('选择时间12345678--${result.toString().substring(0, 10)}');
//           // 跳转到详情页面
//           // Application.router.navigateTo(context, "/plan?id=$id");
//         },
//         child: Row(
//           children: <Widget>[
//             Container(
//               child: Text(
//                 '*',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//             Container(
//               width: ScreenUtil().setWidth(180),
//               child: Text('计划发货时间'),
//             ),
//             Expanded(
//               child: Text(
//                   '${Provide.value<SalesOrderAddProvide>(context).planDeliveryTime == null ? '' : Provide.value<SalesOrderAddProvide>(context).planDeliveryTime}'),
//             ),
//             Container(
//               alignment: Alignment.centerRight,
//               child: Icon(
//                 Icons.keyboard_arrow_right,
//                 color: Colors.black12,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// 确定按钮
class OkBotton extends StatelessWidget {
  final String mainOrderId;
  final String goodsId;
  final String len;
  final String returnId;
  OkBotton(this.mainOrderId, this.goodsId, this.len, this.returnId);

  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderAddProvide>(context).salesList;
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
                        'orderItemId': element.id,
                        'planDeliveryNumber': element.planDeliveryNumber
                      });
                    });
                    _dispatchAdd(dispatchItems, context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _dispatchAdd(dispatchItems, context) {
    DateTime now = new DateTime.now();
    var dayTime = now.toString().substring(0, 10);
    var formData = {
      'subOrderId': goodsId,
      "mainOrderId": mainOrderId,
      "planDeliveryTime":
          Provide.value<SalesOrderAddProvide>(context).planDeliveryTime == null
              ? dayTime
              : Provide.value<SalesOrderAddProvide>(context).planDeliveryTime,
      "batch": int.parse(len) + 1,
      "dispatchItems": dispatchItems,
    };

    // return;
    request('dispatchAdd', formData: formData).then((val) {
      print('响应数据---$val');
      if (val['code'] == 0) {
        Fluttertoast.showToast(
          msg: '添加发货安排成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Application.router.navigateTo(context, "/salesdetail?id=$returnId");
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
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderAddProvide>(context).salesList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: _recommedList(goodsInfo),
          ),
        );
      } else {
        return Container(child: Text('加载中......'));
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
  Widget _shipmentquantity(item, index) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text('计划发货数量'),
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
                '已安排${item.totalPlanDeliveryNumber}，剩余${item.number - item.totalPlanDeliveryNumber}'),
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
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setHeight(100),
              padding: EdgeInsets.only(top: 0, right: 10),
              child: item.skuKey == null ||
                      item.skuKey == '' ||
                      item.skuKey == 'null'
                  ? Image.asset('images/default.png')
                  : Image.network(
                      '${item.skuKey}',
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(150),
                    )
              // Image.asset('images/icon.png'),
              ),
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
                    '数量：${item.number} ${item.unit}',
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
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderAddProvide>(context).goodsList;
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
        if (item.planDeliveryNumber <= 0) {
          return;
        } else {
          var num = item.planDeliveryNumber -= 1;
          Provide.value<SalesOrderAddProvide>(context)
              .getSalessList(index, num);
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(65),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.planDeliveryNumber > 0 ? Colors.white : Colors.black12,
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: item.planDeliveryNumber > 0 ? Text('-') : Text('-'),
      ),
    );
  }

  //添加按钮
  Widget _addBtn(context, item) {
    // 剩余存量
    int surplus = item.number - item.totalPlanDeliveryNumber;
    var num;
    return InkWell(
      onTap: () {
        num = item.planDeliveryNumber += 1;
        if (num <= surplus) {
          Provide.value<SalesOrderAddProvide>(context)
              .getSalessList(index, num);
        } else {
          num = surplus;
          Provide.value<SalesOrderAddProvide>(context)
              .getSalessList(index, num);
        }
        print(
            '比较${item.planDeliveryNumber <= (item.number - item.totalPlanDeliveryNumber)}');
      },
      child: Container(
        width: ScreenUtil().setWidth(65),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.planDeliveryNumber < surplus
                ? Colors.white
                : Colors.black12,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: item.planDeliveryNumber <= surplus ? Text('+') : Text('+'),
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
      child: Text('${item.planDeliveryNumber}'),
    );
  }
}
