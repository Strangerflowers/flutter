import 'package:flutter/material.dart';
import './checkbox.dart';
import './add_quote_area/add_quote_bottom.dart';
import './add_quote_area/add_quote_body.dart';

class AddQuoteProductPage extends StatelessWidget {
  final String id;
  AddQuoteProductPage(this.id);
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
        title: Text('报价添加产品'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 80),
              constraints: BoxConstraints(
                // minWidth: 180,
                minHeight: MediaQuery.of(context).size.height - 126,
              ),
              child: AddQuoteBody(),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Container(
              //           color: Colors.white,
              //           padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              //           alignment: Alignment.centerLeft,
              //           child: Text('请选择你要报价的商品:'),
              //         ),
              //         SwitchAndCheckBoxTestRoute(),
              //       ],
              //     ),
              //   ],
              // ),
            ),
          ),
          Positioned(
            bottom: -5,
            left: 0,
            right: 0,
            child: AddQuoteBottom(),
          )
        ],
      ),
    );
  }
}
