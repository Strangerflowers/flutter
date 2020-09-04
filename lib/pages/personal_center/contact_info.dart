import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/model/base/BaseResponseModel.dart';
import 'package:bid/model/base/BaseResponseResultList.dart';
import 'package:bid/model/base/DataModel.dart';
import 'package:bid/model/base/ListModel.dart';
import 'package:bid/model/user_center/ContactInfoModel.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  List<DataModel> _dataModelList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: request('getContactInfo', formData: {}),
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
        '联系信息',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
            child: Text(
              "添加退货地址",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              print('pressed');
            })
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
        BaseResponseModel<BaseResponseResultList> baseResponseModel =
            BaseResponseModel.fromJson(
                data, (json) => BaseResponseResultList.fromJson(json));
        LogUtils.d('============>[baseResponseModel]', baseResponseModel);
        List<ContactInfoModel> contactInfoModelList = ListModel.collectToList(
            baseResponseModel.result.list,
            (json) => ContactInfoModel.fromJson(json));
        LogUtils.d('[contactInfoModelList]', contactInfoModelList);
        //请求成功，通过项目信息构建用于显示项目名称的ListView
        return _buildBody(contactInfoModelList);
      }
    }
    //请求未完成时弹出loading
    return SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(strokeWidth: 2.0));
  }

  /** 
   * 构建页面内容
   */
  Widget _buildBody(List<ContactInfoModel> contactInfoModelList) {
    List<Widget> itemList = [];
    contactInfoModelList.forEach((e) => itemList.add(_buildRow(e)));
    return ListView(
      children: itemList,
    );
  }

  Widget _buildRow(ContactInfoModel contactInfoModel) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: _buildTitleRow(contactInfoModel),
              subtitle: _buildSubTitlRow(contactInfoModel),
            )
          ],
        ),
      ),
    );
  }

  List<DataModel> _initDataModelList(ContactInfoModel contactInfoModel) {
    _dataModelList = [
      DataModel(
          code: 'mobile',
          label: '联系人电话',
          value: StringUtils.defaultIfEmpty(contactInfoModel.mobile, '')),
      DataModel(
          code: 'address',
          label: '地址',
          value: StringUtils.defaultIfEmpty(contactInfoModel.address, '')),
      DataModel(
          code: 'email',
          label: '邮箱',
          value: StringUtils.defaultIfEmpty(contactInfoModel.email, '')),
      DataModel(
          code: 'fax',
          label: '传真',
          value: StringUtils.defaultIfEmpty(contactInfoModel.fax, '')),
    ];
    return _dataModelList;
  }

  Widget _buildTitleRow(ContactInfoModel contactInfoModel) {
    return new Container(
      child: new Row(children: [
        Expanded(
          child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
            child: Text(
              StringUtils.defaultIfEmpty(contactInfoModel.contactName, ''),
              style: new TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: new Image.asset(
                'images/edit.png',
                width: 20.0,
                height: 20.0,
              ),
              onTap: () {
                LogUtils.d('[编辑按钮]', '被点击了!');
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildSubTitlRow(ContactInfoModel contactInfoModel) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(children: [
              Row(children: [
                Text('电话'),
                Text('   '),
                Text(StringUtils.defaultIfEmpty(contactInfoModel.mobile, ''))
              ]),
              Row(children: [
                Container(alignment: Alignment.topCenter, child: Text('地址')),
                Text('   '),
                Container(
                  alignment: Alignment.center,
                  // decoration: new BoxDecoration(
                  //     border:
                  //         new Border.all(color: Color(0xFFFF0000), width: 0.5),
                  //     color: Color(0xFF9E9E9E),
                  //     borderRadius: new BorderRadius.circular((20.0))),
                  child: Text(StringUtils.preprocessText(
                      StringUtils.defaultIfEmpty(
                              contactInfoModel.areaCode, '') +
                          StringUtils.defaultIfEmpty(
                              contactInfoModel.address, ''),
                      15)),
                )
              ]),
              Row(children: [
                Text('邮箱'),
                Text('   '),
                Text(StringUtils.defaultIfEmpty(contactInfoModel.email, ''))
              ]),
              Row(children: [
                Text('传真'),
                Text('   '),
                Text(StringUtils.defaultIfEmpty(contactInfoModel.fax, ''))
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
