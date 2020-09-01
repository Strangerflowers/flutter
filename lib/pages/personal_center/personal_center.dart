import 'package:bid/pages/personal_center/certification_info.dart';
import 'package:bid/pages/personal_center/contact_info.dart';
import 'package:bid/pages/personal_center/modify_password.dart';
import 'package:bid/pages/personal_center/withdraw_address.dart';
import 'package:bid/routers/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprintf/sprintf.dart';
import '../../common/constants.dart';
import '../../routers/routers.dart';
import '../../common/log_utils.dart';

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
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          // _orderType(),
          _actionList(context, listTitles),
          _logout(),
        ],
      ),
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
        "url": Routes.MODIFY_PASSWORD_PAGE,
        "widget": new ModifyPassword()
      },
    ];
  }

  // 头部区域
  Widget _topHeader() {
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
          _headerRight(),
        ],
      ),
    );
  }

  Widget _headerRight() {
    return Container(
      width: ScreenUtil().setWidth(500),
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            // margin: EdgeInsets.only(top: 10),
            child: Text(
              '俊翔音乐设备有限公司',
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
              '编号 sdffsdf1234734',
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
        LogUtils.d('用户中心列表项', sprintf('%s被点击! 路由地址为url:%s',[title, url]));
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

  Widget _logout() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: RaisedButton(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return FormTestRoute();
          //     },
          //   ),
          // );
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

  /////////////////////////INTERNAL PROCESS FUNCTION //////////////////////
  List<Widget> _getItemWidgetList(
      BuildContext context, List<Map<String, Object>> listTitles) {
    List<Widget> list = [];
    for (Map item in listTitles) {
      list.add(_myListTile(context, item['name'+Constants.UNDERLINE+Constants.DEFUAL_LANG], item['url']));
    }
    return list;
  }
}
