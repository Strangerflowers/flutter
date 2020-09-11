import 'package:bid/pages/personal_center/certification_info.dart';
import 'package:bid/pages/personal_center/contact_info.dart';
import 'package:bid/pages/personal_center/modify_password.dart';
import 'package:bid/pages/personal_center/modify_passwordbycode.dart';
import 'package:bid/pages/personal_center/withdraw_address.dart';
import 'package:bid/routers/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:bid/model/base/DataModel.dart';
import 'package:bid/model/user_center/CertificationInfoModel.dart';
import '../../common/constants.dart';
import '../../routers/routers.dart';
import '../../common/log_utils.dart';
import 'package:bid/service/service_method.dart';
import '../signup/signin.dart';

// 快速生成  stlss
class PersonalCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> listTitles = _initPageRouteMap();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('会员中心'),
      //   centerTitle: true, //文字居中
      // ),
      body: FutureBuilder(
          future: requestGet('getCertificationInfo'),
          builder: (context, snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              LogUtils.d('snapshot', snapshot);
              LogUtils.d('snapshot.data', snapshot.data.toString());
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              var data = snapshot.data['result'];

              if (null != data) {
                return ListView(
                  children: <Widget>[
                    _topHeader(data),
                    _actionList(context, listTitles),
                    _logout(context),
                  ],
                );
              } else {
                return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "查无数据!",
                      style: TextStyle(color: Colors.grey),
                    ));
              }
            }
            // }
            //请求未完成时弹出loading
            return SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0));
          }),
    );
  }

  /** 
   * 定义页面及其组件的关系
   * 考虑要做权限控制.
   * 此数据之后将从后台获取.
   */
  List<Map<String, Object>> _initPageRouteMap() {
    return [
      {
        "code": "certificationInfo",
        "name_en_us": "Certification Information",
        "name_zh_cn": "认证资料",
        "url": Routes.CERTIFICATE_INFO_PAGE,
        "widget": new CertificationInfo()
      },
      {
        "code": "contactInfo",
        "name_en_us": "Contact Information",
        "name_zh_cn": "联系信息",
        "url": Routes.CONTACT_INFO_PAGE,
        "widget": new ContactInfo()
      },
      {
        "code": "withdrawAddress",
        "name_en_us": "Certification Information",
        "name_zh_cn": "退货地址",
        "url": Routes.WITHDRAW_ADDRESS_PAGE,
        "widget": new WithdrawAddress()
      },
      {
        "code": "modifyPassword",
        "name_en_us": "Modify Password",
        "name_zh_cn": "修改密码",
        "url": Routes.MODIFY_PASSWORD_BY_CODE_PAGE,
        // "url": Routes.MODIFY_PASSWORD_PAGE,
        "widget": new ModifyPasswordByCode()
      },
    ];
  }

  // 头部区域
  Widget _topHeader(data) {
    return Container(
      width: ScreenUtil().setWidth(750),
      // height: ScreenUtil().setHeight(330),
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: [
          Color(0xFF53AEFE),
          Color(0xFF4097FE),
          Color(0xFF3B91FF),
          Color(0xFF2B85FF)
        ]),
        // boxShadow: [
        //   new BoxShadow(
        //     color: Color(0xFF2B85FF),
        //     blurRadius: 20.0,
        //     spreadRadius: 1.0,
        //   )
        // ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            // ClipOval 圆形头像
            child: ClipOval(
              child: SizedBox(
                height: 80,
                width: 80,
                child: Image.network(
                    'http://blogimages.jspang.com/blogtouxiang1.jpg'),
              ),
            ),
          ),
          _headerRight(data),
        ],
      ),
    );
  }

  Widget _headerRight(data) {
    return Container(
      width: ScreenUtil().setWidth(500),
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            // margin: EdgeInsets.only(top: 10),
            child: Text(
              '${data['companyName']}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              '编号   ${data['companyNum']}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  // 我的订单标题
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.party_mode,
                  size: 30,
                ),
                Text('待付款'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.query_builder,
                  size: 30,
                ),
                Text('待发货'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.card_giftcard,
                  size: 30,
                ),
                Text('待收货'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.content_paste,
                  size: 30,
                ),
                Text('待评价'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 通用ListTile
  Widget _myListTile(BuildContext context, String title, String url) {
    return InkWell(
      onTap: () {
        LogUtils.d('用户中心列表项', sprintf('%s被点击! 路由地址为url:%s', [title, url]));
        Application.router.navigateTo(context, url);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(Icons.blur_circular),
          title: Text(title),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget _actionList(
      BuildContext context, List<Map<String, Object>> listTitles) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: _getItemWidgetList(context, listTitles),
      ),
    );
  }

  Widget _logout(context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: RaisedButton(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        onPressed: () {
          _logOut(context);
        },
        child: Text(
          '登录',
          style: TextStyle(
            color: Color(0xFFD47776),
            fontSize: ScreenUtil().setSp(40),
          ),
        ),
      ),
    );
  }

  void _logOut(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('退出登录提示'),
            content: Text('确定退出登录？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final result = await prefs.clear();
                  if (result) {
                    Navigator.of(context).pop('cancel');
                    Application.router.navigateTo(context, '/sigin');
                  }
                },
              ),
            ],
          );
        });
  }

  /////////////////////////INTERNAL PROCESS FUNCTION //////////////////////
  List<Widget> _getItemWidgetList(
      BuildContext context, List<Map<String, Object>> listTitles) {
    List<Widget> list = [];
    for (Map item in listTitles) {
      list.add(_myListTile(
          context,
          item['name' + Constants.UNDERLINE + Constants.DEFUAL_LANG],
          item['url']));
    }
    return list;
  }
}
