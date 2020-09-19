import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../routers/application.dart';
import '../../../provide/demand_detail_provide.dart';
import '../../../service/service_method.dart';
import '../../index_page.dart';
// import './round_checkbox.dart';
// import '../../routers/application.dart';

class AddQuoteBottom extends StatelessWidget {
  var speciesNumber; //几种
  var totalNumber; //共几件
  var totalAmount;
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var goodsInfo = Provide.value<DemandDetailProvide>(context).offerPageData;
      totalAmount = 0;
      totalNumber = 0;
      goodsInfo.forEach((ele) {
        ele['demandDetailDtoList'].forEach((item) {
          totalNumber += item.num;
          if (item.goodsPrice != 'null' && item.goodsPrice != '') {
            totalAmount += double.parse(item.goodsPrice) * item.num;
          }
        });
      });
      return Container(
        // margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        width: ScreenUtil().setWidth(750),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: '总计:',
                            style: TextStyle(
                              color: Color(0xFFA9A8AB),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '￥${totalAmount}',
                                style: TextStyle(
                                  color: Color(0xFFF8980B),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${Provide.value<DemandDetailProvide>(context).speciesNumber}种${totalNumber}件',
                        style: TextStyle(color: Color(0xFFA9A8AB)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              //自定义按钮颜色
              color: Color(0xFF2A83FF),
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.blue,
              child: Text("提交报价"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                print('点击提交报价$goodsInfo');
                List createQuotationDetailDtos = new List<Object>();

                goodsInfo.forEach((ele) {
                  ele['demandDetailDtoList'].forEach((subele) {
                    print('循环遍历查看skuiid是否获取${subele.specificaId}');
                    var Obj = {
                      "amount": subele.goodsPrice,
                      "demandDetailId": subele.id,
                      "num": subele.num,
                      "skuId": subele.specificaId
                    };
                    return createQuotationDetailDtos.add(Obj);
                  });
                });

                var formData = {
                  "createQuotationDetailDtos": createQuotationDetailDtos,
                  "demandId": Provide.value<DemandDetailProvide>(context)
                      .goodsList
                      .result
                      .id,
                  "remark": Provide.value<DemandDetailProvide>(context).remark,
                  "subjectMgrInfoId": "0711547302f842e29f26f5658e72366b",
                  "totalAmount": totalAmount
                };
                print('提交报价参数$formData');
                request('createDemandQuotation', formData: formData)
                    .then((val) {
                  if (val['code'] == 0) {
                    Fluttertoast.showToast(
                      msg: '提交成功',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return IndexPage();
                    }));
                    // Application.router
                    //     .navigateTo(context, "/choice?id=$demandId");
                  } else {
                    Fluttertoast.showToast(
                      msg: val['message'],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                });
              },
            ),
          ],
        ),
      );
    });
  }
}
