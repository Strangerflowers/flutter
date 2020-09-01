import 'package:flutter/material.dart';
import './round_checkbox.dart';

class SwitchAndCheckBoxTestRoute extends StatefulWidget {
  @override
  _SwitchAndCheckBoxTestRouteState createState() =>
      new _SwitchAndCheckBoxTestRouteState();
}

class _SwitchAndCheckBoxTestRouteState
    extends State<SwitchAndCheckBoxTestRoute> {
  var flag = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            _checkboxTitleListView(),
            // _checkboxItem(),
          ],
        ),
      ),
    );
  }

  //一级需求信息变量渲染
  Widget _checkboxTitleListView() {
    List item = ['123', '4353'];
    if (item != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _checkboxItem();
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

  //二级需求信息变量渲染
  Widget _checkboxContentListView() {
    List item = ['123', '4353'];
    if (item != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _checkboxContent();
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

  Widget _checkboxItem() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _checkboxTitle(),
          _checkboxContentListView(),
        ],
      ),
    );
  }

  Widget _checkboxTitle() {
    return Container(
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
            value: flag,
            onChanged: (selectedList) {
              print('点击单元框');
              setState(() {
                this.flag = !this.flag;
              });
            },
          ),
          // Checkbox(
          //   value: this.flag,
          //   onChanged: (value) {
          //     setState(() {
          //       this.flag = value;
          //     });
          //   },
          //   activeColor: Colors.blue,
          //   checkColor: Colors.white,
          // ),
          Expanded(
            child: Container(
              child: Text('电子产品-耳机-蓝牙耳机'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkboxContent() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // RoundCheckBox(),
          RoundCheckBox(
            value: flag,
            onChanged: (selectedList) {
              print('点击单元框');
              setState(() {
                this.flag = !this.flag;
              });
            },
          ),
          // Checkbox(
          //   value: this.flag,
          //   onChanged: (value) {
          //     setState(() {
          //       this.flag = value;
          //     });
          //   },
          //   activeColor: Colors.blue,
          //   checkColor: Colors.white,
          // ),
          Expanded(
            child: Container(
              child: Text('电子产品-耳机-蓝牙耳机'),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              '数量120个',
              style: TextStyle(color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }
}
