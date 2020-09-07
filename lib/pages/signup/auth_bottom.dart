import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthBottom extends StatelessWidget {
  final String auditStatus,
      supplierType,
      companyDetailAddr,
      companyMobile,
      businessLicenseIssuedRegistrationMark,
      businessLicenseIssuedKey,
      businessScope,
      bank,
      account,
      companyTelephone,
      socialCreditCode,
      contactName,
      contactMobile;

  AuthBottom(
      this.auditStatus,
      this.supplierType,
      this.companyDetailAddr,
      this.companyMobile,
      this.businessLicenseIssuedRegistrationMark,
      this.businessLicenseIssuedKey,
      this.businessScope,
      this.bank,
      this.account,
      this.companyTelephone,
      this.socialCreditCode,
      this.contactName,
      this.contactMobile);
  var flag = false;
  @override
  Widget build(BuildContext context) {
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
        child: Text("提交"),
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {
          _dispatchAdd(context);
          // Application.router.navigateTo(context, "/demanddetail?id=1");
        },
      ),
    );
  }

  void _dispatchAdd(context) {
    print('提交的diamond${businessLicenseIssuedRegistrationMark}');
    // 保存供应商数据的接口
    // var goodsInfo =
    //     Provide.value<DemandDetailProvide>(context).goodsList.result;
    // if (goodsInfo.isQuotationMerchant == 1) {
    //   Application.router.navigateTo(context, "/choice?id=$demandId");
    // } else {
    //   Application.router
    //       .navigateTo(context, "/detail?id=${goodsInfo.quotationId}");
    // }
  }
}
