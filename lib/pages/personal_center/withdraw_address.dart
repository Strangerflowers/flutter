import 'package:bid/common/log_utils.dart';
import 'package:bid/models/base/BaseRequestModel.dart';
import 'package:bid/models/base/BaseResponseModel.dart';
import 'package:bid/models/base/BaseResponseResultList.dart';
import 'package:bid/models/base/ListModel.dart';
import 'package:bid/models/user_center/WithdrawAddressModel.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class WithdrawAddress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WithdrawAddress();
  }
}

class _WithdrawAddress extends State<WithdrawAddress> {
  List<WithdrawAddressModel> _itemList = [
    WithdrawAddressModel(receiverName: "##loading##")
  ];
  int _totalPage = 0;
  int _pageNo = 0;

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildItemList(),
      // body: FutureBuilder(
      //   future: request('getWithdrawAddress', formData: {}),
      //   builder: _asyncBuilder,
      // ),
    );
  }

  /** 
   * 延迟构建页面
   */
  Widget _asyncBuilder(BuildContext context, AsyncSnapshot snapshot) {
    //请求完成
    if (snapshot.connectionState == ConnectionState.done) {
      LogUtils.d('snapshot', snapshot);
      LogUtils.d('snapshot.data', snapshot.data);
      //发生错误
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      var data = snapshot.data;
      LogUtils.d('[获取退货地址数据]', data);
      BaseResponseModel<BaseResponseResultList> baseResponseModel =
          BaseResponseModel.fromJson(
              data, (json) => BaseResponseResultList.fromJson(json));
      LogUtils.d('============>[baseResponseModel]', baseResponseModel);
      if (baseResponseModel.code == 0) {
        List<WithdrawAddressModel> withdrawAddressModelList =
            ListModel.collectToList(baseResponseModel.result.list,
                (json) => WithdrawAddressModel.fromJson(json));
        LogUtils.d('\r\n=============>[withdrawAddressModelList]',
            withdrawAddressModelList);
        withdrawAddressModelList.forEach((element) => _itemList.add(element));
      }
      //请求成功，通过项目信息构建用于显示项目名称的ListView
      return _buildItemList();
    }
    //请求未完成时弹出loading
    return CircularProgressIndicator();
  }

  /**
   * 构建导航栏
   */
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '退货地址',
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
            onPressed: _addRecieveAddr)
      ],
    );
  }

  /** 
   * 添加退货地址
   */
  void _addRecieveAddr() {
    LogUtils.d('[添加退货地址]', '被点击!');
    Application.router.navigateTo(context, Routes.ADD_WITHDRAW_ADDRESS_PAGE);
  }

  /** 
   * 构建列表项行数据
   */
  Widget _buildRow(WithdrawAddressModel item) {
    LogUtils.d('[构建列表项行数据]', item);
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        children: [
          // 将Column（列）放入Expanded中会拉伸该列以使用该行中的所有剩余空闲空间。
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //         bottom:
                  //             BorderSide(width: 1, color: Color(0xffe5e5e5)))),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    sprintf('%s  %s', [item.receiverName, item.mobile]),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                new Text(
                  item.address,
                  style: new TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.zero,
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              alignment: Alignment.centerRight,
              child: InkWell(
                child: new Image.asset(
                  'images/edit.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {
                  LogUtils.d('[编辑按钮]', '被点击了!');
                  Application.router.navigateTo(context,
                      Routes.EDIT_WITHDRAW_ADDRESS_PAGE + '?id=${item.id}');
                  // Application.router.navigateTo(
                  //     context,
                  //     sprintf("%s?id=%s",
                  //         [Routes.EDIT_WITHDRAW_ADDRESS_PAGE, item.id]));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  /** 
   * 构建列表项
   */
  Widget _buildItemList() {
    return new ListView.separated(
        separatorBuilder: (context, index) => Divider(height: .0),
        padding: const EdgeInsets.all(16.0),
        // 列表项的数量，如果为null，则为无限列表。
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          LogUtils.d('[构建列表项]', sprintf('i:%s', [index]));
          // 如果是建议列表中最后一个列表项
          if (index >= (_itemList.length - 1)) {
            if (_pageNo <= _totalPage) {
              LogUtils.d('[构建列表项]', '重新发起请求!');
              _retrieveData();
              //加载时显示loading
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "没有更多了",
                    style: TextStyle(color: Colors.grey),
                  ));
            }
          }
          return _buildRow(_itemList[index]);
        });
  }

  void _retrieveData() {
    _pageNo++;
    LogUtils.d('[分页查询]',
        sprintf('当前页:%s 每页显示数:%s', [_pageNo, BaseRequestModel.DEFAULT_LIMIT]));
    request('getWithdrawAddress',
            formData: BaseRequestModel(
                page: _pageNo, limit: BaseRequestModel.DEFAULT_LIMIT))
        .then((data) {
      setState(() {
        BaseResponseModel baseResponseModel =
            BaseResponseModel<BaseResponseResultList>.fromJson(
                data, (json) => BaseResponseResultList.fromJson(json));
        if (baseResponseModel.code == 0) {
          BaseResponseResultList result = baseResponseModel.result;
          _totalPage = result.totalPage;
          List<WithdrawAddressModel> withdrawAddressModelList =
              ListModel.collectToList(
                  result.list, (json) => WithdrawAddressModel.fromJson(json));
          LogUtils.d('\r\n[_retrieveData]', withdrawAddressModelList);
          //重新构建列表
          _itemList.insertAll(_itemList.length - 1, withdrawAddressModelList);
          LogUtils.d('_itemList', _itemList);
        }
      });
    });
  }
}
