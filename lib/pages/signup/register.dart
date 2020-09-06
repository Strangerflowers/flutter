import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../service/service_method.dart';
import './setregister_password.dart';
import '../../routers/application.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '注册页面',
      home: Scaffold(
        appBar: AppBar(
          title: Text("注册新账号"),
        ),
        body: SingleChildScrollView(
          child: HomeContent(),
        ),
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
  final registerFormKey = GlobalKey<FormState>();
  String mobile, code, companyName, companyShort;

  void registerForm() async {
    registerFormKey.currentState.save();
    registerFormKey.currentState.validate();
    var formData = {
      "mobile": mobile,
      "checkCode": code,
    };
    var item = {
      "mobile": mobile,
      'code': code,
      'companyName': companyName,
      'companyShort': companyShort
    }.toString();

    print('object$formData');
    if ((registerFormKey.currentState as FormState).validate()) {
      await request('verifyRegCheckCode', formData: formData).then((val) {
        print('// 校验验证码$val====${val['code'] == 0}');
        if (val['code'] == 0) {
          print('判断是否跑进校验');
          Application.router.navigateTo(context,
              "/setPassword?mobile=$mobile&companyName=${Uri.encodeComponent(companyName)}&companyShort=${Uri.encodeComponent(companyShort)}");
          // Application.router.navigateTo(context, "/setPassword?item=$item");
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
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(120),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('公司名称'),
                    ),
                    hintText: "请输入公司名称",
                  ),
                  onChanged: (value) {
                    this.companyName = value;
                    print('当前输入的公司名称----$mobile');
                  },
                  onSaved: (value) {
                    this.companyName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "用户名不能为空";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(120),
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
                  autovalidate: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(120),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('账号'),
                    ),
                    hintText: "请输入手机号",
                  ),
                  onSaved: (value) {
                    this.mobile = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "用户名不能为空";
                    }
                    return null;
                  },
                  onChanged: (v) {
                    validateMibile(v);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: ScreenUtil().setWidth(120),
                      margin: EdgeInsets.only(top: 15.0, right: 5.0),
                      child: Text('验证码'),
                    ),
                    suffixIcon: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text('获取验证码'),
                      ),
                      onTap: _getPhoneCode,
                    ),
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
    print('手机校验$value');
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

    if (value.isEmpty) {
      print('手机校验为空');
      return '手机号码不能为空';
    } else if (!exp.hasMatch(value)) {
      print('手机校验规则不对');
      return '请输入正确的账号';
    }
  }

  //
  // 获取验证码
  void _getPhoneCode() async {
    registerFormKey.currentState.save();
    // validateMibile();
    var flag = validateMibile(mobile.toString()) == null ? true : false;
    // registerFormKey.currentState.validate();
    if (flag) {
      var data = {'mobile': this.mobile};
      print('获取验证码注册$data');
      await requestGet('sendRegCaptcha', formData: data).then((val) {
        print('----------------------$val');
      });
    } else {
      validateMibile(mobile.toString());
    }
  }
}
