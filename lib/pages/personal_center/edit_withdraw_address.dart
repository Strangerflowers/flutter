import 'package:bid/common/log_utils.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import '../../common/log_utils.dart';

class EditWithdrawAddress extends StatefulWidget {
  final String id;
  EditWithdrawAddress(this.id);
  @override
  _EditWithdrawAddressState createState() => _EditWithdrawAddressState();
}

class _EditWithdrawAddressState extends State<EditWithdrawAddress> {
  String addressId;
  var addressInfo;
  void initState() {
    // _getShowEdit();
    addressId = widget.id;
    print('地址id$addressId');

    super.initState();
  }

  final editressFormKey = GlobalKey<FormState>();
  String areaCode, companyAddressName;
  bool autoValidate = false;
  var params = {
    'receiverName': '',
    'mobile': '',
    'address': '',
    'defaultAddress': '',
    'areaCode': '',
    'companyAddressName': ''
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder(
          future: _getShowEdit(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            print('回显退货地址====>${snapshot.data}');
            if (snapshot.hasData) {
              return _buildModifyPwdTextForm(data['result']);
            } else {
              return Container(
                child: Text('暂无数据'),
              );
            }
          }),
    );
  }

  Future _getShowEdit() async {
    var formData = {"id": addressId};
    var res = await requestGet('showEdit', formData: formData);
    return res;
  }

  /*
    * 构建导航栏
  */
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '编辑退货地址',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _showSelect() async {
    print('点击弹窗类型选着框');
    Result result = await CityPickers.showCityPicker(
        context: context,
        cancelWidget: Text('取消', style: TextStyle(color: Colors.black54)),
        confirmWidget: Text("确定", style: TextStyle(color: Colors.blue)));

    setState(() {
      editressFormKey.currentState.save();
      areaCode = result.areaId;
      companyAddressName =
          result.provinceName + result.cityName + result.areaName;
    });
  }

  Widget _buildModifyPwdTextForm(result) {
    params = {
      'receiverName': result['receiverName'],
      'mobile': result['mobile'].toString(),
      'address': result['address'],
      'defaultAddress': result['defaultAddress'].toString(),
      // 'areaCode': '',
      // 'companyAddressName': ''
    };
    areaCode = result['areaCode'];
    companyAddressName = result['areaName'];

    final _labels = new List<Object>();
    _labels.add({"label": "收件人:", "value": 'receiverName'});
    _labels.add({"label": "手机号码:", "value": 'mobile'});
    // _labels.add("所在地区:");
    _labels.add({"label": "详细地址:", "value": 'address'});
    List<Widget> list = [];
    for (Map label in _labels) {
      list.add(_buildRow(label));
    }
    list.insert(2, _selectAddress("所在地区:", result));
    // 确认按钮
    list.add(_buildSubmitBtn());
    return Form(
      key: editressFormKey,
      autovalidate: true,
      child: ListView(
        children: list,
      ),
    );
  }

  Widget _buildRow(item) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border(
        //   bottom: BorderSide(
        //     width: 1,
        //     color: Color(0xffe5e5e5),
        //   ),
        // ),
      ),
      child: new Row(
        children: [
          new Expanded(
            child: new Container(
              padding: EdgeInsets.all(15),
              // height: 30.0,
              decoration: BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                  ),
              // child: new Expanded(
              child: TextFormField(
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text:
                        '${params[item['value']] == null ? "" : params[item['value']]}',
                  ),
                ),
                decoration: InputDecoration(
                  prefixIcon: Container(
                    width: ScreenUtil().setWidth(140.0),
                    // padding: EdgeInsets.only(right: 20),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: '*',
                          style:
                              TextStyle(color: Color.fromRGBO(255, 113, 66, 1)),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${item['label']}',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Color(0xFF888888),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                //fontFamily: defaultFontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // border: InputBorder.none,
                ),
                //controller: controller,
                //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                maxLines: null, //最大行数
                autocorrect: true, //是否自动更正
                autofocus: false, //是否自动对焦
                autovalidate: autoValidate,
                obscureText: false, //是否是密码
                textAlign: TextAlign.left, //文本对齐方式
                style: TextStyle(
                  fontSize: 20.0,
                ), //输入文本的样式
                //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                onChanged: (value) {
                  params[item['value']] = value;
                },
                onSaved: (val) {
                  var key = item['value'];
                  // setState(() {
                  params[key] = val;
                  // });
                },
                validator: (value) {
                  if (item['value'] == 'mobile') {
                    // 正则匹配手机号
                    RegExp exp = RegExp(
                        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                    if (value.isEmpty) {
                      print('手机校验为空');
                      return '手机号码不能为空';
                    } else {
                      if (!exp.hasMatch(value)) {
                        print('手机校验规则不对');
                        return '请输入正确的账号';
                      } else {
                        return null;
                      }
                    }
                  } else {
                    if (value.isEmpty) {
                      return "不能为空";
                    }
                    return null;
                  }
                },
                enabled: true, //是否禁用
              ),
            ),
            // ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRow(item) {
  //   return new Container(
  //     decoration: BoxDecoration(
  //         border:
  //             Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
  //     child: new Row(
  //       children: [
  //         new Container(
  //           padding: EdgeInsets.all(15),
  //           child: new Text(
  //             '${item['label']}',
  //             style: TextStyle(
  //               decoration: TextDecoration.none,
  //               color: Color(0xFF888888),
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //               //fontFamily: defaultFontFamily,
  //             ),
  //           ),
  //         ),
  //         new Expanded(
  //           child: new Container(
  //             height: 30.0,
  //             decoration: BoxDecoration(
  //                 //border: new Border.all(color: Colors.red),
  //                 ),
  //             child: TextFormField(
  //               controller: TextEditingController.fromValue(
  //                 TextEditingValue(
  //                   text:
  //                       '${params[item['value']] == null ? "" : params[item['value']]}',
  //                 ),
  //               ),
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //               ),
  //               //controller: controller,
  //               //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
  //               maxLines: 1, //最大行数
  //               autocorrect: true, //是否自动更正
  //               autofocus: true, //是否自动对焦
  //               obscureText: false, //是否是密码
  //               textAlign: TextAlign.left, //文本对齐方式
  //               style: TextStyle(
  //                   fontSize: 20.0, color: Color(0xFF333333)), //输入文本的样式
  //               //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
  //               onChanged: (value) {
  //                 // var key = item['value'];
  //                 // setState(() {
  //                 //   params[key] = value;
  //                 // });
  //               },
  //               onSaved: (val) {
  //                 var key = item['value'];
  //                 setState(() {
  //                   params[key] = val;
  //                 });
  //               },
  //               enabled: true, //是否禁用
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // 下拉选择所在地区
  Widget _selectAddress(label, result) {
    return new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: new Row(
        children: [
          new Container(
            padding: EdgeInsets.all(15),
            child: new Text(
              '$label',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color(0xFF888888),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                //fontFamily: defaultFontFamily,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: _showSelect,
              child: StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFD7D7D7),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      companyAddressName == null ? '' : companyAddressName,
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFFD1D1D1),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      //这里写800已经超出屏幕了，可以理解为match_parent
      width: 800.0,
      margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      //类似cardview
      child: new Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff5f6fff), width: 1),
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular((30.0))),
        child: new FlatButton(
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            onPressed: () {
              autoValidate = true;

              editressFormKey.currentState.save();
              if ((editressFormKey.currentState as FormState).validate()) {
                var formData = {
                  "receiverName": params['receiverName'],
                  "mobile": params['mobile'],
                  "areaCode": areaCode,
                  "address": params['address'],
                  "defaultAddress": 1
                };
                LogUtils.d('[确认修改按钮]', formData);
                request('saveAddress', formData: formData).then((value) {
                  if (value['code'] == 0) {
                    Application.router
                        .navigateTo(context, Routes.WITHDRAW_ADDRESS_PAGE);
                  }
                  LogUtils.d('[返回值]', value);
                });
              }
            },

            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(50))),
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(
                '保存',
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )),
      ),
    );
  }
}
