import 'package:bid/common/string_utils.dart';
import 'package:bid/models/sales_add_shipment_model.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../../service/service_method.dart';
import '../../provide/sales_add_shipment_provide.dart';
import '../../routers/application.dart';

class AddShipmentSchedule extends StatefulWidget {
  final String mainOrderId;
  final String goodsId;
  final String len;
  final String returnId;
  AddShipmentSchedule(this.goodsId, this.mainOrderId, this.len, this.returnId);
  @override
  _AddShipmentScheduleState createState() => _AddShipmentScheduleState();
}

class _AddShipmentScheduleState extends State<AddShipmentSchedule> {
  String mainOrderId;
  String goodsId;
  String len;
  String returnId;
  var _getBackDetailInfo;
  void initState() {
    mainOrderId = widget.mainOrderId;
    goodsId = widget.goodsId;
    len = widget.len;
    returnId = widget.returnId;
    _getBackDetailInfo = _getDate();
    super.initState();
  }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class AddShipmentSchedule extends StatelessWidget {
//   final String mainOrderId;
//   final String goodsId;
//   final String len;
//   final String returnId;
//   AddShipmentSchedule(this.goodsId, this.mainOrderId, this.len, this.returnId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加发货安排'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            var data = AddDeliverArrange.fromJson(snapshot.data);

            if (data.result != null) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ShipmentBatch(len),
                      DatePickerWidget(),
                      ProductInformation(data.result),
                      OkBotton(
                          mainOrderId, goodsId, len, returnId, data.result),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: Text('暂无数据'),
              );
            }
          }
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
        },
      ),
    );
  }

  Future _getDate() async {
    var formData = {'subOrderId': goodsId};
    var response = await requestGet('queryItemById', formData: formData);
    response['result'].forEach((ele) {
      ele['planDeliveryNumber'] = 0;
      return ele;
    });
    return response;
  }
  // Future _getBackDetailInfo(BuildContext context) async {
  //   await Provide.value<SalesOrderAddProvide>(context)
  //       .getQuotationDetail(goodsId);
  //   return '加载完成';
  // }
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
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            locale: Locale('zh', 'CH'),
            lastDate: DateTime(2030),
          ).then((DateTime val) {
            if (val != null) {
              setState(() {
                dayTime = val.toString().substring(0, 10);
                Provide.value<SalesOrderAddProvide>(context)
                    .changeDayTime(val.toString().substring(0, 10));
              });
            }
            print(val); // 2018-07-12 00:00:00.000
          }).catchError((err) {
            print(err);
          });
          // var result = await showDatePicker(
          //   // selectableDayPredicate: (DateTime day) {
          //   //   return day.difference(DateTime.now()).inDays < 2;
          //   // },
          //   context: context,
          //   initialDate: DateTime.now(),
          //   firstDate: DateTime(2020),
          //   locale: Locale('zh'),
          //   lastDate: DateTime(2030),
          // );
          // if (result != null) {
          //   setState(() {
          //     dayTime = result.toString().substring(0, 10);
          //     Provide.value<SalesOrderAddProvide>(context)
          //         .changeDayTime(result.toString().substring(0, 10));
          //   });
          // }

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
  final data;
  OkBotton(this.mainOrderId, this.goodsId, this.len, this.returnId, this.data);

  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      // var goodsInfo = Provide.value<SalesOrderAddProvide>(context).salesList;
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
                    data.forEach((element) {
                      print('获取到的id====￥${element.planDeliveryNumber}');
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
        // Navigator.pop(context);
        Application.router
            .navigateTo(context, "/salesdetail?id=$returnId", replace: true);
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
class ProductInformation extends StatefulWidget {
  final data;
  ProductInformation(this.data);
  @override
  _ProductInformationState createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  var data;
  void initState() {
    data = widget.data;
    super.initState();
  }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class ProductInformation extends StatelessWidget {
//   final data;
//   ProductInformation(this.data);
  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderAddProvide>(context).salesList;
      // if (goodsInfo != null) {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: _recommedList(data),
        ),
      );
      // } else {
      //   return Container(child: Text('加载中......'));
      // }
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
    var surplusNum;
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
                  // child: Text('111'),
                  child: CartCount(item, index, (num) {
                    print('NUM----￥$num');
                    setState(() {});
                  }),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
                '已安排${item.totalPlanDeliveryNumber}，剩余${item.number - item.totalPlanDeliveryNumber - item.planDeliveryNumber <= 0 ? 0 : item.number - item.totalPlanDeliveryNumber - item.planDeliveryNumber}'),
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
            child: ImageWidgetBuilder.loadImage(
                StringUtils.defaultIfEmpty(item.mainKey, '')),
            // child: item.skuKey == null ||
            //         item.skuKey == '' ||
            //         item.skuKey == 'null'
            //     ? Image.asset('images/default.png')
            //     : Image.network(
            //         '${item.skuKey}',
            //         fit: BoxFit.cover,
            //         width: ScreenUtil().setWidth(150),
            //         height: ScreenUtil().setHeight(150),
            //       ),
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
class CartCount extends StatefulWidget {
  var item;
  int index;

  final Function(int) changed;
  CartCount(this.item, this.index, this.changed);
  @override
  _CartCountState createState() => _CartCountState();
}

class _CartCountState extends State<CartCount> {
  var item;
  int index;
  void initState() {
    item = widget.item;
    index = widget.index;
    super.initState();
  }
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
// class CartCount extends StatelessWidget {
  // var item;
  // int index;
  // CartCount(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Provide<SalesOrderAddProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<SalesOrderAddProvide>(context).goodsList;
      return Container(
        width: ScreenUtil().setWidth(260),
        height: ScreenUtil().setHeight(45),
        // margin: EdgeInsets.only(top: 5.0),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              // right: 0,
              top: 0,
              child: _reduceBtn(context),
            ),
            Positioned(
              bottom: -10,
              left: 40,
              top: -15,
              right: 30,
              child: _countArea(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _addBtn(context, item),
            ),
            // _reduceBtn(context),
            // _countArea(),
            // _addBtn(context, item),
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
          setState(() {
            item.planDeliveryNumber -= 1;
          });
          widget.changed(1);
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
    int num;
    return InkWell(
      onTap: () {
        if (item.planDeliveryNumber >= 999999) {
          return;
        }
        setState(() {
          item.planDeliveryNumber += 1;
        });
        num = item.number -
                    item.totalPlanDeliveryNumber -
                    item.planDeliveryNumber <=
                0
            ? 0
            : item.number -
                item.totalPlanDeliveryNumber -
                item.planDeliveryNumber;
        widget.changed(num);
        // if (num <= surplus) {
        //   Provide.value<SalesOrderAddProvide>(context)
        //       .getSalessList(index, num);
        // } else {
        //   num = surplus;
        //   Provide.value<SalesOrderAddProvide>(context)
        //       .getSalessList(index, num);
        // }
        // print(
        //     '比较${item.planDeliveryNumber <= (item.number - item.totalPlanDeliveryNumber)}');
      },
      child: Container(
        width: ScreenUtil().setWidth(65),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.planDeliveryNumber >= 999999
                ? Colors.black12
                : Colors.white,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  //中间数量显示区域
  Widget _countArea() {
    var showNum;
    return Container(
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.center,
      color: Colors.white,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        // controller:
        // new TextEditingController(text: item.planDeliveryNumber.toString()),
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text:
                '${item.planDeliveryNumber == null ? "" : item.planDeliveryNumber}',
            // 保持光标在最后
            selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: '${item.planDeliveryNumber}'.length),
            ),
          ),
        ),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          // LengthLimitingTextInputFormatter(5)
        ], //只允许输入数字
        maxLines: null, //最大行数
        // maxLength: 6,
        autocorrect: true, //是否自动更正
        autofocus: false, //是否自动对焦
        // autovalidate: item['value'] == 'mobile' ? mobileValidate : autoValidate,
        obscureText: false, //是否是密码
        textAlign: TextAlign.left, //文本对齐方式
        style: TextStyle(
          fontSize: 14.0,
        ), //输入文本的样式
        //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
        onChanged: (v) {
          if (v == '') {
            item.planDeliveryNumber = 0;
            widget.changed(1);
          } else {
            if (v.length >= 6) {
              showNum = int.parse(v.substring(0, 6));
              print('输入${showNum}');
            } else {
              showNum = int.parse(v);
            }

            // if (showNum > 999999) {
            //   showNum = 999999;
            // }
            setState(() {
              item.planDeliveryNumber = showNum;
            });
          }

          widget.changed(1);
          print('v====${item.planDeliveryNumber}');
        },
        validator: (value) {
          if (int.parse(value) >= 999999) {
            return '不能超过999999';
          }
          return null;
        },
        // onSaved: (val) {},
      ),
      // child: Text('${item.planDeliveryNumber}'),
    );
  }
}
