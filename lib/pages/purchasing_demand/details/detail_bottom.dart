import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routers/application.dart';
import '../../../service/service_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import '../../../provide/demand_detail_provide.dart';

class DemandDetailBottom extends StatelessWidget {
  final String demandId;
  DemandDetailBottom(this.demandId);
  var flag = false;
  @override
  Widget build(BuildContext context) {
    return Provide<DemandDetailProvide>(builder: (context, child, val) {
      var res = Provide.value<DemandDetailProvide>(context).goodsList;

      if (res != null) {
        var goodsInfo = res.result;
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
            child:
                Text("${goodsInfo.isQuotationMerchant == 1 ? '立即报价' : '查看报价'}"),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              _dispatchAdd(context);
              // Application.router.navigateTo(context, "/demanddetail?id=1");
            },
          ),
        );
      } else {
        return Container(
          child: Text(''),
        );
      }
    });
  }

  void _dispatchAdd(context) {
    var goodsInfo =
        Provide.value<DemandDetailProvide>(context).goodsList.result;
    if (goodsInfo.isQuotationMerchant == 1) {
      Application.router.navigateTo(context, "/choice?id=$demandId");
    } else {
      Application.router
          .navigateTo(context, "/detail?id=${goodsInfo.quotationId}");
    }

    // FormData formData = FormData.fromMap({"demandId": demandId});
    // var formData = {"demandId": demandId, "subjectMgrInfoId": "string"};
    // print('立即报价参数$formData');
    // request('quoteNow', formData: formData).then((val) {
    //   // print('响应数据---$val');
    //   if (val['code'] == 0) {
    //     Fluttertoast.showToast(
    //       msg: '可报价',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //     Application.router.navigateTo(context, "/choice?id=$demandId");
    //   } else {
    //     Fluttertoast.showToast(
    //       msg: val['message'],
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //   }
    //   // goodsList = AddDeliverArrange.fromJson(val);
    //   // print('详情数据$goodsList');
    // });
  }
}
