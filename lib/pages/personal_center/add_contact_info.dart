import 'package:bid/common/bean_utils.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/model/user_center/ContactInfoModel.dart';
import 'package:bid/model/vo/ContactInfoVo.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/service/service_method.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class AddContactInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddContactInfo();
  }
}

class _AddContactInfo extends State<AddContactInfo> {
  static const String TAG = "AddContactInfo";
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ContactInfoModel contactInfoModel;
  ContactInfoVo contactInfoVo;

  void _onSubmit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      ContactInfoVo payload = BeanUtils.copyProperties(
          contactInfoModel.toJson(),
          contactInfoVo.toJson(),
          (json) => ContactInfoVo.fromJson(json));
      LogUtils.debug(
          TAG, sprintf('请求payload:%s', [payload]), StackTrace.current);
      request('saveContactInfo', formData: payload).then((res) {
        LogUtils.debug(TAG, sprintf('响应:%s', [res]), StackTrace.current);
        Widget content;
        if (null != res && res['code'] == 0) {
          Application.router.pop(context);
        } else {
          content = new Text('新增失败!');
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
      body: Center(
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
        '添加联系人',
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
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '联系人不能为空';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.contactName = value.trim();
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
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '电话不能为空!';
                  }
                  if (!RegexUtil.isMobileSimple(value.trim())) {
                    return '电话格式不合法!';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.mobile = value.trim();
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
                  contactInfoModel.address = value.trim();
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
                //合法检测回调
                validator: (value) {
                  if (value.isEmpty) {
                    return '邮箱不能为空';
                  }
                  return null;
                },
                //表单数据保存
                onSaved: (value) {
                  contactInfoModel.email = value.trim();
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
          /* Expanded(
            child: Container(
              child: TextFormField(
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
          ), */
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
