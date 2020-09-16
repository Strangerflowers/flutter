import 'package:flutter/material.dart';
import '../offer/select_products/select_products_body.dart';
import './select_products/select_products_bottom.dart';
import 'package:provide/provide.dart';
import '../../provide/demand_quotation/demand_quotation_provide.dart';
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
        title: Text('选择产品55'),
      ),
      body: FutureBuilder(
        future: _getBackDetailInfo(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
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
                                  child: Text('请选择报价产品:'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, "/addproduct?id='1'");
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
                    child: SelectProductsBottom(id),
                  )
                ],
              );
            } else {
              return Text('加载中......');
            }
          }
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                value: .7,
              ),
            ),
          );
        },
      ),
    );
  }

  Future _getBackDetailInfo(BuildContext context) async {
    await Provide.value<DemandQuotationProvide>(context)
        .getDemandDetailData(id);
    return '加载完成';
  }
}
