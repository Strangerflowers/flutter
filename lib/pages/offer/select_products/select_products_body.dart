import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../round_checkbox.dart';

class SelectProductsBody extends StatefulWidget {
  @override
  _SelectProductsBodyState createState() => new _SelectProductsBodyState();
}

class _SelectProductsBodyState extends State<SelectProductsBody> {
  var flag = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Text('选择产品页面'),
            _checkboxTitle(),
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
              return _checkboxTitle();
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

  Widget _checkboxTitle() {
    return Container(
      padding: ,
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
          Expanded(
            child: _productItem(),
          ),
        ],
      ),
    );
  }

  Widget _productItem() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: Image.asset('images/icon.png'),
          ),
          Expanded(
            child: _right(),
          ),
          // _right(),
        ],
      ),
    );
  }

  // 产品右边信息描述
  Widget _right() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '2函数返回的开始大幅亏损的方式打发士大夫3456789',
              maxLines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '￥20.00-200',
              style: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
