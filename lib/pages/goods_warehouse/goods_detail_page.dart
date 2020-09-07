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
            return SingleChildScrollView(
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
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    // return Provide.value<DetailsInfoProvide>(context).goodsInfo.result;
    return '加载完成';
  }
}
