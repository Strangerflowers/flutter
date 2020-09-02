import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../../provide/demand_quotation/demand_quotation_provide.dart';
import '../../../provide/demand_detail_provide.dart';
// import '../round_checkbox.dart';
import '../../../routers/application.dart';

class SelectProductsBottom extends StatelessWidget {
  final String id;
  SelectProductsBottom(this.id);
  var flag = false;
  @override
  Widget build(BuildContext context) {
    return Provide<DemandQuotationProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandQuotationProvide>(context).goodsList;
      return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        color: Colors.white,
        width: ScreenUtil().setWidth(750),
        child: FlatButton(
          //自定义按钮颜色
          color: Color(0xFF2A83FF),
          highlightColor: Colors.blue[700],
          colorBrightness: Brightness.dark,
          splashColor: Colors.blue,
          child: Text("确定"),
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
            var offerPageData =
                Provide.value<DemandDetailProvide>(context).offerPageData;
            print('点击下一步跳转到添加产品页面==$offerPageData');
            var productDatas = goodsInfo.result.list;
            var productData = [];
            productDatas.forEach((ele) {
              if (ele.checkBoxFlag == true) {
                productData.add(ele);
              }
            });
            print('选中的产品$productData');

            offerPageData.forEach((offer) {
              print('99999offer33${offer['demandDetailDtoList'].length}');
              if (offer['demandDetailDtoList'].length > 0) {
                offer['demandDetailDtoList'].forEach((suboffer) {
                  print(
                      '对比${suboffer.productCategroyId.toString() == id}===${suboffer.productCategroyId}===$id');
                  if (suboffer.productCategroyId.toString() == id) {
                    print('8888');
                    suboffer['subjectItem'] = [];
                    print('00000777');
                    suboffer['subjectItem'].add(productData[0]);
                    print('00000');
                  }
                });
              }
            });
            print('整合后的数据${offerPageData[0]['demandDetailDtoList']}');
            return;
            Application.router.navigateTo(context, "/addproduct?id=1");
            // addproduct
            // applyBoxFit(fit, inputSize, outputSize)
          },
        ),
      );
    });
  }
}
