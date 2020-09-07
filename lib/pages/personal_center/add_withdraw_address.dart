import 'package:bid/common/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import '../../common/log_utils.dart';

class AddWithdrawAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildModifyPwdTextForm(),
    );
  }

  /**
       * 构建导航栏
       */
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '新增退货地址',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildModifyPwdTextForm() {
    final _labels = new List<String>();
    _labels.add("收件人:");
    _labels.add("手机号码:");
    _labels.add("所在地区:");
    _labels.add("详细地址:");
    List<Widget> list = [];
    for (String label in _labels) {
      list.add(_buildRow(label));
    }
    // 确认按钮
    list.add(_buildSubmitBtn());
    return ListView(
      children: list,
    );
  }

  Widget _buildRow(String label) {
    return new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: new Row(
        children: [
          new Container(
            padding: EdgeInsets.all(15),
            child: new Text(
              label,
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
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                //controller: controller,
                //maxLength: 30, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                maxLines: 1, //最大行数
                autocorrect: true, //是否自动更正
                autofocus: true, //是否自动对焦
                obscureText: true, //是否是密码
                textAlign: TextAlign.left, //文本对齐方式
                style: TextStyle(fontSize: 20.0, color: Colors.blue), //输入文本的样式
                //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                onChanged: (text) {
                  //内容改变的回调
                  LogUtils.d(sprintf('[%s]', [label]), 'change $text');
                },
                onSubmitted: (text) {
                  //内容提交(按回车)的回调
                  LogUtils.d(sprintf('[%s]', [label]), 'submit $text');
                },
                enabled: true, //是否禁用
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              LogUtils.d(sprintf("[%s]", [label]), "被点击了删除按钮!");
            },
            child: new Image.asset(
              'images/clear.png',
              width: 20.0,
              height: 20.0,
            ),
          )
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
              LogUtils.d('[确认修改按钮]', '被点击!');
            },
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(50))),
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(
                '保存',
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )),
      ),
    );
  }
}
