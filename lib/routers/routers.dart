import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static String root = "/";
  static String detailsPage = '/detail';
  static String palnPage = '/plan';
  static String demandDetail = '/demanddetail';
  static String salesOrderDetail = '/salesdetail';
  static String addShipment = '/addshipment';
  static String salesOrderLook = '/look';
  static String salesOrderAdd = '/add'; //填写发货信息
  static String salesOrderList = '/saleslist'; //填写发货信息
  static String addProductPage = '/addproduct'; //报价添加产品
  static String selectproductPage = '/selectproduct'; //报价选择产品
  static String choiceIndexPage = '/choice'; //报价选择产品
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('在这里给一个默认页面（404）或者是跳回首页');
    });

    // 配置路由(到这一步，就可以使用了，但是为了方便使用，我们还要做一件事，建一个静态文件，方便使用，也叫静态化)
    router.define(detailsPage, handler: detailsHandler);
    router.define(palnPage, handler: procurementPlanHandler);
    router.define(demandDetail, handler: demandDetailHandler);
    router.define(salesOrderDetail, handler: salesOrderDetailHandler);
    router.define(addShipment, handler: salesAddShipmentHandler);
    router.define(salesOrderLook, handler: saleLookShipmentHandler);
    router.define(salesOrderAdd, handler: saleAddShipmentHandler);
    router.define(salesOrderList, handler: saleasOrderListHandler);
    router.define(addProductPage, handler: addProductHandler);
    router.define(selectproductPage, handler: selectProductsPageHandler);
    router.define(choiceIndexPage, handler: choiceIndexPageHandler);
  }
}
