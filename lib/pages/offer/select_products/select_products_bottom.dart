import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../round_checkbox.dart';
import '../../../routers/application.dart';

class SelectProductsBottom extends StatelessWidget {
  var flag = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          // Container(
          //   child: Row(
          //     children: <Widget>[
          //       RoundCheckBox(
          //         value: flag,
          //         onChanged: (value) {
          //           print('点击单元框');
          //         },
          //       ),
          //       Text('全选')
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Container(
          //     padding: EdgeInsets.only(right: 20),
          //     alignment: Alignment.centerRight,
          //     child: Text(
          //       '已选1种12件',
          //       style: TextStyle(
          //         color: Colors.black26,
          //       ),
          //     ),
          //   ),
          // ),
          FlatButton(
            //自定义按钮颜色
            color: Color(0xFF2A83FF),
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.blue,
            child: Text("确定"),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              print('点击下一步跳转到添加产品页面');
              Application.router.navigateTo(context, "/addproduct?id=1");
              // addproduct
              // applyBoxFit(fit, inputSize, outputSize)
            },
          ),
        ],
      ),
    );
  }
}
