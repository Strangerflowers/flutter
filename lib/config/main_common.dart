import 'package:bid/common/app_global.dart';
import 'package:bid/common/constants.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/network.dart';
import 'package:bid/common/pocket_capture.dart';
import 'package:bid/config/config_reader.dart';
import 'package:bid/config/service_url_holder.dart';
import 'package:bid/pages/index_page.dart';
import 'package:bid/pages/personal_center/certification_info.dart';
import 'package:bid/pages/signup/authentication.dart';
import 'package:bid/pages/signup/signin.dart';
import 'package:bid/provide/app_global/save_profile.dart';
import 'package:bid/provide/app_global/user_info.dart';
import 'package:bid/provide/demand_detail_provide.dart';
import 'package:bid/provide/demand_quotation/demand_quotation_provide.dart';
import 'package:bid/provide/goods_detail_provide.dart';
import 'package:bid/provide/goods_list.dart';
import 'package:bid/provide/goods_list_provide.dart';
import 'package:bid/provide/purchasing_list_provide.dart';
import 'package:bid/provide/quotation_detail.dart';
import 'package:bid/provide/quotation_detail_plan_provide.dart';
import 'package:bid/provide/quotation_list.dart';
import 'package:bid/provide/sales_add_shipment_provide.dart';
import 'package:bid/provide/sales_order/add_infomation_provide.dart';
import 'package:bid/provide/sales_order/look.dart';
import 'package:bid/provide/sales_order_detail_provide.dart';
import 'package:bid/provide/sales_order_list_provide.dart';
import 'package:bid/provide/select/select_specifications_provide.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 公共的启动Main方法.
/// @author: DANTE FUNG
/// @date: 2020-9-9 15:53:14
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const TAG = "mainCommon";
Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  // 加载app_xxx_config.json配置文件
  await ConfigReader.initialize(env);
  // 初始化api接口地址定义
  ServiceUrlHolder.initialize();
  // 初始化获取本地存储的用户TOKEN信息
  await Global.init();
  // 初始化代理配置监听
  Packetcapture.initUniLinks(callBack: (host, port) {
    Network.setHttpProxy(host, port);
  });

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
  var profileChangeNotifier = ProfileChangeNotifier();
  var userModel = UserModel();
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
    ..provide(Provider<ProfileChangeNotifier>.value(profileChangeNotifier))
    ..provide(Provider<UserModel>.value(userModel))
    ..provide(
        Provider<QuotationGoodsListProvide>.value(quotationGoodsListProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharedPreferences _prefs;
    Future checkAuditStatus() async {
      _prefs = await SharedPreferences.getInstance();
      var val = await requestGet('checkAuditStatus');
      if (val['code'] == 0) {
        _prefs.remove("auditStatusStatus");
        _prefs.setInt('auditStatusStatus', val['result']['auditStatus']);
      } else if (val['code'] == 13001010) {
        _prefs.clear();
      }
    }

    checkAuditStatus();
    // // 初始化设计尺寸

    final router = Router(); //对router进行初始化
    Routes.configureRoutes(router);
    Application.router = router;

    return Provide<UserModel>(
      builder: (context, child, counter) {
        // 在这里进行判断，如果有token，就去判断资料认证状态，如果已通过审核则跳转到首页，如果没有通过审核则跳转到资料认证页面，如果没有token 就去到登录页面
        var firstPage;
        LogUtils.debug(
            TAG,
            '供应商状态: ${Constants.CERTIFICATION_ADUIT_STATUS[Global.profile.auditStatus]}',
            StackTrace.current);
        LogUtils.debug(
            TAG, '已认证TOKEN: ${Global.profile.token}', StackTrace.current);
        if (Global.profile.token == null) {
          firstPage = FormTestRoute();
        } else if (Global.profile.token != null &&
                Global.profile.auditStatus == 2 ||
            Global.profile.auditStatus == 3) {
          firstPage = Authentication();
        } else if (Global.profile.token != null &&
            Global.profile.auditStatus != 0) {
          firstPage = CertificationInfo();
        } else {
          firstPage = IndexPage();
        }

        return Container(
          child: MaterialApp(
              navigatorKey: navigatorKey,
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
              routes: {
                '/loginPage': (ctx) => FormTestRoute(),
                // '/homePage': (ctx) => MainPage(),
              },
              home: firstPage),
        );
      },
    );
    // );
  }
}
