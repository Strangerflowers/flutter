import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/service_method.dart';
import './setregister_password.dart';

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
  final registerFormKey = GlobalKey<FormState>();
  String username, code, componyName, abbreviation;

  void registerForm() {
    registerFormKey.currentState.save();
    registerFormKey.currentState.validate();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SetPassword();
          // return Register();
        },
      ),
    );
    print("用户名: $username  密码: $code   公司名称$componyName, 公司简称$abbreviation");
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
                    this.componyName = value;
                    print('当前输入的公司名称----$username');
                  },
                  onSaved: (value) {
                    this.componyName = value;
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
                    this.abbreviation = value;
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
                    this.username = value;
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
                      return "用户名不能为空";
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

  //
  // 获取验证码
  void _getPhoneCode() async {
    var data = {'mobile': this.username};
    await requestGet('sendRegCaptcha', formData: data).then((val) {
      print('----------------------$val');
    });
  }
}
