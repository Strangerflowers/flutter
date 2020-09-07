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
                  child: Text('商品描述'),
                ),
                Container(
                  child: Text(goodsInfo.description),
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
