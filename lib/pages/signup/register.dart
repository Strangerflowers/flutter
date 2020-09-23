import 'package:bid/common/count_down.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routers/application.dart';
import '../../service/service_method.dart';

const String TAG = 'Register';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("注册新账号"),
      ),
      body: SingleChildScrollView(
        child: HomeContent(),
      ),
    );
  }
}

class MyHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HomeContent();
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      // color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 20.0),
      child: FormDemo(),
    );
  }
}

class FormDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormDemoState();
  }
}

class FormDemoState extends State<FormDemo> {
  bool changeCount = false;
  bool autovalidateMobile = false;
  bool autovalidateOther = false;
  final registerFormKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // TextField has lost focus
        // 失去焦点收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
        // _showMessage();
      }
    });
    super.initState();
  }

  String mobile, code, companyName, companyShort;
  var errorMobileText = null;

  void registerForm() async {
    setState(() {
      autovalidateOther = true;
      autovalidateMobile = true;
    });
    registerFormKey.currentState.save();
    // registerFormKey.currentState.validate();
    if ((registerFormKey.currentState as FormState).validate()) {
      var formData = {
        "mobile": mobile,
        "checkCode": code,
      };
      var item = {
        "mobile": mobile,
        // 'code': code,
        'companyName': companyName,
        'companyShort': companyShort
      };

      // checkNameAndMobile
      LogUtils.debug(TAG, '校验公司名称$item', StackTrace.current);
      await request('checkNameAndMobile', formData: item).then((ele) {
        LogUtils.debug(
            TAG, '校验公司名称$ele====${ele['code'] == 0}', StackTrace.current);
        if (ele['code'] == 0) {
          request('verifyRegCheckCode', formData: formData).then((val) {
            LogUtils.debug(
                TAG, '$val====${val['code'] == 0}', StackTrace.current);
            if (val['code'] == 0) {
              LogUtils.debug(TAG, '判断是否跑进校验', StackTrace.current);
              Application.router.navigateTo(context,
                  "/setPassword?mobile=$mobile&companyName=${Uri.encodeComponent(companyName)}&companyShort=${Uri.encodeComponent(companyShort)}");
              // Application.router.navigateTo(context, "/setPassword?item=$item");
            } else {
              Toast.toast(
                context,
                msg: val['message'],
              );
            }
          });
        } else {
          Toast.toast(
            context,
            msg: ele['message'],
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidate: autovalidateOther,
                  focusNode: _focusNode,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                          '${this.companyName == null ? "" : this.companyName}',
                    ),
                  ), //判断keyword是否为空
                  // 保持光标在最后
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('公司名称'),
                    ),
                    hintText: "请输入公司名称",
                  ),
                  onChanged: (value) {
                    this.companyName = value;
                    // print('当前输入的公司名称----$value');
                  },
                  onSaved: (value) {
                    this.companyName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "用户名不能为空";
                    } else {
                      return null;
                    }
                    // return null;
                  },
                ),
                TextFormField(
                  autovalidate: autovalidateOther,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                          '${this.companyShort == null ? "" : this.companyShort}',
                    ),
                  ), //判断keyword是否为空
                  // 保持光标在最后
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('公司简称'),
                    ),
                    hintText: "请输入公司简称",
                  ),
                  onSaved: (value) {
                    this.companyShort = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "用户名不能为空";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // 输入模式设置为手机号
                  autovalidate: autovalidateMobile,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('账号'),
                    ),
                    errorText: errorMobileText,
                    hintText: "请输入手机号",
                  ),
                  onSaved: (value) {
                    this.mobile = value;
                  },
                  validator: validateMibile,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return "手机号码不能为空";
                  //   }
                  //   return null;
                  // },
                  onChanged: (v) {
                    registerFormKey.currentState.save();
                    this.mobile = v;
                    setState(() {
                      changeCount = validateMibile(mobile.toString()) == null
                          ? true
                          : false;
                    });
                    LogUtils.debug(
                        TAG, '获取验证码倒计时$changeCount', StackTrace.current);
                  },
                ),
                TextFormField(
                  autovalidate: autovalidateOther,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('验证码'),
                    ),
                    suffixIcon: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: LoginFormCode(
                        key: childKey,
                        isChange: changeCount,
                        countdown: 60,
                        available: true,
                        onTapCallback: (val, pWidget) {
                          LogUtils.debug(TAG, '回调: $val', StackTrace.current);
                          LogUtils.debug(TAG, pWidget, StackTrace.current);
                          _getPhoneCode(pWidget);
                        },
                      ),
                    ),
                    //     InkWell(
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 15),
                    //     child: Text('获取验证码'),
                    //   ),
                    //   onTap: _getPhoneCode,
                    // ),
                    hintText: "请输入验证码",
                  ),
                  onSaved: (value) {
                    this.code = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "验证码不能为空";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 44,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: FlatButton(
              //自定义按钮颜色
              // color: Colors.blue,
              color: Theme.of(context).primaryColor,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.blue,
              child: Text("下一步"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: registerForm,
            ),
          ),
        ],
      ),
    );
  }

  // 验证手机号码
  String validateMibile(String value) {
    errorMobileText = null;
    LogUtils.debug(TAG, '手机校验$value==$mobile', StackTrace.current);
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

    if (mobile.isEmpty) {
      LogUtils.debug(TAG, '手机校验为空：$mobile', StackTrace.current);
      return '手机号码不能为空';
    } else {
      if (!exp.hasMatch(mobile)) {
        LogUtils.debug(TAG, '手机校验规则不对', StackTrace.current);
        return '请输入正确的账号';
      } else {
        return null;
      }
    }
  }

  //
  // 获取验证码
  void _getPhoneCode(pWidget) async {
    autovalidateMobile = true;
    registerFormKey.currentState.save();
    if (mobile.isEmpty) {
      setState(() {
        errorMobileText = "手机号码不能为空";
      });
    } else {
      setState(() {
        errorMobileText = null;
      });
    }
    var flag = validateMibile(mobile.toString()) == null ? true : false;
    // registerFormKey.currentState.validate();
    if (flag) {
      var data = {'mobile': this.mobile};
      await requestGet('sendRegCaptcha', formData: data).then((val) {
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
}
