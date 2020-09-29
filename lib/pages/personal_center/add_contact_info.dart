import 'package:bid/common/bean_utils.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/models/user_center/ContactInfoModel.dart';
import 'package:bid/models/vo/ContactInfoVo.dart';
import 'package:bid/routers/application.dart';
import 'package:bid/routers/routers.dart';
import 'package:bid/service/service_method.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as My;

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
  bool autoVadiler = false;
  String addressErroeText = '';

  void _onSubmit() {
    final form = _formKey.currentState;
    setState(() {
      autoVadiler = true;
    });
    if (contactInfoModel.areaCode == null) {
      setState(() {
        addressErroeText = "不能为空";
      });
    }
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
          Application.router
              .navigateTo(context, Routes.CONTACT_INFO_PAGE, replace: true);
          // Application.router.pop(context);/contactInfo
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
        body: SingleChildScrollView(
          child: Center(
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
          ),
        ));
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
      // decoration: BoxDecoration(
      //     border:
      //         Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      //设置上下左右的margin
      margin: EdgeInsets.all(10),
      //账号输入框
      child: Container(
        child: TextFormField(
          autovalidate: autoVadiler,
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
                    style: TextStyle(
                      color: Colors.red,
                    ),
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
            // border: InputBorder.none,
            hintText: '请输入',
          ),
        ),
      ),
    );
  }

  Widget _buildMobileRow() {
    return
        //设置上下左右的margin
        Container(
      padding: EdgeInsets.all(10),
      // height: 30.0,
      decoration: BoxDecoration(
          //border: new Border.all(color: Colors.red),
          ),
      child: TextFormField(
        autovalidate: autoVadiler,
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
          // border: InputBorder.none,
          prefixIcon: Container(
            width: My.ScreenUtil().setWidth(160.0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '电话',
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
          hintText: '请输入',
        ),
      ),
    );
  }

  Widget _buildAddrressDetailRow() {
    return Container(
      padding: EdgeInsets.all(10),
      //decoration: BoxDecoration(),
      child: TextFormField(
        autovalidate: autoVadiler,
        maxLines: 1,
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
          prefixIcon: Container(
            width: My.ScreenUtil().setWidth(160.0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '详细地址',
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
          hintText: '请输入详细地址',
        ),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        autovalidate: autoVadiler,
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
          // border: InputBorder.none,
          prefixIcon: Container(
            width: My.ScreenUtil().setWidth(160.0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '邮箱',
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
          hintText: '请输入邮箱',
        ),
        maxLines: 1, //最大行数
        autocorrect: true, //是否自动更正
        autofocus: false, //是否自动对焦
        // autovalidate: autoValidate,
        textAlign: TextAlign.left, //文本对齐方式
        style: TextStyle(
            // fontSize: 20.0,
            ),
      ),
    );
  }

  Widget _buildFaxRow() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        autovalidate: autoVadiler,
        //合法检测回调
        validator: (value) {
          return null;
        },
        //表单数据保存
        onSaved: (value) {
          contactInfoModel.fax = value;
        },
        decoration: InputDecoration(
          // border: InputBorder.none,
          prefixIcon: Container(
            width: My.ScreenUtil().setWidth(160.0),
            child: Center(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '传真',
                  style: TextStyle(
                    fontSize: My.ScreenUtil().setSp(32),
                    decoration: TextDecoration.none,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
            ),
          ),
          hintText: '请输入',
        ),
        maxLines: 1, //最大行数
        autocorrect: true, //是否自动更正
        autofocus: false, //是否自动对焦
        // autovalidate: autoValidate,
        textAlign: TextAlign.left, //文本对齐方式
        style: TextStyle(
            // fontSize: 20.0,
            ),
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
      child: Column(
        children: [
          Row(
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
                  child:
                      StatefulBuilder(builder: (context, StateSetter setState) {
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
          _showErrorText(),
        ],
      ),
    );
  }

  // 所选地区报错提示
  Widget _showErrorText() {
    var content;
    if (addressErroeText != '') {
      //如果数据不为空，则显示Text
      content = Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: 20),
        child: new Text(
          '数据不为空',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    } else {
      //当数据为空我们需要隐藏这个Text
      //我们又不能返回一个null给当前的Widget Tree
      //只能返回一个长宽为0的widget占位
      content = new Container(height: 0.0, width: 0.0);
    }
    return content;
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
      addressErroeText = "";
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
