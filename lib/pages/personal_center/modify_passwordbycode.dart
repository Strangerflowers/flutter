import 'package:bid/common/count_down.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/toast.dart';
import 'package:bid/pages/signup/signin.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyPasswordByCode extends StatefulWidget {
  @override
  _ModifyPasswordByCodeState createState() => _ModifyPasswordByCodeState();
}

class _ModifyPasswordByCodeState extends State<ModifyPasswordByCode> {
  static String TAG = "_ModifyPasswordByCodeState";
  bool changeCount = false;
  bool autoValidate = false;
  bool mobileValidate = false;
  final setPawwordFormKey = GlobalKey<FormState>();
  var params = {
    'mobile': '',
    'checkCode': '',
    'newPwd': '',
    'confirmNewpwd': ''
  };

  var errorMobileText;
  // String mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改密码'),
      ),
      body: _buildModifyPwdTextForm(),
    );
  }

  // 密码校验
  String validatePwd(String value) {
    print('密码验证码$value');
    // 正则匹配手机号
    RegExp exp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,18}$');

    if (value.isEmpty) {
      return '密码不能为空';
    } else {
      if (!exp.hasMatch(value)) {
        return '8-18位数字大小写字母的组合';
      } else {
        return null;
      }
    }
  }

  // 验证手机号码
  String validateMibile(String value) {
    errorMobileText = null;
    print('手机校验$value==');
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

    if (value.isEmpty) {
      print('手机校验为空====');
      return '手机号码不能为空';
    } else {
      if (!exp.hasMatch(value)) {
        print('手机校验规则不对');
        return '请输入正确的账号';
      } else {
        return null;
      }
    }
  }

  // 获取验证码
  void _getPhoneCode(pWidget) async {
    mobileValidate = true;
    setPawwordFormKey.currentState.save();
    if (params['mobile'].isEmpty) {
      setState(() {
        errorMobileText = "手机号码不能为空";
      });
    } else {
      setState(() {
        errorMobileText = null;
      });
    }
    var flag =
        validateMibile(params['mobile'].toString()) == null ? true : false;
    if (flag) {
      var data = {'mobile': params['mobile']};
      print('获取验证码注册$data');
      await requestGet('getModifyPasswordCode', formData: data).then((val) {
        LogUtils.debug(TAG, val, StackTrace.current);
        if (val['success'] == false) {
          pWidget.restTimer();
        }
        Toast.toast(
          context,
          msg: val['message'],
        );
      });
    }
  }

  Widget _buildModifyPwdTextForm() {
    final _labels = new List<Object>();
    _labels.add({"label": "账号:", "value": 'mobile', "flag": false});
    _labels.add({"label": "验证码:", "value": 'checkCode', "flag": false});
    _labels.add({"label": "新密码:", "value": 'newPwd', "flag": true});
    _labels.add({"label": "确认密码:", "value": 'confirmNewpwd', "flag": true});
    List<Widget> list = [];
    for (var label in _labels) {
      list.add(_buildRow(label));
    }
    // 确认按钮
    list.add(_buildSubmitBtn());
    return Form(
      key: setPawwordFormKey,
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
                    // 保持光标在最后
                    selection: TextSelection.fromPosition(
                      TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: '${params[item['value']]}'.length),
                    ),
                  ),
                ),
                decoration: InputDecoration(
                  errorText: item['value'] == 'mobile' ? errorMobileText : null,
                  prefixIcon: Container(
                    width: ScreenUtil().setWidth(140.0),
                    // padding: EdgeInsets.only(right: 20),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: '*',
                          style: TextStyle(
                              // color: Color.fromRGBO(255, 113, 66, 1),
                              ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${item['label']}',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Color(0xFF222222),
                                // fontSize: 14,
                                // fontWeight: FontWeight.bold,
                                //fontFamily: defaultFontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: _showText(item),
                  // border: InputBorder.none,
                ),
                //controller: controller,
                //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                maxLines: null, //最大行数
                autocorrect: true, //是否自动更正
                autofocus: false, //是否自动对焦
                autovalidate:
                    item['value'] == 'mobile' ? mobileValidate : autoValidate,
                obscureText: false, //是否是密码
                textAlign: TextAlign.left, //文本对齐方式
                style: TextStyle(
                  fontSize: 20.0,
                ), //输入文本的样式
                //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                onChanged: (v) {
                  if (item['value'] == 'mobile') {
                    params[item['value']] = v;
                    if (v.length == 11) {
                      setPawwordFormKey.currentState.save();
                      setState(() {
                        changeCount =
                            validateMibile(params[item['value']].toString()) ==
                                    null
                                ? true
                                : false;
                      });
                    }
                  } else if (item['value'] == 'newPwd') {
                    setPawwordFormKey.currentState.save();
                  }
                },
                onSaved: (val) {
                  var key = item['value'];
                  setState(() {
                    params[key] = val;
                  });
                },
                validator: (value) {
                  if (item['value'] == 'mobile') {
                    // 正则匹配手机号
                    RegExp exp = RegExp(
                        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                    if (value.isEmpty) {
                      return '手机号码不能为空';
                    } else {
                      if (!exp.hasMatch(value)) {
                        return '请输入正确的账号';
                      } else {
                        return null;
                      }
                    }
                  } else if (item['value'] == 'newPwd') {
                    print('密码验证码$value');
                    // 正则匹配手机号
                    RegExp exp =
                        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,18}$');

                    if (value.isEmpty) {
                      return '密码不能为空';
                    } else {
                      if (!exp.hasMatch(value)) {
                        return '8-18位数字大小写字母的组合';
                      } else {
                        return null;
                      }
                    }
                  } else if (item['value'] == 'confirmNewpwd') {
                    // setPawwordFormKey.currentState.save();
                    if (value.isEmpty) {
                      return "不能为空";
                    } else {
                      if (value != params['newPwd']) {
                        return '两次密码不一致';
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
          // _showText(item),
        ],
      ),
    );
  }

/*
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
              item['label'],
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
                        '${params[item['value']] == null ? "" : params[item['value']]}', //判断keyword是否为空
                    // 保持光标在最后
                    selection: TextSelection.fromPosition(
                      TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: '${params[item['value']]}'.length),
                    ),
                  ),
                ),

                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                //controller: controller,
                //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                maxLines: 1, //最大行数
                autocorrect: true, //是否自动更正
                autofocus: false, //是否自动对焦
                obscureText: item['flag'], //是否是密码
                textAlign: TextAlign.left, //文本对齐方式
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF333333),
                ), //输入文本的样式
                //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                onChanged: (text) {
                  //内容改变的回调
                  // LogUtils.d(sprintf('[%s]', [label]), 'change $text');
                },
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
         
        ],
      ),
    );
  }
*/
  Widget _showText(item) {
    if (item['label'] == "验证码:") {
      return Container(
        padding: EdgeInsets.only(right: 20),
        child: LoginFormCode(
          key: childKey,
          isChange: changeCount,
          countdown: 60,
          available: true,
          onTapCallback: (val, pWidget) {
            _getPhoneCode(pWidget);
          },
        ),
        // child: FlatButton(
        //   // color: Colors.blue,
        //   highlightColor: Colors.blue[700],
        //   // colorBrightness: Brightness.dark,
        //   splashColor: Colors.grey,
        //   child: Text(
        //     '获取验证码',
        //     style: TextStyle(
        //       color: Color(0xFF4389ED),
        //     ),
        //   ),
        //   shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       color: Color(0xFF4389ED),
        //       width: 1,
        //     ),
        //     borderRadius: BorderRadius.circular(20.0),
        //   ),
        //   onPressed: () {
        //     _getPhoneCode();
        //   },
        // ),
      );
    } else {
      return Container(
        child: FlatButton(
          onPressed: () {
            setPawwordFormKey.currentState.save();
            setState(() {
              params[item['value']] = '';
            });

            print('当前点击的删除键${item['value']}====>$params');
            // LogUtils.d(sprintf("[%s]", params), "被点击了删除按钮!");
          },
          child: new Image.asset(
            'images/clear.png',
            width: 20.0,
            height: 20.0,
          ),
        ),
      );
    }
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
              _submit();
              // LogUtils.d('[确认修改按钮]', '被点击!');
            },
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(50))),
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(
                '确认修改',
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )),
      ),
    );
  }

  void _submit() async {
    autoValidate = true;
    mobileValidate = true;
    setPawwordFormKey.currentState.save();
    if ((setPawwordFormKey.currentState as FormState).validate()) {
      var data = {
        "newPwd": params['newPwd'], //新密码
        "checkCode": params['checkCode'], //验证码
        "mobile": params['mobile']
      };

      print('修改密码$data');
      await request('resetPwdByCode', formData: data).then((val) {
        print('----------------------$val');
        if (val['code'] == 0) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // title: Text('退出登录提示'),
                  content: Text('您已成功修改密码，请重新登录!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确认'),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final result = await prefs.clear();
                        if (result) {
                          Navigator.of(context).pop('cancel');
                          Application.router.navigateTo(context, '/sigin');
                        }
                      },
                    ),
                  ],
                );
              });
        } else {
          Toast.toast(
            context,
            msg: val['message'],
          );
        }
      });
    }
  }
}
