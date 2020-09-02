import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './round_checkbox.dart';
import '../../routers/application.dart';
import 'package:provide/provide.dart';
import '../../provide/demand_detail_provide.dart';

class ChoiceBottom extends StatelessWidget {
  var flag = false;
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).goodsList;
      return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        color: Colors.white,
        width: ScreenUtil().setWidth(750),
        child: Row(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  RoundCheckBox(
                    value: flag,
                    onChanged: (value) {
                      print('点击单元框');
                    },
                  ),
                  Text('全选')
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: Text(
                  '已选1种12件',
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
            FlatButton(
              //自定义按钮颜色
              color: Color(0xFF2A83FF),
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.blue,
              child: Text("下一步"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                var res = Provide.value<DemandDetailProvide>(context)
                    .goodsList
                    .result
                    .demandSkuDtoList;
                var arr = [];
                res.forEach((ele) {
                  var obj = {
                    "productCategroyId": ele.productCategroyId,
                    "productCategroyPath": ele.productCategroyPath,
                    "checkBoxFlag": ele.checkBoxFlag,
                    "demandDetailDtoList": [],
                  };

                  if (ele.checkBoxFlag==true) {
                    return arr.add(obj);
                  }
                  if (ele.demandDetailDtoList != null) {
                    var brr = [];
                    ele.demandDetailDtoList.forEach((sub) {
                      if (sub.checkBoxFlag) {
                        return brr.add(sub);
                      }
                    });
                    obj['demandDetailDtoList'] = brr;
                  }

                  return arr.add(obj);
                });

                // print(
                //     '9999999${Provide.value<DemandDetailProvide>(context).goodsList.result.demandSkuDtoList[0].checkBoxFlag}');
                print('点击下一步跳转到添加产品页面$arr');
                return;
                Application.router.navigateTo(context, "/addproduct?id=1");
                // addproduct
                // applyBoxFit(fit, inputSize, outputSize)
              },
            ),
          ],
        ),
      );
    });
  }
}
