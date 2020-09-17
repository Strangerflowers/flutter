import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../../provide/demand_quotation/demand_quotation_provide.dart';
import '../round_checkbox.dart';

class SelectProductsBody extends StatefulWidget {
  @override
  _SelectProductsBodyState createState() => new _SelectProductsBodyState();
}

class _SelectProductsBodyState extends State<SelectProductsBody> {
  var flag = false;

  @override
  Widget build(BuildContext context) {
    return Provide<DemandQuotationProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandQuotationProvide>(context).goodsList;
      if (goodsInfo != null) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _checkboxTitleListView(goodsInfo.result.list),
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: Text('暂无数据'),
        );
      }
    });
  }

  //一级需求信息变量渲染
  Widget _checkboxTitleListView(list) {
    if (list != null) {
      return Container(
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(), //禁用滑动事件
            itemBuilder: (contex, index) {
              return _checkboxTitle(list[index], index);
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

  Widget _checkboxTitle(item, index) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
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
              setState(() {
                item.checkBoxFlag = !item.checkBoxFlag;
              });
              if (item.checkBoxFlag == true) {
                Provide.value<DemandQuotationProvide>(context)
                    .changeSelectItem(index);
              }
            },
          ),
          Expanded(
            child: _productItem(item),
          ),
        ],
      ),
    );
  }

  Widget _productItem(item) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(top: 0, right: 10),
            child: Image.asset('images/icon.png'),
          ),
          Expanded(
            child: _right(item),
          ),
          // _right(),
        ],
      ),
    );
  }

  // 产品右边信息描述
  Widget _right(item) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item.name}',
              maxLines: 2,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item.priceRange}',
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
