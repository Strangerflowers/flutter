import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../../provide/goods_detail_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var goodsInfo =
            Provide.value<DetailsInfoProvide>(context).goodsInfo.result;
        print('商品详情页数据$goodsInfo');
        if (goodsInfo != null) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo),
                _goodsPrice(goodsInfo),
                _goodsName(goodsInfo),
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

  // 商品图片
  Widget _goodsImage(goodsResult) {
    return Container(
      height: ScreenUtil().setHeight(300),
      child: Image.network(
        goodsResult.image,
        width: ScreenUtil().setWidth(750),
        fit: BoxFit.fill,
      ),
    );

    // return Image.asset(
    //   'images/r.jpg',
    //   width: ScreenUtil().setWidth(750),
    //   fit: BoxFit.fill,
    // );
  }

  // 商品名称
  Widget _goodsName(goodsResult) {
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        goodsResult.name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(goodsResult) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        '${goodsResult.priceRange}',
        style: TextStyle(color: Color(0xFFF2A631)),
      ),
    );
  }
}
