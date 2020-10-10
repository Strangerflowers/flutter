import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import './round_checkbox.dart';
import '../../provide/demand_detail_provide.dart';

/**
 ************************************************ 报价body************************************************
 */
class SwitchAndCheckBoxTestRoute extends StatefulWidget {
  @override
  _SwitchAndCheckBoxTestRouteState createState() =>
      new _SwitchAndCheckBoxTestRouteState();
}

class _SwitchAndCheckBoxTestRouteState
    extends State<SwitchAndCheckBoxTestRoute> {
  // var flag = false;

  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).quotationData;
      return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _checkboxTitleListView(goodsInfo),
            ],
          ),
        ),
      );
    });
  }

  //一级需求信息变量渲染
  Widget _checkboxTitleListView(list) {
    // List item = ['123', '4353'];
    if (list != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _checkboxItem(list[index], index);
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Text('暂无发货数据'),
      );
    }
  }

  //二级需求信息变量渲染
  Widget _checkboxContentListView(subList) {
    if (subList != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: subList.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _checkboxContent(subList[index]);
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

  Widget _checkboxItem(subList, index) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _checkboxTitle(subList, index),
          _checkboxContentListView(subList.demandDetailDtoList),
        ],
      ),
    );
  }

  // 一级单选框
  Widget _checkboxTitle(item, index) {
    var parent = false;
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          RoundCheckBox(
            value: item.checkBoxFlag,
            onChanged: (selectedList) {
              print('点击单元框');
              setState(() {
                item.checkBoxFlag = !item.checkBoxFlag;
              });
              parent = item.checkBoxFlag;
              print('object${item.checkBoxFlag}');
              Provide.value<DemandDetailProvide>(context)
                  .selectParentAll(parent, index);
            },
          ),
          Expanded(
            child: Container(
              child: Text(
                '${item.productCategroyPath}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF242526),
                    fontSize: ScreenUtil().setSp(32)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 子单选框
  Widget _checkboxContent(item) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // RoundCheckBox(),
          RoundCheckBox(
            value: item.checkBoxFlag,
            onChanged: (selectedList) {
              print('点击单元框');
              setState(() {
                item.checkBoxFlag = !item.checkBoxFlag;
              });
              Provide.value<DemandDetailProvide>(context).selectChild();
            },
          ),
          Expanded(
            child: Container(
              child: Text(
                '${item.productDescript}',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF242526),
                    fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              '${item.num}${item.type}',
              style: TextStyle(
                color: Color(0XFF9C9FA2),
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
