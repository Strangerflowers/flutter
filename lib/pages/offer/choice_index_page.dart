import 'package:flutter/material.dart';
import './checkbox.dart';
import './choice_bottom.dart';
import '../../routers/application.dart';
// 本地存储
import 'package:shared_preferences/shared_preferences.dart';

class ChoiceIndex extends StatelessWidget {
  final String id;
  ChoiceIndex(this.id);
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('报价'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 80),
                    constraints: BoxConstraints(
                      // minWidth: 180,
                      minHeight: MediaQuery.of(context).size.height - 126,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 20),
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: Text('请选择你要报价的商品:'),
                                onTap: () {
                                  // Application.router.navigateTo(
                                  //     context, "/addproduct?id='1'");
                                },
                              ),
                            ),
                            SwitchAndCheckBoxTestRoute(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: ChoiceBottom(),
                )
              ],
            );
          } else {
            return Text('加载中......');
          }
        },
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    // await Provide.value<SalesOrderDetailProvide>(context)
    //     .getQuotationDetail(goodsId);
    return '加载完成';
  }
}
