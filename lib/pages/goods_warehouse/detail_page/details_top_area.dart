import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../../provide/goods_detail_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Provide<DetailsInfoProvide>(
    //   builder: (context, child, val) {
    //     var goodsInfo =
    //         Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
    //     if (goodsInfo != null) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _goodsImage(),
          _goodsPrice(),
          _goodsName(),
        ],
      ),
    );
    //   } else {
    //     return Container(
    //       child: Text('正在加载...'),
    //     );
    //   }
    // },
    // );
  }

  // 商品图片
  Widget _goodsImage() {
    return Image.asset(
      'images/r.jpg',
      width: ScreenUtil().setWidth(750),
      fit: BoxFit.fill,
    );
  }

  // 商品名称
  Widget _goodsName() {
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        'dsdfsd',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
    );
  }

  // 商品编号
  Widget _goodsPrice() {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        '￥200.00-240.00',
        style: TextStyle(color: Color(0xFFF2A631)),
      ),
    );
  }
}
