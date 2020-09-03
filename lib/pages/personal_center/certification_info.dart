import 'dart:collection';

import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/model/base/BaseResponseModel.dart';
import 'package:bid/model/user_center/CertificationInfoModel.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';

class CertificationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      // body: _buildBody(),
      body: FutureBuilder(
        future: requestGet('getCertificationInfo', formData: null),
        builder: _asyncBuilder,
      ),
    );
  }

  /**
       * 构建导航栏
       */
  Widget _buildAppBar() {
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
      actions: <Widget>[],
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
        LogUtils.d('============>[baseResponseModel]', baseResponseModel);
        CertificationInfoModel certificationInfoModel =
            baseResponseModel.result;
        Map<String, dynamic> certInfoModelMap = certificationInfoModel.toJson();
        List<DataModel> dataModelList = _initDataModelList();
        certInfoModelMap['companyDetailAddr'] = StringUtils.defaultIfEmpty(
                certificationInfoModel.companyDistrictName, '') +
            StringUtils.defaultIfEmpty(
                certificationInfoModel.companyDetailAddr, '');
        dataModelList.forEach((e) => e.value =
            null != certInfoModelMap[e.code] ? certInfoModelMap[e.code] : '');
        LogUtils.d('[dataModelList]', dataModelList);
        //请求成功，通过项目信息构建用于显示项目名称的ListView
        return _buildBody(dataModelList);
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
      "companyDetailAddr": _preprocessText,
      "businessScope": _preprocessText
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
            child: Image.network(
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
   * 预处理经营范围的描述内容，每10个字符换一次行
   */
  String _preprocessText(String text, int wordSize) {
    int length = text.length;
    int totalGroup = 0;
    if (length % wordSize == 0) {
      totalGroup = length ~/ wordSize;
    } else {
      totalGroup = length ~/ wordSize + 1;
    }
    String returnNewline = "\r\n";
    String finalText = '';
    for (int group = 0; group < totalGroup; group++) {
      int startIdx = group * wordSize + 1;
      int endIdx = group == totalGroup - 1 ? length - 1 : startIdx + wordSize;
      finalText += text.substring(startIdx, endIdx) + returnNewline;
    }
    return finalText;
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

/** 
 * 数据对象
 */
class DataModel {
  String code;
  String label;
  String value;

  DataModel({this.code, this.label, this.value});

  DataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
