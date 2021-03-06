import 'package:bid/common/count_down.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/toast.dart';
import 'package:bid/service/service_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './register.dart';
import '../../routers/application.dart';

Dio dio = Dio();

const String TAG = "signin";

class FormTestRoute extends StatefulWidget {
  @override
  _FormTestRouteState createState() => new _FormTestRouteState();
}

class _FormTestRouteState extends State<FormTestRoute> {
  final List tabBodies = [
    FormPage(),
    MobileFormPage(),
    // PersonalCenter(),
  ];
  int currentIndex = 0;

  // TextEditingController _unameController = new TextEditingController();
  // TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _accountAutoFocus = false;
  @override
  void initState() {
    //监听输入改变
    _unameController.addListener(() {
      print(_unameController.text);
      print(_pwdController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '注册页面',
      home: FlutterEasyLoading(
        child: Scaffold(
          appBar: AppBar(
            title: Text("登录"),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // Navigator.pop(context); //销毁当前页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // return FormTestRoute();
                              return Register();
                            },
                          ),
                        );
                      },
                      child: Container(
                        child: Text('注册'),
                        alignment: Alignment.topRight,
                      ),
                    ),

                    new Image.asset('images/icon.png'),
                    Container(
                      child: Row(
                        children: <Widget>[
                          // Mysignup(),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                                print("点击了 title $context");
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                  border: currentIndex == 0
                                      ? Border(
                                          bottom: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  '账号密码登录',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: currentIndex == 0
                                        ? Colors.blue
                                        : Colors.grey,
                                    fontSize: 18.0,
                                    height: 1.2,
                                    fontFamily: "Courier",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //垂直分割线
                          SizedBox(
                            width: 1,
                            height: 12,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                                LogUtils.debug(TAG, "点击了 title 手机验证码登录",
                                    StackTrace.current);
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                                decoration: BoxDecoration(
                                  border: currentIndex == 1
                                      ? Border(
                                          bottom: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  '手机验证码登录',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: currentIndex == 1
                                        ? Colors.blue
                                        : Colors.grey,
                                    fontSize: 18.0,
                                    height: 1.2,
                                    fontFamily: "Courier",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: tabBodies[currentIndex],
                    ),
                    // FormPage() //form表单
                  ],
                ),
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 账号密码表单组件--通过账号密码登录
class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

TextEditingController _unameController = new TextEditingController();
TextEditingController _pwdController = new TextEditingController();
bool pwdShow = false; //密码是否显示明文
GlobalKey _formKey = new GlobalKey<FormState>();
bool _accountAutoFocus = false;
// 验证账号
String validateAccount(value) {
  // 对账号进行判空校验
  if (value.isEmpty) {
    return '账号不能为空';
  }
}

// 验证密码
String validatePassword(value) {
  if (value.isEmpty) {
    return '密码不能为空';
  }
}

class _FormPageState extends State<FormPage> {
  String token;
  var prefs;
  void initState() {
    setUserData();
    super.initState();
  }

  setUserData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey, //设置globalKey，用于后面获取FormState
        autovalidate: _accountAutoFocus, //开启自动校验
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    controller: _unameController,
                    decoration: InputDecoration(
                      // labelText: "用户名",
                      hintText: "请输入账号",
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _unameController.text = "";
                        },
                      ),
                    ),
                    // 校验用户名
                    validator: validateAccount,
                  ),
                  TextFormField(
                    controller: _pwdController,
                    decoration: InputDecoration(
                      // labelText: "密码",
                      hintText: "请输入登录密码",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _pwdController.text = "";
                        },
                      ),
                    ),
                    obscureText: !pwdShow,
                    //校验密码
                    validator: validatePassword,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Application.router
                            .navigateTo(context, "/modifyPasswordByCode");
                      },
                      child: Text(
                        '忘记密码',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color(0xFF649FEA)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 登录按钮
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              // width:200.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      //自定义按钮颜色
                      color: Theme.of(context).primaryColor,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.blue,
                      child: Text("登录"),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: _choiceAction,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _checkAuditStatus() async {
    await requestGet('checkAuditStatus').then((val) {
      if (val['code'] == 0) {
        prefs.setInt('auditStatusStatus', val['result']['auditStatus']);
        if (val['result']['auditStatus'] == 0) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/indexPage");
        } else if (val['result']['auditStatus'] == 2 ||
            val['result']['auditStatus'] == 3) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/authentication");
        } else if (val['result']['auditStatus'] == 1) {
          Application.router
              .navigateTo(context, "/certificateInfo", replace: true);
        }
        // if (val['result']['auditStatus'] == 0) {
        //   Navigator.pop(context);
        //   Application.router.navigateTo(context, "/indexPage");
        // } else {
        //   Navigator.pop(context);
        //   Application.router.navigateTo(context, "/authentication");
        // }
      } else {
        Toast.toast(
          context,
          msg: val['message'],
        );
      }
    });
  }

  void _choiceAction() async {
    if ((_formKey.currentState as FormState).validate()) {
      var data = {
        'loginAcc': _unameController.text.toString(),
        'pwd': _pwdController.text.toString()
      };
      request('login', formData: data).then((val) {
        print('账号密码响应数据$val');
        if (val['code'] == 0) {
          var tgt = {
            "tgt": val['result'],
            "serviceUrl": "https://www.baidu.com",
            "setExpirationSeconds": "518400"
          };
          request('getToken', formData: tgt).then((value) {
            if (value['code'] == 0) {
              setState(() {
                prefs.setString('token', value['result']['token']);
                prefs.setString('userId', value['result']['userId']);
              });
              _checkAuditStatus();
            } else {
              Toast.toast(
                context,
                msg: value['message'],
              );
              // print('手机登录不成');
            }
          });
        } else {
          Toast.toast(
            context,
            msg: val['message'],
          );
        }
      });
      // getHttp(data).then((val) async {
      //   final prefs = await SharedPreferences.getInstance();
      //   if (val['code'] == 0) {
      //     getToken(val['result']).then((value) {
      //       print("返回的TGT===>${value['result']['token']}");
      //       if (value['code'] == 0) {
      //         setState(() {
      //           prefs.setString('token', value['result']['token']);
      //           prefs.setString('userId', value['result']['userId']);
      //         });
      //         print('持久胡========》${prefs.getString('token')}');
      //         _checkAuditStatus();
      //         // Application.router.navigateTo(context, "/indexPage");
      //       } else {
      //         Toast.toast(
      //           context,
      //           msg: value['message'],
      //         );

      //       }
      //     });
      //   } else {
      //     Toast.toast(
      //       context,
      //       msg: val['message'],
      //     );
      //     // showDialog(
      //     //   context: context,
      //     //   builder: (context) => AlertDialog(
      //     //     title: Text("${val['message']}"),
      //     //   ),
      //     // );
      //   }
      // });
    } else {
      setState(() {
        _accountAutoFocus = true;
      });
    }
  }

  // 声明一个内部方法去调接口数据 GET 请求
  Future getHttp(Map TypeText) async {
    try {
      print('传参TypeText$TypeText');
      // var data = {'loginAcc': 'ptest', 'pwd': 123456};
      var data = TypeText;
      Response resposne;
      resposne = await Dio().post(
          "http://osapi-dev.gtland.cn/os_kernel_authcctr/app/authcctr/authc/tgt/login",
          data: data);
      return resposne.data;
    } catch (e) {
      return print(e);
    }
  }

  // 获取token
  Future getToken(String TypeText) async {
    try {
      // print('传参TypeText$TypeText');
      var data = {
        "tgt": TypeText,
        "serviceUrl": "https://www.baidu.com",
        "setExpirationSeconds": "518400"
      };
      Response resposne;
      resposne = await Dio().post(
          "http://osapi-dev.gtland.cn/os_kernel_authcctr/app/authc/token/getAndSetTime",
          data: data);
      // print(resposne.data);
      return resposne.data;
    } catch (e) {
      return print(e);
    }
  }
}

// 账号密码表单组件--通过手机验证码登录登录====================================================================================
class MobileFormPage extends StatefulWidget {
  @override
  _MobileFormPageState createState() => _MobileFormPageState();
}

// TextEditingController _mobileController = new TextEditingController();
// TextEditingController _codeController = new TextEditingController();
// bool pwdShow = false; //密码是否显示明文
// GlobalKey _mobileformKey = new GlobalKey<FormState>();

class _MobileFormPageState extends State<MobileFormPage> {
  // bool _mobileAutoFocus = true;
  bool isMobilesignin = false; //是否已获取验证码

  bool changeCount = false;
  var errorMobileText;
  bool autovalidateMobile = false;
  bool autovalidateCode = false;
  String loginAcc, captcha;
  // final sendCodeFormKey = GlobalKey<FormState>();
  final _mobileformKey = GlobalKey<FormState>();
  var prefs;
  @override
  void initState() {
    setUserData();
    super.initState();
  }

  setUserData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _mobileformKey, //设置globalKey，用于后面获取FormState
      // autovalidate: true, //开启自动校验
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                          '${loginAcc == null ? "" : loginAcc}', //判断keyword是否为空
                      // 保持光标在最后
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${loginAcc}'.length),
                      ),
                    ),
                  ),
                  autofocus: false,
                  autovalidate: autovalidateMobile,
                  // 输入模式设置为手机号
                  keyboardType: TextInputType.phone,
                  // controller: _mobileController,
                  decoration: InputDecoration(
                      // labelText: "用户名",
                      errorText: errorMobileText,
                      hintText: "请输入手机",
                      prefixIcon: Icon(Icons.phone),
                      suffixIcon: FlatButton(
                        onPressed: () {
                          _mobileformKey.currentState.save();
                          setState(() {
                            loginAcc = '';
                          });
                        },
                        child: new Image.asset(
                          'images/clear.png',
                          width: 20.0,
                          height: 20.0,
                        ),
                      )
                      //  IconButton(
                      //   icon: Icon(Icons.clear),
                      //   onPressed: () {
                      //     _mobileController.text = "";
                      //   },
                      // ),
                      ),
                  // 校验手机号码
                  validator: validateMibile,
                  onChanged: (v) {
                    _mobileformKey.currentState.save();
                    this.loginAcc = v;
                    setState(() {
                      changeCount = validateMibile(v) == null ? true : false;
                    });
                  },
                  onSaved: (value) {
                    this.loginAcc = value;
                  },
                ),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: '${captcha == null ? "" : captcha}', //判断keyword是否为空
                      // 保持光标在最后
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${captcha}'.length),
                      ),
                    ),
                  ),
                  // controller: _codeController,
                  decoration: InputDecoration(
                    // labelText: "密码",
                    hintText: "请输入验证码",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Container(
                      padding: EdgeInsets.only(top: 10),
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
                    // InkWell(
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 15),
                    //     child: Text('获取验证码'),
                    //   ),
                    //   onTap: _getPhoneCode,
                    // ),
                  ),
                  obscureText: false,
                  autovalidate: autovalidateCode,
                  //验证码
                  validator: (value) {
                    print('校验码:$value');
                    if (value.isEmpty) {
                      return "验证码不能为空";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    this.captcha = value;
                  },
                  onChanged: (value) {},
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Application.router
                          .navigateTo(context, "/modifyPasswordByCode");
                    },
                    child: Text(
                      '忘记密码',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color(0xFF649FEA)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            // width:200.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    //自定义按钮颜色
                    // color: Colors.blue,
                    color: Theme.of(context).primaryColor,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.blue,
                    child: Text("登录"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: _phoneAction,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 验证手机号码
  String validateMibile(value) {
    errorMobileText = null;
    LogUtils.debug(TAG, '$value,手机号码验证', StackTrace.current);
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

    if (value.isEmpty) {
      return '手机号码不能为空';
    } else if (!exp.hasMatch(value)) {
      return '请输入正确的手机号码';
    }
  }

  // 获取验证码
  void _getPhoneCode(pWidget) async {
    _mobileformKey.currentState.save();
    autovalidateMobile = true;

    if (loginAcc.isEmpty) {
      setState(() {
        errorMobileText = "手机号码不能为空";
      });
    } else {
      setState(() {
        errorMobileText = null;
      });
    }
    bool flag;
    flag = validateMibile(loginAcc) == null ? true : false;

    if (flag) {
      await requestGet('sendResetPwdCaptcha', formData: {'mobile': loginAcc})
          .then(
        (value) {
          Toast.toast(context, msg: value['message']);
          setState(() {
            isMobilesignin = true;
          });
          LogUtils.debug(TAG, '获取登录验证码$value', StackTrace.current);
          if (value['code'] != 0) {
            pWidget.restTimer();
          }
        },
      );
    }
  }

  // 手机验证码登录
  void _phoneAction() async {
    autovalidateCode = true;
    autovalidateMobile = true;
    _mobileformKey.currentState.save();

    setState(() {
      isMobilesignin = true;
    });

    if ((_mobileformKey.currentState as FormState).validate()) {
      var data = {'loginAcc': loginAcc, 'captcha': captcha};
      await request('login', formData: data).then((val) {
        if (val['code'] == 0) {
          var tgt = {
            "tgt": val['result'],
            "serviceUrl": "https://www.baidu.com",
            "setExpirationSeconds": "518400"
          };
          request('getToken', formData: tgt).then((value) {
            // var data = json.decode(value.toString());
            if (value['code'] == 0) {
              setState(() {
                prefs.setString('token', value['result']['token']);
                prefs.setString('userId', value['result']['userId']);
              });
              _checkAuditStatus();
            } else {
              Toast.toast(
                context,
                msg: value['message'],
              );
              // print('手机登录不成');
            }
          });
        } else {
          Toast.toast(
            context,
            msg: val['message'],
          );
        }
      });
    } else {}
  }

  _checkAuditStatus() async {
    await requestGet('checkAuditStatus').then((val) {
      print('---查看跳转页面------------->${val['result']['auditStatus']}');
      // TODO :当审核还没有通过的时候一直停留在当前页面
      if (val['code'] == 0) {
        prefs.setInt('auditStatusStatus', val['result']['auditStatus']);
        if (val['result']['auditStatus'] == 0) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/indexPage");
        } else if (val['result']['auditStatus'] == 2 ||
            val['result']['auditStatus'] == 3) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/authentication");
        } else if (val['result']['auditStatus'] == 1) {
          Application.router
              .navigateTo(context, "/certificateInfo", replace: true);
        }
      } else {
        Toast.toast(
          context,
          msg: val['message'],
        );
      }
    });
  }
}
