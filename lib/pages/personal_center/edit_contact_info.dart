import 'package:bid/common/log_utils.dart';
import 'package:bid/model/base/BaseResponseModel.dart';
import 'package:bid/model/user_center/CertificationInfoModel.dart';
import 'package:bid/model/user_center/ContactInfoModel.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

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
        if (null != res) {
          content = res['code'] == 0 ? new Text('编辑成功!') : new Text('编辑失败!');
        } else {
          content = new Text('编辑失败!');
        }

        showDialog(
            context: context,
            builder: (ctx) => new AlertDialog(
                  content: content,
                ));
      });
      // Application.router.navigateTo(context, Routes.CONTACT_INFO_PAGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    contactInfoModel = new ContactInfoModel();
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: requestGet('getContactInfoById', formData: {"id": this.id}),
        builder: _asyncBuilder,
      ),
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
        BaseResponseModel<ContactInfoModel> baseResponseModel =
            BaseResponseModel.fromJson(
                data, (json) => ContactInfoModel.fromJson(json));
        LogUtils.d('============>[baseResponseModel]', baseResponseModel);
        contactInfoModel = baseResponseModel.result;
        if (null != contactInfoModel) {
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
            _wrapExpanded(_buildContactPeopleRow()),
            _wrapExpanded(_buildMobileRow()),
            _wrapExpanded(_buildAreaRow()),
            _wrapExpanded(_buildAddrressDetailRow()),
            _wrapExpanded(_buildEmailRow()),
            _wrapExpanded(_buildFaxRow()),
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

  /**
                 * 构建导航栏
                 */
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
    );
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
              '联系人',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TextFormField(
                controller: new TextEditingController(
                    text: contactInfoModel.contactName),
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '账号不能为空';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.contactName = value;
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
            child: Container(
              child: TextFormField(
                  controller: new TextEditingController(
                      text: contactInfoModel.areaCode),
                  //合法检测回调
                  validator: (value) {
                    if (value.isEmpty) {
                      return '所在地区不能为空';
                    }
                    return null;
                  },
                  //表单数据保存
                  onSaved: (value) {
                    contactInfoModel.areaCode = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入',
                  )),
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
}
