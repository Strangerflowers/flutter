import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './authentication.dart';

class SetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "设置密码",
        ),
      ),
      body: SingleChildScrollView(
        child: PasswordForm(),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
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
              validator: (value) {
                if (value.isEmpty) {
                  return "登录密码不能为空";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _comPasswordController,
              obscureText: true,
              // 输入模式设置为手机号
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: ScreenUtil().setWidth(130),
                  margin: EdgeInsets.only(top: 13.0, right: 5.0),
                  child: Text('确认密码'),
                ),
                hintText: "再次输入登录密码",
              ),
              onSaved: (value) {
                this.newPassword = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "确认不能为空";
                }
                return null;
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

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Authentication();
          // return Register();
        },
      ),
    );
  }
}
