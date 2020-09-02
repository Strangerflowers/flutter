import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/goods_list.dart';
import './provide/quotation_list.dart';
import './provide/quotation_detail.dart';
import './provide/goods_list_provide.dart';
import './provide/quotation_detail_plan_provide.dart';
import './provide/goods_detail_provide.dart';
import './provide/purchasing_list_provide.dart';
import './provide/demand_detail_provide.dart';
import './provide/sales_order_list_provide.dart';
import './provide/sales_order_detail_provide.dart';
import './provide/sales_add_shipment_provide.dart';
import './provide/select/select_specifications_provide.dart';
import './provide/sales_order/look.dart';
import './provide/sales_order/add_infomation_provide.dart';
import './provide/demand_quotation/demand_quotation_provide.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';
import './routers/routers.dart';

void main() {
  var counter = Counter();
  var quotationGoodsListProvide = QuotationGoodsListProvide();
  var quotationDetailProvide = QuotationDetailProvide();
  var goodsWarehose = GoodsWarehose();
  var detailsInfoProvide = DetailsInfoProvide();
  var quotationPlanProvide = QuotationPlanProvide();
  var purchasingListProvide = PurchasingListProvide();
  var demandDetailProvide = DemandDetailProvide();
  var salesOrderListProvide = SalesOrderListProvide();
  var salesOrderDetailProvide = SalesOrderDetailProvide();
  var salesOrderAddProvide = SalesOrderAddProvide();
  var salesOrderLook = SalesOrderLook();
  var salesAddPage = SalesAddPage(); //发货信息
  var selects = Selects(); //选着商品规格
  var demandQuotationProvide = DemandQuotationProvide(); //选着商品规格
  var providers = Providers(); //选择商品页面
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<QuotationDetailProvide>.value(quotationDetailProvide))
    ..provide(Provider<QuotationPlanProvide>.value(quotationPlanProvide))
    ..provide(Provider<GoodsWarehose>.value(goodsWarehose))
    ..provide(Provider<PurchasingListProvide>.value(purchasingListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<DemandDetailProvide>.value(demandDetailProvide))
    ..provide(Provider<SalesOrderListProvide>.value(salesOrderListProvide))
    ..provide(Provider<SalesOrderDetailProvide>.value(salesOrderDetailProvide))
    ..provide(Provider<SalesOrderAddProvide>.value(salesOrderAddProvide))
    ..provide(Provider<SalesOrderLook>.value(salesOrderLook))
    ..provide(Provider<SalesAddPage>.value(salesAddPage))
    ..provide(Provider<Selects>.value(selects))
    ..provide(Provider<DemandQuotationProvide>.value(demandQuotationProvide))
    ..provide(
        Provider<QuotationGoodsListProvide>.value(quotationGoodsListProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router(); //对router进行初始化
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
          locale: Locale('zh'),
          title: '供应商app',
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.blueAccent),
          home: IndexPage()),
    );
  }
}
