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
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    RoundCheckBox(
                      value: Provide.value<DemandDetailProvide>(context)
                          .selectAllFlag,
                      onChanged: (value) {
                        this.flag = !this.flag;
                        Provide.value<DemandDetailProvide>(context)
                            .selectAll(flag);
                      },
                    ),
                    Text('全选')
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.only(right: 20),
            //     alignment: Alignment.centerRight,
            //     child: Text(
            //       '已选1种12件',
            //       style: TextStyle(
            //         color: Colors.black26,
            //       ),
            //     ),
            //   ),
            // ),
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
                var quotationData = Provide.value<DemandDetailProvide>(context)
                    .goodsList
                    .result
                    .demandSkuDtoList;
                var arr = [];
                quotationData.forEach((ele) {
                  var obj = {
                    "productCategroyId": ele.productCategroyId,
                    "productCategroyPath": ele.productCategroyPath,
                    "checkBoxFlag": ele.checkBoxFlag,
                    "demandDetailDtoList": null,
                  };
                  var brr = [];
                  // if (ele.checkBoxFlag == true) {
                  if (ele.demandDetailDtoList != null) {
                    ele.demandDetailDtoList.forEach((sub) {
                      if (sub.checkBoxFlag == true) {
                        brr.add(sub);
                      }
                    });
                    if (brr.length > 0) {
                      obj['demandDetailDtoList'] = brr;
                    }
                    if (obj['demandDetailDtoList'] != null) {
                      arr.add(obj);
                    }
                  }
                  return arr;
                  // }
                });
                // print('最后合并$arr');
                Provide.value<DemandDetailProvide>(context)
                    .changeorderPageData(arr);
                if (arr.length <= 0) {
                  return;
                }
                Application.router.navigateTo(context, "/addproduct?id=1");
                // 点击下一步的时候清空当前页面的勾选
                Provide.value<DemandDetailProvide>(context).cleanCheck();
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
