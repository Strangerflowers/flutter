import 'package:flutter/material.dart';
import '../offer/select_products/select_products_body.dart';
import './select_products/select_products_bottom.dart';
import '../../routers/application.dart';

class SelectProductsPage extends StatelessWidget {
  final String id;
  SelectProductsPage(this.id);
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
        title: Text('选择产品'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          child: Text('请选择报价产品:'),
                          onTap: () {
                            Application.router
                                .navigateTo(context, "/addproduct?id='1'");
                          },
                        ),
                      ),
                      SelectProductsBody(),
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
            child: SelectProductsBottom(),
          )
        ],
      ),
    );
  }
}
