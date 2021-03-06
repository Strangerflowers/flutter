import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

enum PopPage {
  popUp, //返回上一页
  popNone, //留在当前页
  popUntil, //返回到第一页
}

class Routes {
  static String root = "/";
  static String detailsPage = '/detail';
  static String palnPage = '/plan';
  static String demandDetail = '/demanddetail';
  static String salesOrderDetail = '/salesdetail';
  static String addShipment = '/addshipment';
  static String salesOrderLook = '/look';
  //填写发货信息
  static String salesOrderAdd = '/add';
  //填写发货信息
  static String salesOrderList = '/saleslist';
  //报价添加产品
  static String addProductPage = '/addproduct';
  //报价选择产品
  static String selectproductPage = '/selectproduct';

  static String choiceIndexPage = '/choice';

  // ################################
  //             用户中心
  // ################################
  // 认证资料
  static const String CERTIFICATE_INFO_PAGE = '/certificateInfo';
  // 联系信息
  static const String CONTACT_INFO_PAGE = '/contactInfo';
  // 新增联系信息
  static const String ADD_CONTATCT_INFO_PAGE = '/addContactInfo';
  // 编辑联系信息
  static const String EDIT_CONTATCT_INFO_PAGE = '/editContactInfo';
  // 退货地址
  static const String WITHDRAW_ADDRESS_PAGE = '/withdrawAddress';
  // 新增退货地址
  static const String ADD_WITHDRAW_ADDRESS_PAGE = '/addWithdrawAddress';
  // 编辑退货地址
  static const String EDIT_WITHDRAW_ADDRESS_PAGE = 'editWithdrawAddress';
  // 修改密码
  static String MODIFY_PASSWORD_PAGE = '/modifyPassword';
  // 通过验证码修改密码
  static String MODIFY_PASSWORD_BY_CODE_PAGE = '/modifyPasswordByCode';
  // 注册设置密码
  static String SET_PASSWORD_PAGE = '/setPassword';
  // 需求详情首页
  static String INDEX_PAGE = '/indexPage';
  // 登录
  static String SIGIN = '/sigin';
  // 需求列表页面
  static String DEMAND_LIST = '/demandList';
  // 资料认证
  static String AUTHENTICATION = '/authentication';
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
    router.define(CERTIFICATE_INFO_PAGE, handler: certificateInfoPageHandler);
    router.define(CONTACT_INFO_PAGE, handler: contactInfoPageHandler);
    router.define(ADD_CONTATCT_INFO_PAGE, handler: addContactInfoPageHandler);
    router.define(EDIT_CONTATCT_INFO_PAGE, handler: editContactInfoPageHandler);
    router.define(WITHDRAW_ADDRESS_PAGE, handler: withdrawAddressPageHandler);
    router.define(ADD_WITHDRAW_ADDRESS_PAGE,
        handler: addWithdrawAddressPageHandler);
    router.define(EDIT_WITHDRAW_ADDRESS_PAGE,
        handler: editWithdrawAddressPageHandler);
    router.define(MODIFY_PASSWORD_PAGE, handler: modifyPasswordPageHandler);
    router.define(SET_PASSWORD_PAGE, handler: registerSetPasswordHandler);
    router.define(SIGIN, handler: siginHandler);
    router.define(INDEX_PAGE, handler: homePageHandler);
    router.define(AUTHENTICATION, handler: authenticationHandler);
    router.define(MODIFY_PASSWORD_BY_CODE_PAGE,
        handler: modifyPasswordByCodePageHandler);
    router.define(DEMAND_LIST, handler: demandListHandler);
  }
}
