import 'package:bid/common/log_utils.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import '../../common/log_utils.dart';

class AddWithdrawAddress extends StatefulWidget {
  @override
  _AddWithdrawAddressState createState() => _AddWithdrawAddressState();
}

class _AddWithdrawAddressState extends State<AddWithdrawAddress> {
  final addressFormKey = GlobalKey<FormState>();
  String areaCode, companyAddressName;
  bool check;
  var params = {
    'receiverName': '',
    'mobile': '',
    'address': '',
    'defaultAddress': 1,
    'areaCode': '',
    'companyAddressName': ''
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildModifyPwdTextForm(),
    );
  }

  /*
    * 构建导航栏
  */
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '新增退货地址',
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
      addressFormKey.currentState.save();
      areaCode = result.areaId;
      companyAddressName =
          result.provinceName + result.cityName + result.areaName;
    });
  }

  Widget _buildModifyPwdTextForm() {
    final _labels = new List<Object>();
    _labels.add({"label": "收件人:", "value": 'receiverName'});
    _labels.add({"label": "手机号码:", "value": 'mobile'});
    // _labels.add("所在地区:");
    _labels.add({"label": "详细地址:", "value": 'address'});
    List<Widget> list = [];
    for (Map label in _labels) {
      list.add(_buildRow(label));
    }
    list.insert(2, _selectAddress("所在地区:"));
    // list.insert(4, _checkBox());
    // 确认按钮
    list.add(_buildSubmitBtn());
    return Form(
      key: addressFormKey,
      child: ListView(
        children: list,
      ),
    );
  }

  Widget _buildRow(item) {
    return new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: new Row(
        children: [
          new Container(
            padding: EdgeInsets.all(15),
            child: new Text(
              '${item['label']}',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color(0xFF888888),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                //fontFamily: defaultFontFamily,
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              height: 30.0,
              decoration: BoxDecoration(
                  //border: new Border.all(color: Colors.red),
                  ),
              child: TextFormField(
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text:
                        '${params[item['value']] == null ? "" : params[item['value']]}',
                  ),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                //controller: controller,
                //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                maxLines: 1, //最大行数
                autocorrect: true, //是否自动更正
                autofocus: true, //是否自动对焦
                obscureText: false, //是否是密码
                textAlign: TextAlign.left, //文本对齐方式
                style: TextStyle(fontSize: 20.0, color: Colors.blue), //输入文本的样式
                //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                onChanged: (value) {},
                onSaved: (val) {
                  var key = item['value'];
                  setState(() {
                    params[key] = val;
                  });
                },
                enabled: true, //是否禁用
              ),
            ),
          ),
          // FlatButton(
          //   onPressed: () {
          //     setState(() {
          //       params[item['value']] = null;
          //     });
          //     // LogUtils.d(sprintf("[%s]", [item['label']), "被点击了删除按钮!");
          //   },
          //   child: new Image.asset(
          //     'images/clear.png',
          //     width: 20.0,
          //     height: 20.0,
          //   ),
          // )
        ],
      ),
    );
  }

  // 下拉选择所在地区
  Widget _selectAddress(label) {
    return new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: new Row(
        children: [
          new Container(
            padding: EdgeInsets.all(15),
            child: new Text(
              label,
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

  Widget _checkBox() {
    return Container(
      child: Checkbox(
        value: check,
        onChanged: (value) {
          setState(() {
            check = value;
          });
        },
        activeColor: Colors.black,
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
              addressFormKey.currentState.save();
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
