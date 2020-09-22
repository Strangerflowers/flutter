import 'dart:collection';

import 'package:bid/common/constants.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/models/base/BaseResponseModel.dart';
import 'package:bid/models/base/DataModel.dart';
import 'package:bid/models/user_center/CertificationInfoModel.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';

class CertificationInfo extends StatefulWidget {
  @override
  _CertificationInfoState createState() => _CertificationInfoState();
}

class _CertificationInfoState extends State<CertificationInfo> {
  static String TAG = '_CertificationInfoState';

  var _futureBuilderFuture;
  void initState() {
    _futureBuilderFuture = _gerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: _asyncBuilder,
        ),
      ),
    );
  }

  Future _handleRefresh() async {
    _futureBuilderFuture = await _gerData();
    var auditStatus = _futureBuilderFuture['result']['auditStatus'];
    if (auditStatus == 0) {
      Navigator.pop(context);
      Application.router.navigateTo(context, Routes.INDEX_PAGE);
    } else if (auditStatus == 3) {
      Navigator.pop(context);
      Application.router.navigateTo(context, Routes.AUTHENTICATION);
    }
  }

  // 获取数据
  Future _gerData() async {
    var response = await requestGet('getCertificationInfo');
    return response;
  }

  /**
       * 构建导航栏
       */
  Widget _buildAppBar(context) {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '认证资料',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        // FlatButton(
        //   child: Text(
        //     "更新资料认证",
        //     style: TextStyle(
        //       color: Colors.grey,
        //     ),
        //   ),
        //   onPressed: () {
        //     Application.router.navigateTo(context, "/authentication");
        //   },
        // )
      ],
    );
  }

  /** 
   * 延迟构建页面
   */
  Widget _asyncBuilder(BuildContext context, AsyncSnapshot snapshot) {
    //请求完成
    if (snapshot.connectionState == ConnectionState.done) {
      LogUtils.d('snapshot', snapshot);
      LogUtils.d('snapshot.data', snapshot.data.toString());
      //发生错误
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }

      var data = snapshot.data;
      if (null != data) {
        BaseResponseModel<CertificationInfoModel> baseResponseModel =
            BaseResponseModel.fromJson(
                data, (json) => CertificationInfoModel.fromJson(json));
        LogUtils.d('============>[baseResponseModel]',
            baseResponseModel.result.auditStatus);
        CertificationInfoModel certificationInfoModel =
            baseResponseModel.result;
        if (null != certificationInfoModel) {
          Map<String, dynamic> certInfoModelMap =
              certificationInfoModel.toJson();
          List<DataModel> dataModelList = _initDataModelList();
          certInfoModelMap['companyDetailAddr'] = StringUtils.defaultIfEmpty(
                  certificationInfoModel.companyDistrictName, '') +
              StringUtils.defaultIfEmpty(
                  certificationInfoModel.companyDetailAddr, '');
          LogUtils.debug(
              TAG,
              Constants
                  .CERTIFICATION_ADUIT_STATUS[certInfoModelMap['auditStatus']],
              StackTrace.current);
          dataModelList.forEach((e) {
            if (e.code == 'auditStatus') {
              e.value = Constants
                  .CERTIFICATION_ADUIT_STATUS[certInfoModelMap[e.code]];
            } else {
              e.value = null != certInfoModelMap[e.code]
                  ? StringUtils.valueOf(certInfoModelMap[e.code])
                  : '';
            }
          });
          LogUtils.d('[dataModelList]', dataModelList);
          //请求成功，通过项目信息构建用于显示项目名称的ListView
          return _buildBody(dataModelList);
        } else {
          return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text(
                "查无数据!",
                style: TextStyle(color: Colors.grey),
              ));
        }
      }
    }
    //请求未完成时弹出loading
    return SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(strokeWidth: 2.0));
  }

  Widget _buildRow(DataModel dataModel) {
    // 需要预处理显示文本的字段
    var preprocessMap = {
      "companyDetailAddr": StringUtils.preprocessText,
      "businessScope": StringUtils.preprocessText,
      "supplierTypeName": StringUtils.preprocessText,
    };
    dataModel.value = preprocessMap.containsKey(dataModel.code)
        ? preprocessMap[dataModel.code](dataModel.value, 15)
        : dataModel.value;

    Widget defaultWidget = new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: new Row(children: [
        Container(
            padding: const EdgeInsets.all(16.0), child: Text(dataModel.label)),
        Container(
            padding: const EdgeInsets.all(16.0), child: Text(dataModel.value)),
      ]),
    );

    // 营业执照显示方式
    if (dataModel.code == 'businessLicenseIssuedUrl') {
      defaultWidget = new Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: new Row(children: [
          Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(dataModel.label)),
          Container(
            //color: Colors.yellowAccent,
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(16.0),
            child: dataModel.value == null
                ? Text('')
                : Image.network(
                    dataModel.value,
                    width: 150,
                    height: 150,
                  ),
          ),
        ]),
      );
    }

    // 经营范围
    if (dataModel.code == 'businessScope') {
      defaultWidget = new Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: new Row(children: [
          Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(dataModel.label)),
          Container(
              height: 100,
              //color: Colors.grey,
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                  child: new Text(
                dataModel.value,
                maxLines: 50,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ))),
        ]),
      );
    }

    return defaultWidget;
  }

  /** 
   * 构建页面内容
   */
  Widget _buildBody(List<DataModel> dataModelList) {
    List<Widget> itemList = [];
    dataModelList.forEach((dm) => itemList.add(_buildRow(dm)));
    return ListView(
      children: itemList,
    );
  }

  List<DataModel> _initDataModelList() {
    List<DataModel> dataModelList = [
      DataModel(code: 'companyName', label: '公司名称', value: ''),
      DataModel(code: 'companyShort', label: '公司简称', value: ''),
      DataModel(code: 'companyNum', label: '供应商编号', value: ''),
      DataModel(code: 'supplierTypeName', label: '供应商类型', value: ''),
      DataModel(code: 'auditStatus', label: '资料认证状态', value: ''),
      DataModel(code: 'companyDetailAddr', label: '公司地址', value: ''),
      DataModel(code: 'companyMobile', label: '公司电话', value: ''),
      DataModel(
          code: 'businessLicenseIssuedRegistrationMark',
          label: '营业执照编号',
          value: ''),
      DataModel(code: 'businessLicenseIssuedUrl', label: '营业执照', value: ''),
      DataModel(code: 'businessScope', label: '经营范围', value: ''),
      DataModel(code: 'bank', label: '开户银行', value: ''),
      DataModel(code: 'account', label: '账号', value: ''),
      DataModel(code: 'companyTelephone', label: '电话', value: ''),
      DataModel(code: 'socialCreditCode', label: '社会信用代码', value: ''),
      DataModel(code: 'contactName', label: '联系人', value: ''),
      DataModel(code: 'contactMobile', label: '手机号码', value: ''),
    ];
    return dataModelList;
  }
}
