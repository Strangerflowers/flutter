import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/models/base/BaseResponseModel.dart';
import 'package:bid/models/user_center/ContactInfoModel.dart';
import 'package:bid/models/vo/ContactInfoVo.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/service/service_method.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as My;
import 'package:bid/common/toast.dart';
import 'package:bid/routers/routers.dart';

class EditContactInfo extends StatefulWidget {
  String id;
  EditContactInfo(this.id);

  @override
  State<StatefulWidget> createState() {
    return _EditContactInfo(id);
  }
}

class _EditContactInfo extends State<EditContactInfo> {
  String id;
  static const String TAG = "EditContactInfo";
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ContactInfoModel contactInfoModel;
  ContactInfoVo contactInfoVo;
  bool loaded = false;

  _EditContactInfo(this.id);

  void _onSubmit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      LogUtils.debug(TAG, contactInfoModel, StackTrace.current);
      //contactInfoModel.defaultContact = 2;
      request('editContactInfo', formData: contactInfoModel).then((res) {
        LogUtils.debug(TAG, res, StackTrace.current);
        Widget content;
        if (null != res && res['code'] == 0) {
          Application.router.navigateTo(context, Routes.CONTACT_INFO_PAGE);
          // Application.router.pop(context);
        } else {
          content = new Text('编辑失败!');
          showDialog(
              context: context,
              builder: (ctx) => new AlertDialog(
                    content: content,
                  ));
        }
      });
    }
  }

  @override
  void initState() {
    _initModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCacheableBody(),
    );
  }

  Widget _buildCacheableBody() {
    if (!loaded) {
      return FutureBuilder(
        future: requestGet('getContactInfoById', formData: {"id": this.id}),
        builder: _asyncBuilder,
      );
    } else {
      return _buildBody();
    }
  }

  /** 
   * 延迟构建页面
   */
  Widget _asyncBuilder(BuildContext context, AsyncSnapshot snapshot) {
    //请求完成
    if (snapshot.connectionState == ConnectionState.done) {
      LogUtils.debug(
          TAG, sprintf('snapshot:%s', [snapshot]), StackTrace.current);
      LogUtils.debug(
          TAG,
          sprintf('snapshot.data:%s', [snapshot.data.toString()]),
          StackTrace.current);
      //发生错误
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }

      var data = snapshot.data;
      if (null != data) {
        BaseResponseModel<ContactInfoModel> baseResponseModel =
            BaseResponseModel.fromJson(
                data, (json) => ContactInfoModel.fromJson(json));
        LogUtils.debug(
            TAG,
            sprintf(
                '============>[baseResponseModel]: %s', [baseResponseModel]),
            StackTrace.current);
        contactInfoModel = baseResponseModel.result;
        contactInfoVo.areaName = contactInfoModel.areaName;
        contactInfoVo.areaCode = contactInfoModel.areaCode;
        if (null != contactInfoModel) {
          loaded = true;
          return _buildBody();
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

  Widget _buildBody() {
    return Center(
      child: Form(
        //表单和GlobalKey绑定
        key: _formKey,
        //垂直布局
        child: Column(
          children: [
            _buildContactPeopleRow(),
            _buildMobileRow(),
            _buildAreaRow(),
            _buildAddrressDetailRow(),
            _buildEmailRow(),
            _buildFaxRow(),
            Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blue,
                child: Text(
                  '保存',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  LogUtils.debug(
                      TAG,
                      '保存按钮:' + contactInfoModel.toJson().toString(),
                      StackTrace.current);
                  _onSubmit();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 构建导航栏
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '编辑联系人',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
          child: Text(
            "删除联系人",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            showDelete(context);
          },
        )
      ],
    );
  }

  void showDelete(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('确认提示'),
            content: Text('确定删除该联系人？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');

                  _delete();
                },
              ),
            ],
          );
        });
  }

  void _delete() {
    var formData = {"id": this.id};
    requestGet('deleteContacts', formData: formData).then((value) {
      if (value['code'] == 0) {
        // Navigator.pop(context);
        Application.router.navigateTo(context, Routes.CONTACT_INFO_PAGE);
      } else {
        Toast.toast(context, msg: value['message']);
      }
    });
  }

  Widget _buildContactPeopleRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      //账号输入框
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller:
                  new TextEditingController(text: contactInfoModel.contactName),
              //合法检测回调
              validator: (value) {
                if (value.isEmpty) {
                  return '联系人不能为空';
                }
                return null;
              },
              //表单数据保存
              onSaved: (value) {
                contactInfoModel.contactName = value;
              },
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: My.ScreenUtil().setWidth(160.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '*',
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: '联系人',
                            style: TextStyle(
                              fontSize: My.ScreenUtil().setSp(32),
                              decoration: TextDecoration.none,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                border: InputBorder.none,
                hintText: '请输入',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      //账号输入框
      child: Row(
        children: [
          Container(
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '电话',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TextFormField(
                controller:
                    new TextEditingController(text: contactInfoModel.mobile),
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '电话不能为空!';
                  }
                  if (!RegexUtil.isMobileExact(value)) {
                    return '电话格式不合法!';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.mobile = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddrressDetailRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '详细地址',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TextFormField(
                controller:
                    new TextEditingController(text: contactInfoModel.address),
                maxLines: 3,
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '详细地址不能为空';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.address = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入',
                ),
                /*  onChanged: (value) {
                                int len = value.toString().length;
                                if (len > 11) {
                                  setState(() {
                                    maxline = 3;
                                  });
                                } else {
                                  setState(() {
                                    maxline = 1;
                                  });
                                }
                              }, */
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '邮箱',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TextFormField(
                controller:
                    new TextEditingController(text: contactInfoModel.email),
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '邮箱不能为空';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.email = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaxRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '传真',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TextFormField(
                controller:
                    new TextEditingController(text: contactInfoModel.fax),
                //合法检测回调
                validator: (value) {
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.fax = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaRow() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '所在地区',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: _showSelect,
              child: StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xFFD7D7D7),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      StringUtils.defaultIfEmpty(
                          contactInfoVo.areaName, StringUtils.EMPTY),
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFFD1D1D1),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapExpanded(Widget toWrap) {
    return Expanded(
      child: toWrap,
    );
  }

  void _showSelect() async {
    LogUtils.debug(TAG, '点击弹窗类型选着框', StackTrace.current);
    Result result = await CityPickers.showCityPicker(
        context: context,
        cancelWidget: Text('取消', style: TextStyle(color: Colors.black54)),
        confirmWidget: Text("确定", style: TextStyle(color: Colors.blue)));
    LogUtils.debug(
        TAG, sprintf('省市区控件选择的结果为: %s', [result]), StackTrace.current);

    setState(() {
      _formKey.currentState.save();
      contactInfoModel.areaCode = result.areaId;
      contactInfoVo.areaName =
          result.provinceName + result.cityName + result.areaName;
      LogUtils.debug(
          TAG,
          sprintf('contactInfoModel:%s', [contactInfoModel.toString()]),
          StackTrace.current);
      LogUtils.debug(
          TAG,
          sprintf('contactInfoVo:%s', [contactInfoVo.toString()]),
          StackTrace.current);
    });
  }

  void _initModel() {
    contactInfoModel = new ContactInfoModel();
    contactInfoVo = new ContactInfoVo();
    contactInfoModel.defaultContact = 2;
  }
}
