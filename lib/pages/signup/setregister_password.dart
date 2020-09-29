import 'package:bid/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import './signin.dart';
import './authentication.dart';
import '../../service/service_method.dart';
import '../../routers/application.dart';
import 'dart:convert' as convert;

class SetPassword extends StatelessWidget {
  final String mobile;
  final String companyName;
  final String companyShort;

  SetPassword(this.mobile, this.companyName, this.companyShort);

  @override
  Widget build(BuildContext context) {
    print('设置密码页面$mobile==$companyName===$companyShort');
    // TODO: implement build
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "设置密码",
          ),
        ),
        body: SingleChildScrollView(
          child: PasswordForm(mobile, companyName, companyShort),
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  final String mobile;
  final String companyName;
  final String companyShort;
  PasswordForm(this.mobile, this.companyName, this.companyShort);
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

// 新密码输入框控制器，
TextEditingController _newPasswordController = new TextEditingController();
// 确认密码输入框控制器，
TextEditingController _comPasswordController = new TextEditingController();

// 表单状态
GlobalKey<FormState> _setFormKey = GlobalKey<FormState>();

class _PasswordFormState extends State<PasswordForm> {
  bool disableBtn = false;
  bool autovalidatePwd = false;
  bool btnFlag = false;
  var params;
  void initState() {
    params = {
      "mobile": widget.mobile,
      "companyName": widget.companyName,
      "companyShort": widget.companyShort,
    };
    super.initState();
  }

  String newPassword, comPassword;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      child: Form(
        key: _setFormKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              autovalidate: autovalidatePwd,
              controller: _newPasswordController,
              obscureText: true, //是否是密码形式
              // 输入模式设置为手机号
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(130),
                  margin: EdgeInsets.only(top: 13.0, right: 5.0),
                  child: Text(
                    '登录密码',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ),
                hintText: "不少于8位，含数字大小写字母组合",
              ),
              onSaved: (value) {
                this.newPassword = value;
              },
              validator: validatePwd,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return "登录密码不能为空";
              //   }
              //   return null;
              // },
            ),
            TextFormField(
              autovalidate: autovalidatePwd,
              controller: _comPasswordController,
              obscureText: true,
              // 输入模式设置为手机号
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(130),
                  margin: EdgeInsets.only(top: 13.0, right: 5.0),
                  child: Text(
                    '确认密码',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ),
                hintText: "再次输入登录密码",
              ),
              onSaved: (value) {
                this.comPassword = value;
              },
              onChanged: (value) {
                this.comPassword = value;
              },
              validator: (value) {
                _setFormKey.currentState.save();
                print('确认密码校验$newPassword==$comPassword');
                if (comPassword.isEmpty) {
                  return "确认不能为空";
                } else {
                  if (this.newPassword != this.comPassword) {
                    return "两次密码不一致";
                  } else {
                    return null;
                  }
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 44,
              // padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: FlatButton(
                //自定义按钮颜色
                // color: Colors.blue,
                color: Theme.of(context).primaryColor,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.blue,
                child: Text("确定"),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                onPressed: _register,
              ),
            ),
          ],
        ),
      ),
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

  void _register() async {
    // if (btnFlag == true) {
    //   return;
    // }
    setState(() {
      autovalidatePwd = true;
    });
    _setFormKey.currentState.save();
    _setFormKey.currentState.validate();
    var formData = {
      "companyName": widget.companyName,
      "mobile": widget.mobile,
      "companyShort": widget.companyShort,
      "password": newPassword,
    };
    // setState(() {
    //   btnFlag = true;
    // });
    print('注册信息$formData');
    if ((_setFormKey.currentState as FormState).validate()) {
      if (disableBtn) {
        return;
      }
      disableBtn = true;
      await request('register', formData: formData).then((val) {
        print('----------------------$val');
        if (val['code'] == 0) {
          Toast.toast(context, msg: "注册成功");
          // 延时1s执行返回
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FormTestRoute();
                  // return Register();
                },
              ),
            );
            disableBtn = false;
          });

          // Application.router.navigateTo(context, "/setPassword?item=$item");
        } else {
          disableBtn = false;
          Toast.toast(context, msg: val['message']);
          // setState(() {
          //   btnFlag = false;
          // });
          // Fluttertoast.showToast(
          //   msg: val['message'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
        }
      });
    }
  }
}
