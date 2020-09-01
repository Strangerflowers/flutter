import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import './round_checkbox.dart';
import '../../../routers/application.dart';

class AddQuoteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: <Widget>[
          _dataListView(context),
        ],
      ),
    );
  }

  //循环一级数据
  Widget _dataListView(context) {
    List item = ['123', '4353'];
    if (item != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (context, index) {
              return _merge(context);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无发货数据'),
      );
    }
  }

  // 合并一二级数据
  Widget _merge(context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border(
      //     bottom: BorderSide(width: 1, color: Colors.black12),
      //   ),
      // ),
      // padding: EdgeInsets.only(bottom: 10, top: 10),
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          _firstStage(),
          _datasecondsListView(context),
          // _secondLevel(),
        ],
      ),
    );
  }

  // 一级数据
  Widget _firstStage() {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(IconData(0xe656, fontFamily: 'iconfont'),
              color: Color(0xFF52A0FF), size: 20.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('电子产品-耳机-蓝牙耳机'),
            ),
          ),
        ],
      ),
    );
  }

  //遍历二级数据
  Widget _datasecondsListView(context) {
    List item = ['123', '4353'];
    if (item != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (context, index) {
              return _secondLevel(context);
            },
          ),
        ),
      );
    } else {
      return Container(
        child: Text('暂无发货数据'),
      );
    }
  }

  // 二级数据
  Widget _secondLevel(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text('对应产品：蓝牙无线耳头戴氏'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('需求数量：120个'),
          ),
          _addShipment(context),
          _buttom(),
        ],
      ),
    );
  }

  // 添加发货安排
  Widget _addShipment(context) {
    return InkWell(
      onTap: () {
        // // 跳转到详情页面
        Application.router.navigateTo(context, "/selectproduct?id=1");
        // Application.router.navigateTo(context,
        //     "/addshipment?id=${item.id}&len=$len&mainOrderId=${item.mainOrderId}&returnId=$goodsId");
        // print('点击跳转采购页面');
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //设置四周边框
          border: new Border.all(
            width: 1,
            color: Color(0xFFF6F5F8),
          ),
          color: Color(0xFFF6F5F8),
        ),
        height: ScreenUtil().setHeight(160),
        margin: EdgeInsets.only(top: 20),
        // color: Color(0xFFF6F5F8),
        child: Row(
          children: <Widget>[
            Icon(Icons.add),
            Text('添加报价产品'),
          ],
        ),
      ),
    );
  }

  // 删除按钮
  Widget _buttom() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: OutlineButton(
        //自定义按钮颜色
        color: Color(0xFF666666),
        highlightColor: Colors.blue[700],
        // colorBrightness: Brightness.dark,
        splashColor: Color(0xFF333333),
        child: Text("删除产品"),
        textColor: Color(0xFF333333),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {
          print('点击提交报价');
        },
      ),
    );
  }
}
