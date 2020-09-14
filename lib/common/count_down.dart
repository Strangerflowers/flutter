import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFF00CACE),
);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFFCCCCCC),
);
GlobalKey<_LoginFormCodeState> childKey = GlobalKey();

class LoginFormCode extends StatefulWidget {
  final bool isChange;

  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  /// 用户点击时的回调函数。
  // final Function onTapCallback;
  final ValueChanged onTapCallback;

  LoginFormCode({
    Key key,
    this.isChange,
    this.countdown,
    this.available,
    this.onTapCallback,
  });

  @override
  _LoginFormCodeState createState() => _LoginFormCodeState();
}

class _LoginFormCodeState extends State<LoginFormCode> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  /// 取消倒计时的计时器。
  restTimer() {
    print('父组件调用子组件的方法');
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
    _seconds = widget.countdown;
    inkWellStyle = _availableStyle;
    setState(() {});
    return;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        cancelTimer();
        _seconds = widget.countdown;
        inkWellStyle = _availableStyle;
        setState(() {});
        return;
      }
      _seconds--;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  /// 取消倒计时的计时器。
  void cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available
        ? InkWell(
            child: Text(
              '  $_verifyStr  ',
              style: inkWellStyle,
            ),
            onTap: (_seconds == widget.countdown && widget.isChange == true)
                ? () {
                    print('子组件方法');
                    _startTimer();
                    inkWellStyle = _unavailableStyle;
                    _verifyStr = '已发送$_seconds' + 's';
                    setState(() {});
                    widget.onTapCallback(_verifyStr);
                  }
                : (_seconds == widget.countdown && widget.isChange == false)
                    ? () {
                        widget.onTapCallback(_verifyStr);
                      }
                    : null,
          )
        : InkWell(
            child: Text(
              '  获取验证码  ',
              style: _unavailableStyle,
            ),
          );
  }
}