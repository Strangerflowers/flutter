import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("注册新账号"),
      ),
      body: MyHomeBody(),
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
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormDemo(),
        ],
      ),
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
  String username, password;

  void registerForm() {
    registerFormKey.currentState.save();
    registerFormKey.currentState.validate();

    print("用户名: $username  密码: $password");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.people),
              labelText: "用户名或者手机号",
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
            obscureText: true,
            decoration:
                InputDecoration(icon: Icon(Icons.lock), labelText: "密码"),
            onSaved: (value) {
              this.password = value;
            },
            autovalidate: true,
            validator: (value) {
              if (value.isEmpty) {
                return "密码不能为空";
              }
              return null;
            },
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 44,
            child: RaisedButton(
              color: Colors.lightGreen,
              child: Text(
                "注 册",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                registerForm();
//                print("注册按钮点击事件");
              },
            ),
          )
        ],
      ),
    );
  }
}
