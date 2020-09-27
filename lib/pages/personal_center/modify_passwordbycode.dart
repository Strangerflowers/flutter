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
  String mobile, checkCode, newPwd, confirmNewpwd;
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
      resizeToAvoidBottomInset: false,
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
    if (flag) {
      var data = {'mobile': mobile};
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
    return Form(
      key: setPawwordFormKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            // height: 30.0,
            decoration: BoxDecoration(
                //border: new Border.all(color: Colors.red),
                ),
            // child: new Expanded(
            child: TextFormField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: '${mobile == null ? "" : mobile}',
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: '${mobile}'.length),
                  ),
                ),
              ),
              decoration: InputDecoration(
                errorText: errorMobileText,
                hintText: "请输入手机号",
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(150),
                  // margin: EdgeInsets.only(top: 10.0, right: 5.0),
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
                            text: '账号',
                            style: TextStyle(
                              // fontSize: ScreenUtil().setSp(32),
                              decoration: TextDecoration.none,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                suffixIcon: mobile == null || mobile == ''
                    ? Text('')
                    : Container(
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              mobile = '';
                            });

                            // LogUtils.d(sprintf("[%s]", params), "被点击了删除按钮!");
                          },
                          child: new Image.asset(
                            'images/clear.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                // border: InputBorder.none,
              ),
              //controller: controller,
              //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: false, //是否自动对焦
              autovalidate: mobileValidate,
              obscureText: false, //是否是密码
              textAlign: TextAlign.left, //文本对齐方式
              style: TextStyle(
                  // fontSize: 20.0,
                  ), //输入文本的样式
              //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
              onChanged: (v) {
                mobile = v;
                setState(() {
                  changeCount =
                      validateMibile(mobile.toString()) == null ? true : false;
                });
              },
              onSaved: (val) {
                mobile = val;
              },
              validator: (value) {
                RegExp exp = RegExp(
                    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                if (value.isEmpty) {
                  return '手机号码不能为空';
                } else if (!exp.hasMatch(value)) {
                  return '请输入正确的账号';
                } else {
                  return null;
                }
              },
              enabled: true, //是否禁用
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(),
            child: TextFormField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: '${checkCode == null ? "" : checkCode}',
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: '${checkCode}'.length),
                  ),
                ),
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(150),
                  // margin: EdgeInsets.only(top: 10.0, right: 5.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '*',
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: '验证码',
                            style: TextStyle(
                              // fontSize: ScreenUtil().setSp(32),
                              decoration: TextDecoration.none,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                hintText: "请输入验证码",
                suffixIcon: Container(
                  padding: EdgeInsets.only(right: 20, top: 10),
                  child: LoginFormCode(
                    key: childKey,
                    isChange: changeCount,
                    countdown: 60,
                    available: true,
                    onTapCallback: (val, pWidget) {
                      _getPhoneCode(pWidget);
                    },
                  ),
                ),
                // border: InputBorder.none,
              ),
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: false, //是否自动对焦
              autovalidate: autoValidate,
              obscureText: false, //是否是密码
              textAlign: TextAlign.left, //文本对齐方式
              style: TextStyle(
                  // fontSize: 20.0,
                  ), //输入文本的样式
              //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
              onChanged: (v) {
                checkCode = v;
              },
              onSaved: (val) {
                checkCode = val;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '验证码不能为空';
                } else {
                  return null;
                }
              },
              enabled: true, //是否禁用
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(),
            child: TextFormField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: '${newPwd == null ? "" : newPwd}',
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: '${newPwd}'.length),
                  ),
                ),
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(150),
                  // margin: EdgeInsets.only(top: 10.0, right: 5.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '*',
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: '登录密码',
                            style: TextStyle(
                              // fontSize: ScreenUtil().setSp(32),
                              decoration: TextDecoration.none,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                hintText: "请输入登录密码",
                suffixIcon: newPwd == null || newPwd == ''
                    ? Text('')
                    : Container(
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              newPwd = '';
                            });

                            // LogUtils.d(sprintf("[%s]", params), "被点击了删除按钮!");
                          },
                          child: new Image.asset(
                            'images/clear.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                // border: InputBorder.none,
              ),
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: false, //是否自动对焦
              autovalidate: autoValidate,
              obscureText: true, //是否是密码
              textAlign: TextAlign.left, //文本对齐方式
              style: TextStyle(
                  // fontSize: 20.0,
                  ),
              //输入文本的样式
              //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
              onChanged: (v) {
                setState(() {});
                newPwd = v;
              },
              onSaved: (val) {
                newPwd = val;
              },

              validator: (value) {
                RegExp exp =
                    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,18}$');
                if (value.isEmpty) {
                  return '登录密码不能为空';
                } else if (!exp.hasMatch(value)) {
                  return '8-18位数字大小写字母的组合';
                } else {
                  return null;
                }
              },
              enabled: true, //是否禁用
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(),
            child: TextFormField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: '${confirmNewpwd == null ? "" : confirmNewpwd}',
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: '${confirmNewpwd}'.length),
                  ),
                ),
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(150),
                  // margin: EdgeInsets.only(top: 10.0, right: 5.0),
                  // width: ScreenUtil().setWidth(160.0),
                  // padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '*',
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: '确认密码',
                            style: TextStyle(
                              // fontSize: ScreenUtil().setSp(32),
                              decoration: TextDecoration.none,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                hintText: "请输入确认密码",
                suffixIcon: confirmNewpwd == null || confirmNewpwd == ''
                    ? Text('')
                    : Container(
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              confirmNewpwd = '';
                            });

                            // LogUtils.d(sprintf("[%s]", params), "被点击了删除按钮!");
                          },
                          child: new Image.asset(
                            'images/clear.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                // border: InputBorder.none,
              ),
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: false, //是否自动对焦
              autovalidate: autoValidate,
              obscureText: true, //是否是密码
              textAlign: TextAlign.left, //文本对齐方式
              style: TextStyle(
                  // fontSize: 20.0,
                  ), //输入文本的样式
              //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
              onChanged: (v) {
                confirmNewpwd = v;
                setState(() {});
              },
              onSaved: (val) {
                confirmNewpwd = val;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '确认密码不能为空';
                } else if (newPwd != confirmNewpwd) {
                  return '确认密码与登录密码不一致，请重新输入';
                } else {
                  return null;
                }
              },
              enabled: true, //是否禁用
            ),
          ),
          _buildSubmitBtn(),
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
    setState(() {
      autoValidate = true;
      mobileValidate = true;
    });

    setPawwordFormKey.currentState.save();
    if ((setPawwordFormKey.currentState as FormState).validate()) {
      var data = {
        "newPwd": newPwd, //新密码
        "checkCode": checkCode, //验证码
        "mobile": mobile
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
