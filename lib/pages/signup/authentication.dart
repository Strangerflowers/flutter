// 资料认证页面
import 'package:bid/pages/component/select_component.dart/address.dart';
import 'package:bid/pages/signup/auth_bottom.dart';
import 'package:bid/routers/application.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:xyz_address_picker/xyz_address_picker.dart';
import '../../images.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../service/service_method.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("资料认证"),
      ),
      body: FutureBuilder(
          future: requestGet('checkAuditStatus'),
          builder: (context, snapshot) {
            var data = snapshot.data;
            print('响应数据====>${snapshot.data}');
            if (snapshot.hasData) {
              return Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _headerData(data['result']),
                        AuthenticationForm(data['result']),
                      ],
                    ),
                  ),
                ),
              ]);
            } else {
              return Container(child: Text('暂无数据'));
            }
          }),
    );
  }

  // Future _getInfo(BuildContext context) async {
  //   await requestGet('checkAuditStatus').then((value) {
  //     print('回显数据$value');
  //   });
  // }

  Widget _headerData(result) {
    var asditText = {'0': '审核通过', '1': '待审核', '2': '未提交', '3': '审核不通过'};
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _headerItemRow('资料认证状态', asditText[result['auditStatus'].toString()]),
          _headerItemRow('供养商编号', result['companyNum']),
          _headerItemRow('公司名称', result['companyName']),
          _headerItemRow('公司简称', result['companyShort']),
        ],
      ),
    );
  }

  Widget _headerItemRow(left, right) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      // margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(230),
            child: Text(
              left,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: ScreenUtil().setWidth(500),
              child: Text(
                right == null ? '' : right,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthenticationForm extends StatefulWidget {
  final data;
  AuthenticationForm(this.data);
  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

typedef MyOnChange = Function(int index, String id, String name);

class _AuthenticationFormState extends State<AuthenticationForm> {
  var companyAddressName; //显示公司地区名称
  var auditStatus = 1;
  var supplierType; //供应商类型
  var companyCode; //地区编码
  var companyDetailAddr; //详细地址
  var companyMobile; //公司电话
  var businessLicenseIssuedRegistrationMark; //营业执照编号
  var businessLicenseIssuedKey; //图片key
  var businessScope; //经营范围
  var bank; //银行
  var account; //银行账号
  var companyTelephone; //公司固定电话
  var socialCreditCode; //社会信用代码
  var contactName; //联系人
  var contactMobile; //联系号码
  List res = [];
  String categoryone = '';
  String categorytwo = '';
  String categorythree = '';
  List categoryoneList = [];
  List categorytwoList = [];
  List categorythreeList = [];

  String province = '';
  String city = '';
  String street = '';
  String provinceId = '';
  String cityId = '';
  String streetId = '';
  List provinceList = [];
  List cityList = [];
  List streetList = [];
  void _getCategory() async {
    //
    await requestGet('getCategory').then((val) {
      if (val['code'] == 0) {
        res = _func(val['result']);
        categoryoneList = res;
        categorytwoList = categoryoneList[0]['subCategorys'];
        categorythreeList = categorytwoList[0]['subCategorys'];
      } else {
        // Application.router.navigateTo(context, "/authentication");
      }
    });
  }

  void _getAddress() async {
    // getAddress
    await requestGet('getAddress').then((val) {
      if (val['code'] == 0) {
        // res = _func(val['result']);
        provinceList = val['result'];
        cityList = provinceList[0]['cityList'];
        streetList = cityList[0]['districtList'];
      } else {
        // Application.router.navigateTo(context, "/authentication");
      }
    });
  }

  _func(list) {
    list.forEach((ele) {
      ele['id'] = ele['id'].toString();
      if (ele['subCategorys'].length > 0) {
        ele['subCategorys'].forEach((item) {
          item['id'] = item['id'].toString();
          if (item['subCategorys'].length > 0) {
            item['subCategorys'].forEach((subitem) {
              subitem['id'] = subitem['id'].toString();
            });
          }
        });
      } else {
        return;
      }
    });
    // print('递归函数$list');
    return list;
  }

  var data;
  void initState() {
    setState(() {
      data = widget.data;
      categorythree = data['supplierTypeName'];
      supplierType = data['supplierType'];
      companyAddressName = data['companyDistrictName'];
      auditStatus = data['auditStatus'];
      supplierType = data['supplierType'];
      companyCode = data['companyCode'];
      companyDetailAddr = data['companyDetailAddr']; //详细地址
      companyMobile = data['companyMobile']; //公司电话
      businessLicenseIssuedRegistrationMark =
          data['businessLicenseIssuedRegistrationMark']; //营业执照编号
      businessLicenseIssuedKey = data['businessLicenseIssuedKey']; //图片key
      businessScope = data['businessScope']; //经营范围
      bank = data['bank']; //银行
      account = data['account']; //银行账号
      companyTelephone = data['companyTelephone']; //公司固定电话
      socialCreditCode = data['socialCreditCode']; //社会信用代码
      contactName = data['contactName']; //联系人
      contactMobile = data['contactMobile']; //联系号码
    });
    _getCategory();
    // _getAddress();
    super.initState();
  }

  bool isSelect = false;
  final authFormKey = GlobalKey<FormState>();
  String username, password;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: authFormKey,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            _selectItem('供应商类型', data),
            _selecAddresstItem('公司地址'),
            _addressItem('详细地址'),
            _componyPhoneItem('公司电话'),
            _componyNumberItem('营业执照编号'),
            MyImage(),
            // ImagePickerPage(),
            _rangeItem('经营范围'),
            _bankOfDepositItem('开户银行'),
            _accountItem('开户账号'),
            _telItem('固定电话'),
            _codeItem('社会信用代码'),
            _contactsItem('联系人'),
            _mobiletItem('手机号码'),
            _bottom(),
          ],
        ),
      ),
    );
  }

  //供应商类型
  void _showBottomSheetCate({
    String categoryone,
    String categorytwo,
    String categorythree,
    List categoryoneList,
    List categorytwoList,
    List categorythreeList,
    BuildContext context,
    MyOnChange onChnage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return AddressPicker(
            province: categoryone,
            city: categorytwo,
            district: categorythree,
            provinceList: categoryoneList,
            cityList: categorytwoList,
            districtList: categorythreeList,
            onChanged: onChnage,
          );
        }),
        // onVerticalDragStart: (_) {},
      ),
    );
  }

  /// 省市区选择器
  void _showBottomSheet({
    String province,
    String city,
    String street,
    List provinceList,
    List cityList,
    List streetList,
    BuildContext context,
    MyOnChange onChnage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return AddressPicker(
            province: province,
            city: city,
            district: street,
            provinceList: provinceList,
            cityList: cityList,
            districtList: streetList,
            onChanged: onChnage,
          );
        }),
        // onVerticalDragStart: (_) {},
      ),
    );
  }

  // 下拉选择供应商类型
  Widget _selectItem(title, data) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          // XYZAddressPickerTestPage(),
          InkWell(
              onTap: () => _showBottomSheetCate(
                    categoryone: categoryone,
                    categorytwo: categorytwo,
                    categorythree: categorythree,
                    categoryoneList: categoryoneList,
                    categorytwoList: categorytwoList,
                    categorythreeList: categorythreeList,
                    context: context,
                    onChnage: (int index, String id, String name) {
                      if (index == 0) {
                        this.setState(() {
                          res.forEach((ele) {
                            if (ele['id'] == id) {
                              return categorytwoList = ele['subCategorys'];
                            }
                          });
                        });
                      }
                      if (index == 1) {
                        categorytwoList.forEach((element) {
                          if (element['id'] == id) {
                            return categorythreeList = element['subCategorys'];
                          }
                        });
                      }
                      switch (index) {
                        case 0:
                          setState(() {
                            categoryone = name;
                          });
                          break;
                        case 1:
                          this.setState(() {
                            categorytwo = name;
                          });
                          break;
                        case 2:
                          this.setState(() {
                            categorythree = name;
                            this.supplierType = id;
                          });
                          break;
                      }
                    },
                  ),
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
                      categorythree == null ? '请选择' : categorythree,
                      style: TextStyle(
                          color: categorythree != null
                              ? Colors.black
                              : Color(0xFFD7D7D7)),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFFD1D1D1),
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }

  void _showSelect() async {
    print('点击弹窗类型选着框');
    Result result = await CityPickers.showCityPicker(
        context: context,
        cancelWidget: Text('取消', style: TextStyle(color: Colors.black54)),
        confirmWidget: Text("确定", style: TextStyle(color: Colors.blue)));
    print('result==$result');
    setState(() {
      companyCode = result.areaId;
      companyAddressName =
          result.provinceName + result.cityName + result.areaName;
      // this.area =
      // "${result.provinceName}/${result.cityName}/${result.areaName}";
    });
  }

  // 选择地址
  Widget _selecAddresstItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          InkWell(
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
                      companyAddressName == null ? '' : companyAddressName,
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFFD1D1D1),
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }

  // 输入详细地址
  Widget _addressItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text:
                    '${this.companyDetailAddr == null ? "" : this.companyDetailAddr}',
              ),
            ),
            // controller: this.companyDetailAddr,
            keyboardType: TextInputType.multiline,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.companyDetailAddr = value;
            },
            onChanged: (value) {
              this.companyDetailAddr = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入详细地址";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入公司电话
  Widget _componyPhoneItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.companyMobile == null ? "" : this.companyMobile}',
              ),
            ),
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              hintText: "请输入",
            ),
            onSaved: (value) {
              this.companyMobile = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入营业执照编号
  Widget _componyNumberItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text:
                    '${this.businessLicenseIssuedRegistrationMark == null ? "" : this.businessLicenseIssuedRegistrationMark}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.businessLicenseIssuedRegistrationMark = value;
            },
            onChanged: (value) {
              this.businessLicenseIssuedRegistrationMark = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入经营范围
  Widget _rangeItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.businessScope == null ? "" : this.businessScope}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.businessScope = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入开户银行
  Widget _bankOfDepositItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.bank == null ? "" : this.bank}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.bank = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入开户账号
  Widget _accountItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.account == null ? "" : this.account}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.account = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入固定电话
  Widget _telItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text:
                    '${this.companyTelephone == null ? "" : this.companyTelephone}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.companyTelephone = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入社会信用代码
  Widget _codeItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text:
                    '${this.socialCreditCode == null ? "" : this.socialCreditCode}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.socialCreditCode = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入联系人
  Widget _contactsItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.contactName == null ? "" : this.contactName}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.contactName = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入手机号码
  Widget _mobiletItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            autofocus: false,
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${this.contactMobile == null ? "" : this.contactMobile}',
              ),
            ),
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.contactMobile = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _bottom() {
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
        onPressed: () async {
          authFormKey.currentState.save();
          var formData = {
            "auditStatus": 1,
            "supplierType": supplierType,
            "companyCode": companyCode,
            "companyDetailAddr": companyDetailAddr,
            "companyMobile": companyMobile,
            "businessLicenseIssuedRegistrationMark":
                businessLicenseIssuedRegistrationMark,
            "businessLicenseIssuedKey": businessLicenseIssuedKey,
            "businessScope": businessScope,
            "bank": bank,
            "account": account,
            "companyTelephone": companyTelephone,
            "socialCreditCode": socialCreditCode,
            "contactName": contactName,
            "contactMobile": contactMobile
          };

          print('fdffdfd=====>${formData}');
          await request('suppliersUpdate', formData: formData).then((val) {
            print('更新企业认证$val;');
            if (val['code'] == 0) {
              Application.router.navigateTo(context, "/indexPage");
            }
          });
          // if (val['code'] == 0) {
          //   // res = _func(val['result']);
          //   provinceList = val['result'];
          //   cityList = provinceList[0]['cityList'];
          //   streetList = cityList[0]['districtList'];
          // } else {
          //   // Application.router.navigateTo(context, "/authentication");
          // }
          // suppliersUpdate
          // _dispatchAdd(context);
          // Application.router.navigateTo(context, "/demanddetail?id=1");
        },
      ),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  /// 待上传的图片列表
  List<Asset> _images = [];

  List<Asset> images = List<Asset>();
  String _error = 'No error Dectected';
  @override
  void initState() {
    super.initState();
  }
  // StreamController _imageListStreamCtrl = StreamController();
  // set _imageStream(List<Asset> list) {
  //   _imageList.addAll(list);
  //   _imageListStreamCtrl.sink.add(_imageList);
  // }

  // get _imageStream => _imageListStreamCtrl.stream;
  // @override
  // void dispose() {
  //   _imageListStreamCtrl.close();
  //   super.dispose();
  //   // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text('营业执照')
            ],
          ),
          // buildGridView(),
          FloatingActionButton(
            onPressed: () {
              _multiImage();
            },
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          // GridView.count(
          //   padding: EdgeInsets.all(8),
          //   crossAxisCount: 3,
          //   mainAxisSpacing: 5,
          //   crossAxisSpacing: 5,
          //   shrinkWrap: true,
          //   children: _getImagesFromAsset(_images),
          // )
          // StreamBuilder(
          //   stream: _imageStream,
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) return Container();
          //     List<Asset> datas = snapshot.data;
          //     return ListView.builder(
          //       itemCount: datas.length,
          //       itemBuilder: (context, idx) {
          //         // return _imageTile(datas[idx]);
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  /// 图片上传
  Future<void> _multiImage() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9, // 最多9张图片
        enableCamera: true, // 允许使用照相机
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "图片上传",
          allViewTitle: "所有图片",
          //okButtonDrawable: 'OK',
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return; // 未挂载到widget树中
    setState(() {
      _images = resultList;
      print('****图片列表***' + resultList.toString());
    });
  }

  /// 从Asset中获取Image
  /// 返回List<AssetThumb>集合
  List<Widget> _getImagesFromAsset(List<Asset> assets) {
    // 没有选择图片
    if (assets.isEmpty) {
      return null;
    }
    print('图片集合$assets');
    return assets.map((asset) {
      return Container(
        width: 30,
        height: 30,
        child: AssetThumb(asset: asset, width: 150, height: 150),
      );
    }).toList();
  }

  // 调接口
  getImages() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No error Dectected';
    // 调本地接口
    // var data = {
    //   'token':
    //       'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwdGVzdCIsInVzZXJfbmFtZSI6InB0ZXN0IiwiX3VzZXJfbmFtZSI6ImhpbnMiLCJleHAiOjE1OTk5NzUwMzcsInVzZXJJZCI6IjBlMDhlMTUzYjA0YTExZTliMzFiYjA2ZWJmMTRhNDc2In0.lMd37OTGQ-TQB-fAT6II3d0Ckd62Xyf55YIcCt5QJkQ'
    // };

    // await request('getpictrueToken', formData: data).then(
    //   (value) {
    //     print('获取图片上传的token${value['upToken']}');
    //     var keys = {'token': value['upToken']};
    //     requestNoHeader('getKey', formData: data).then(
    //       (value) {
    //         print('获取图片上传的token$value');
    //       },
    //     );
    //   },
    // );

    // try {
    //   resultList = await MultiImagePicker.pickImages(
    //     maxImages: 300,
    //     enableCamera: true,
    //     selectedAssets: images,
    //     cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
    //     materialOptions: MaterialOptions(
    //       actionBarColor: "#abcdef",
    //       actionBarTitle: "Example App",
    //       allViewTitle: "All Photos",
    //       useDetailsView: false,
    //       selectCircleStrokeColor: "#000000",
    //     ),
    //   );
    //   print('图片上传成功$resultList');
    // } on Exception catch (e) {
    //   error = e.toString();
    //   print('图片上传错误');
    // }
    // if (!mounted) return;

    // setState(() {
    //   images = resultList;
    //   _error = error;
    //   print('获取本地图片后$images-----错误$_error');
    // });
  }
}

class _imageTile extends StatelessWidget {
  final Asset imageAsset;
  _imageTile(this.imageAsset);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          AssetThumb(asset: imageAsset, width: 100, height: 100),
          FutureBuilder(
            // ignore: deprecated_member_use
            // future: imageAsset.requestMetadata(),
            future: imageAsset.getByteData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              Metadata imageMatadata = snapshot.data;
              return Text('${imageMatadata.exif.artist}');
            },
          )
        ],
      ),
    );
  }
}

// class Test{
//   List<Asset> images = List<Asset>();

//   // 选择照片并上传
//   Future<void> uploadImages() async {
//     setState(() {
//       images = List<Asset>();
//     });
//     List<Asset> resultList;

//     try {
//       resultList = await MultiImagePicker.pickImages(
//         // 选择图片的最大数量
//         maxImages: 9,
//         // 是否支持拍照
//         enableCamera: true,
//         materialOptions: MaterialOptions(
//             // 显示所有照片，值为 false 时显示相册
//             startInAllView: true,
//             allViewTitle: '所有照片',
//             actionBarColor: '#2196F3',
//             textOnNothingSelected: '没有选择照片'
//         ),
//       );
//     } on Exception catch (e) {
//       e.toString();
//     }

//     if (!mounted) return;
//     images = (resultList == null) ? [] : resultList;
//     // 上传照片时一张一张上传
//     for(int i = 0; i < images.length; i++) {
//       // 获取 ByteData
//       ByteData byteData = await images[i].getByteData();
//       List<int> imageData = byteData.buffer.asUint8List();

//       MultipartFile multipartFile = MultipartFile.fromBytes(
//         imageData,
//         // 文件名
//         filename: 'some-file-name.jpg',
//         // 文件类型
//         contentType: MediaType("image", "jpg"),
//       );
//       FormData formData = FormData.fromMap({
//         // 后端接口的参数名称
//         "files": multipartFile
//       });
//       // 后端接口 url
//       String url = ''；
//       // 后端接口的其他参数
//       Map<String, dynamic> params = Map();
//       // 使用 dio 上传图片
//       var response = await dio.post(url, data: formData, queryParameters: params);
//       //
//       // do something with response...
//     }
//   }
// }
