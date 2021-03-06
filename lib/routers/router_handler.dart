import 'package:bid/pages/index_page.dart';
import 'package:bid/pages/personal_center/add_contact_info.dart';
import 'package:bid/pages/personal_center/add_withdraw_address.dart';
import 'package:bid/pages/personal_center/certification_info.dart';
import 'package:bid/pages/personal_center/contact_info.dart';
import 'package:bid/pages/personal_center/edit_contact_info.dart';
import 'package:bid/pages/personal_center/edit_withdraw_address.dart';
import 'package:bid/pages/personal_center/modify_password.dart';
import 'package:bid/pages/personal_center/modify_passwordbycode.dart';
import 'package:bid/pages/personal_center/withdraw_address.dart';
import 'package:bid/pages/purchasing_demand/purchasing_demand.dart';
import 'package:bid/pages/signup/authentication.dart';
import 'package:bid/pages/signup/signin.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../common/log_utils.dart';
import '../pages/offer/add_quote_product_page.dart';
import '../pages/offer/choice_index_page.dart';
import '../pages/offer/select_products_page.dart';
import '../pages/purchasing_demand/demand_detail.dart';
import '../pages/quotation/procurement_plan.dart';
import '../pages/quotation/quotataion_detail_page.dart';
import '../pages/sales_order/sales_add_shipment.dart';
import '../pages/sales_order/sales_index_page.dart';
import '../pages/sales_order/sales_order_detail_page.dart';
import '../pages/sales_order/shipping_information_add.dart';
import '../pages/sales_order/shipping_information_look.dart';
import '../pages/signup/setregister_password.dart';

// handler 的单个配置
Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String goodsId = params['id'].first;
  print('index>details goodsId is ${goodsId}');
  return QuotationDetailPage(goodsId);
});

// 报价单采购计划
Handler procurementPlanHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id'].first;
  return ProcurementPlan(id);
});

// 需求详情页面
Handler demandDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id'].first;
  return DemandDetails(id);
});

// 销售订单详情页面
Handler salesOrderDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id'].first;
  return SalesOrderDetails(id);
});

// 销售添加发货地址
Handler salesAddShipmentHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('跳转参数获取$params');
  String mainOrderId = params['mainOrderId'].first;
  String id = params['id'].first;
  String len = params['len'].first;
  String returnId = params['returnId'].first;
  return AddShipmentSchedule(id, mainOrderId, len, returnId);
});

// 查詢發貨look信息
Handler saleLookShipmentHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('跳转参数获取$params');
  String id = params['id'].first;
  // String id = params['id'].first;
  // String len = params['len'].first;
  // String returnId = params['returnId'].first;
  return ShippingInformationLook(id);
});

// 查詢發貨look信息
Handler saleAddShipmentHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('跳转参数获取$params');
  String id = params['id'].first;
  String detailId = params['detailId'].first;
  // String len = params['len'].first;
  // String returnId = params['returnId'].first;
  return SaleaUpdate(id, detailId);
});

// 跳转到销售订单列表页面
Handler saleasOrderListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String statusParams = params['status'].first;
  // print('index>details goodsId is ${goodsId}');
  return SalesIndexPage();
});

// AddQuoteProductPage 报价添加产品
Handler addProductHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  // print('添加产品$params');
  String id = params['id'].first;
  // print('index>details goodsId is ${goodsId}');
  return AddQuoteProductPage(id);
});

// 选择产品页面SelectProductsPage
Handler selectProductsPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('添加产品$params');
  String id = params['id'].first;
  String subId = params['subId'].first;
  // print('index>details goodsId is ${goodsId}');
  return SelectProductsPage(id, subId);
});

// ChoiceIndex  需求详情跳转到报价页面
Handler choiceIndexPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  // print('添加产品$params');
  String id = params['id'].first;
  // print('index>details goodsId is ${goodsId}');
  return ChoiceIndex(id);
});

/////////////////////////////个人中心/////////////////////////
// 认证资料
Handler certificateInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[认证资料]', '接收到参数$params');
  //String id = params['id'].first;
  return CertificationInfo();
});

// 联系信息
Handler contactInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[联系信息]', '接收到参数$params');
  //String id = params['id'].first;
  return ContactInfo();
});

// 退货地址
Handler withdrawAddressPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[退货地址]', '接收到参数$params');
  //String id = params['id'].first;
  return WithdrawAddress();
});

// 修改密码
Handler modifyPasswordPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.debug(TAG, '跳转[修改密码]: 接收到参数$params', StackTrace.current);
  //String id = params['id'].first;
  return ModifyPassword();
});
// 注册设置密码
Handler registerSetPasswordHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[修改密码]', '接收到参数$params');
  String mobile = params['mobile'].first;
  String companyName = params['companyName'].first;
  String companyShort = params['companyShort'].first;
  return SetPassword(mobile, companyName, companyShort);
});

// 登录页面
Handler siginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FormTestRoute();
});

//登录成功之后跳转到首页
Handler homePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return IndexPage();
});

//资料认证
Handler authenticationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Authentication();
});
// 修改密码
Handler editContactInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[编辑联系信息]', '接收到参数$params');
  String id = params['id'].first;
  return EditContactInfo(id);
});

// 添加联系信息
Handler addContactInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[添加联系信息]]', '接收到参数$params');
  //String id = params['id'].first;
  return AddContactInfo();
});

// 修改退货地址
Handler editWithdrawAddressPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[编辑退货地址]', '接收到参数$params');
  String id = params['id'].first;
  return EditWithdrawAddress(id);
});

// 添加退货地址
Handler addWithdrawAddressPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.d('跳转[添加退货地址]]', '接收到参数$params');
  //String id = params['id'].first;
  return AddWithdrawAddress();
});

// 通过验证码修改密码
Handler modifyPasswordByCodePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  LogUtils.debug(TAG, '跳转[修改密码]]:接收到参数$params', StackTrace.current);
  //String id = params['id'].first;
  return ModifyPasswordByCode();
});

// 需求列表首页
Handler demandListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  // LogUtils.debug(TAG, '跳转[修改密码]]:接收到参数$params', StackTrace.current);
  //String id = params['id'].first;
  return IndexPage();
});
