import 'dart:collection';

import 'package:bid/common/log_utils.dart';
import 'package:flutter/material.dart';

class CertificationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
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

  Widget _buildRow(DataModel dataModel) {
    return new Container(
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
  }

  /** 
   * 构建页面内容
   */
  Widget _buildBody() {
    List<DataModel> dataModelList = _initDataModelList();
    List<Widget> itemList = [];
    dataModelList.forEach((dm) => itemList.add(_buildRow(dm)));
    return ListView(
      children: itemList,
    );
  }

  List<DataModel> _initDataModelList() {
    List<DataModel> dataModelList = [
      DataModel(code: 'companyName', label: '公司名称', value: ''),
      DataModel(code: 'companyAlias', label: '公司简称', value: ''),
      DataModel(code: 'supplierNo', label: '供应商编号', value: ''),
      DataModel(code: 'supplierType', label: '供应商类型', value: ''),
      DataModel(code: 'companyAddress', label: '公司地址', value: ''),
      DataModel(code: 'companyTel', label: '公司电话', value: ''),
      DataModel(code: 'businessLicenseNumber', label: '营业执照编号', value: ''),
      DataModel(code: 'businessLicensePic', label: '营业执照', value: ''),
      DataModel(code: 'businessScope', label: '经营范围', value: ''),
      DataModel(code: 'bankOfDeposit', label: '开户银行', value: ''),
      DataModel(code: 'account', label: '账号', value: ''),
      DataModel(code: 'tel', label: '电话', value: ''),
      DataModel(code: 'socialCreditCode', label: '社会信用代码', value: ''),
      DataModel(code: 'contact', label: '联系人', value: ''),
      DataModel(code: 'phoneNo', label: '手机号码', value: ''),
    ];
    // TODO: 请求接口将数据填充进去
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
}
