import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../../provide/goods_detail_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsDescribe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var goodsInfo =
            Provide.value<DetailsInfoProvide>(context).goodsInfo.result;
        if (goodsInfo != null) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '商品描述',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff242526),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    goodsInfo.description,
                    style: TextStyle(
                      color: Color(0xff242526),
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                )
                // _goodsImage(),
              ],
            ),
          );
        } else {
          return Container(
            child: Text('正在加载...'),
          );
        }
      },
    );
  }
}
