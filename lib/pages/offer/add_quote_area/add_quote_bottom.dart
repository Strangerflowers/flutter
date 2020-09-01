import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import './round_checkbox.dart';
// import '../../routers/application.dart';

class AddQuoteBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: '总计:',
                          style: TextStyle(
                            color: Color(0xFFA9A8AB),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '￥10.0',
                              style: TextStyle(
                                color: Color(0xFFF8980B),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '2种三件',
                      style: TextStyle(color: Color(0xFFA9A8AB)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            //自定义按钮颜色
            color: Color(0xFF2A83FF),
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.blue,
            child: Text("提交报价"),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              print('点击提交报价');
              // Application.router.navigateTo(context, "/addproduct?id=1");
              // addproduct
              // applyBoxFit(fit, inputSize, outputSize)
            },
          ),
        ],
      ),
    );
  }
}
