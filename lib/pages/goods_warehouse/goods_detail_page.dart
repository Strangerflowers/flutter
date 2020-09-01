import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/goods_detail_provide.dart';
import './detail_page/details_top_area.dart';
import './detail_page/select_specifications.dart';
import './detail_page/detail_describe.dart';

class GoodsDetailsPage extends StatelessWidget {
  final String goodsId;
  GoodsDetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商品详细页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsSelectArea(),
                  DetailsDescribe(),
                ],
              ),
            );
          } else {
            return Text('加载中......');
          }
        },
      ),
      // ======静态页面
      // body: Container(
      //   child: Column(
      //     children: <Widget>[
      //       DetailsTopArea(),
      //       DetailsSelectArea(),
      //     ],
      //   ),
      // ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '加载完成';
  }
}
