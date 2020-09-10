import 'package:bid/service/service_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import './register.dart';
import 'package:bid/common/toast.dart';
import '../../routers/application.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../index_page.dart';

Dio dio = Dio();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '注册页面',
      home: Scaffold(
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
                      Navigator.pop(context); //销毁当前页面
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
                              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
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
                              print("点击了 title 手机验证码登录");
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
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
    return '用户名不能为空';
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
  void initState() {
    // setUserData();
    super.initState();
  }

  setUserData(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('token', val['result']['token']);
      prefs.setString('userId', val['result']['userId']);
    });
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
                ],
              ),
            ),
            // 登录按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
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
        if (val['result']['auditStatus'] == 0) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/indexPage");
        } else {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/authentication");
        }
      } else {
        Toast.toast(
          context,
          msg: val['message'],
        );
      }
    });
  }

  void _choiceAction() {
    if ((_formKey.currentState as FormState).validate()) {
      var data = {
        'loginAcc': _unameController.text.toString(),
        'pwd': _pwdController.text.toString()
      };
      getHttp(data).then((val) async {
        final prefs = await SharedPreferences.getInstance();
        if (val['code'] == 0) {
          getToken(val['result']).then((value) {
            print("返回的TGT===>${value['result']['token']}");
            if (value['code'] == 0) {
              setState(() {
                prefs.setString('token', value['result']['token']);
                prefs.setString('userId', value['result']['userId']);
              });
              print('持久胡========》${prefs.getString('token')}');
              _checkAuditStatus();
              // Application.router.navigateTo(context, "/indexPage");
            } else {
              Toast.toast(
                context,
                msg: value['message'],
              );
              // showDialog(
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     title: Text("${val['message']}"),
              //   ),
              // );
            }
          });
        } else {
          Toast.toast(
            context,
            msg: val['message'],
          );
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text("${val['message']}"),
          //   ),
          // );
        }
      });
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

TextEditingController _mobileController = new TextEditingController();
TextEditingController _codeController = new TextEditingController();
// bool pwdShow = false; //密码是否显示明文
GlobalKey _mobileformKey = new GlobalKey<FormState>();
bool _mobileAutoFocus = true;
bool isMobilesignin = false; //是否已获取验证码

// 验证手机号码
String validateMibile(value) {
  print('$value,手机号码验证');
  // 正则匹配手机号
  RegExp exp = RegExp(
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

  if (value.isEmpty) {
    return '用户名不能为空';
  } else if (!exp.hasMatch(value)) {
    return '请输入正确的账号';
  }
}

// 验证验证码
String validateCode(value) {
  // 正则匹配手机号
  // RegExp exp = RegExp(r'^\s{0}$|^[0-9]{6}$');

  if (value.isEmpty) {
    return '验证码不能为空';
  }
}

class _MobileFormPageState extends State<MobileFormPage> {
  setUserData(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('token', val['result']['token']);
      prefs.setString('userId', val['result']['userId']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _mobileformKey, //设置globalKey，用于后面获取FormState
      autovalidate: true, //开启自动校验
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  // 输入模式设置为手机号
                  keyboardType: TextInputType.phone,
                  controller: _mobileController,
                  decoration: InputDecoration(
                    // labelText: "用户名",
                    hintText: "请输入手机",
                    prefixIcon: Icon(Icons.phone),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _mobileController.text = "";
                      },
                    ),
                  ),
                  // 校验手机号码
                  validator: validateMibile,
                  onChanged: (v) {
                    validateMibile(v);
                  },
                ),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    // labelText: "密码",
                    hintText: "请输入验证码",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text('获取验证码'),
                      ),
                      onTap: _getPhoneCode,
                    ),
                  ),
                  obscureText: false,
                  //验证码
                  validator: validateCode,
                  onChanged: (value) {
                    validateCode(value);
                    // if (isMobilesignin) {
                    //   validateCode(value);
                    // }
                  },
                ),
              ],
            ),
          ),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
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

  // 获取验证码
  void _getPhoneCode() async {
    bool flag;
    flag = validateMibile(_mobileController.text.toString()) == null
        ? true
        : false;

    print('1234567890$flag');
    if (flag) {
      await requestGet('sendResetPwdCaptcha',
          formData: {'mobile': _mobileController.text.toString()}).then(
        (value) {
          setState(() {
            isMobilesignin = true;
          });
          print('获取登录验证码$value');
        },
      );
    } else {
      validateMibile(_mobileController.text.toString());
    }
  }

  // 手机验证码登录
  void _phoneAction() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMobilesignin = true;
    });
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token') ?? '';
    if ((_mobileformKey.currentState as FormState).validate()) {
      var data = {
        'loginAcc': _mobileController.text.toString(),
        'captcha': _codeController.text.toString()
      };
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
      if (val['code'] == 0) {
        if (val['result']['auditStatus'] == 0) {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/indexPage");
        } else {
          Navigator.pop(context);
          Application.router.navigateTo(context, "/authentication");
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
