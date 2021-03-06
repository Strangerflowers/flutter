// 资料认证页面
import 'dart:async';
import 'dart:collection';

import 'package:bid/common/toast.dart';
import 'package:bid/common/xyz_picker.dart';
import 'package:bid/routers/application.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../images.dart';
import '../../service/service_method.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _futureBuilderFuture;
  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _gerData();
  }

  Future _gerData() async {
    var response = await requestGet('checkAuditStatus');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          title: Text("资料认证"),
        ),
        body: GestureDetector(
          onTap: () {
            //隐藏键盘
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            // 失去焦点
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView(children: <Widget>[
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
                }
                return Container(
                  child: Text(''),
                );
                // return Container(
                //   height: MediaQuery.of(context).size.height / 2,
                //   child: Center(
                //     child: CircularProgressIndicator(
                //       backgroundColor: Colors.grey[200],
                //       valueColor: AlwaysStoppedAnimation(Colors.blue),
                //       value: .7,
                //     ),
                //   ),
                // );
              }),
        ),
      ),
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
          _headerItemRow('供应商编号', result['companyNum']),
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

GlobalKey<AddressPickerState> addressPickerState = GlobalKey();
typedef MyOnChange = Function(int index, String id, String name);

class _AuthenticationFormState extends State<AuthenticationForm> {
  String TAG = "_AuthenticationFormState";
  bool isValider = false;
  bool disableBtn = false;
  Map<String, Object> categoryTree = new LinkedHashMap();
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
  var companyProvinceCode;
  var companyCityCode;
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
  String categoryoneId;
  String categorytwoId;
  // 存放供应商类型字段
  var typeList;

  void _getCategory() async {
    //
    await requestGet('getCategory').then((val) {
      if (val['code'] == 0) {
        print('响应供应商类型:${val}');
        if (val['result'] != null && val['result'].length > 0) {
          res = _func(val['result']);
          categoryoneList = res;
          _toMap(val['result']);

          // print(categoryTree.keys.join(','));
          if (supplierType != null) {
            Map categoryLevelThree = categoryTree[supplierType.toString()];
            Map categoryLevelTwo =
                categoryTree[categoryLevelThree['pid'].toString()];
            categorytwoId = categoryLevelTwo['id'];
            Map categoryLevelOne =
                categoryTree[categoryLevelTwo['pid'].toString()];
            categoryoneId = categoryLevelOne['id'];
            print(
                'Map======${categorytwoId}=====$categoryoneId====================$supplierType');

            var arr = [];
            categoryoneList.forEach((ele) {
              if (ele['name'] == categoryone) {
                arr = ele['subCategorys'];
              }
            });
            categorytwoList = arr;

            var brr = [];
            categorytwoList.forEach((ele) {
              if (ele['name'] == categorytwo) {
                brr = ele['subCategorys'];
              }
            });
            categorythreeList = brr;
          }
          // categorytwoList = categoryoneList[0]['subCategorys'];
          // categorythreeList = categorytwoList[0]['subCategorys'];
        } else {
          Toast.toast(context, msg: '供应商类型列表暂无数据');
        }
      } else {
        Toast.toast(context, msg: val['message']);
        // Application.router.navigateTo(context, "/authentication");
      }
    });
  }

  void _toMap(list) {
    // TODO:
    // list.forEach((ele) {
    //   categoryTree[ele['id']] = ele;
    //   if (ele['subCategorys'] != null && ele['subCategorys'].length > 0) {
    //     _toMap(ele['subCategorys']);
    //   }
    // });
    for (int i = 0, length = list.length; i < length; i++) {
      Map ele = list[i];
      categoryTree[ele['id']] = ele;
      if (ele['subCategorys'] != null && ele['subCategorys'].length > 0) {
        _toMap(ele['subCategorys']);
      }
    }
  }

  void _getAddress() async {
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
    // setState(() {
    data = widget.data;
    supplierType = data['supplierType'];
    typeList = data['supplierTypeName'];
    var categoryType;
    if (typeList != null) {
      categoryType = typeList.split('/');
      if (categoryType.length == 1) {
        categoryone = categoryType[0];
        categoryoneId = supplierType;
        supplierType = null;
      } else if (categoryType.length == 2) {
        categoryone = categoryType[0];
        categorytwo = categoryType[1];
        categorytwoId = supplierType;
        supplierType = null;
      } else {
        categoryone = categoryType[0];
        categorytwo = categoryType[1];
        categorythree = categoryType[2];
      }
    } else {
      categoryone = '';
      categorytwo = '';
      categorythree = '';
    }

    // supplierType = data['supplierType'];
    companyAddressName = data['companyDistrictName'];
    auditStatus = data['auditStatus'];
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
    companyProvinceCode = data['companyProvinceCode'];
    companyCityCode = data['companyCityCode'];
    // });
    _getCategory();
    // _getAddress();
    super.initState();
  }

  bool isSelect = false;
  final authFormKey = GlobalKey<FormState>();
  String username, password;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Form(
      key: authFormKey,
      autovalidate: isValider,
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
            MyImage(
                businessLicenseIssuedKey,
                data['businessLicenseIssuedUrl'] == null
                    ? ''
                    : data['businessLicenseIssuedUrl'], (val) {
              setState(() {
                businessLicenseIssuedKey = val;
                print('获取上传图片的key值$businessLicenseIssuedKey');
              });
            }),
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
    String categoryoneId,
    String categorytwoId,
    String categoryone,
    String categorytwo,
    String categorythree,
    List categoryoneList,
    List categorytwoList,
    List categorythreeList,
    String supplierType,
    BuildContext context,
    MyOnChange onChnage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          // TODO: 待改进
          return AddressPicker(
            provinceId: categoryoneId,
            cityId: categorytwoId,
            province: categoryone,
            city: categorytwo,
            district: categorythree,
            provinceList: categoryoneList,
            cityList: categorytwoList,
            districtList: categorythreeList,
            supplierType: supplierType,
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          // XYZAddressPickerTestPage(),
          InkWell(onTap: () {
            //隐藏键盘
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            FocusScope.of(context).requestFocus(FocusNode());

            _showBottomSheetCate(
              categoryoneId: categoryoneId,
              categorytwoId: categorytwoId,
              categoryone: categoryone,
              categorytwo: categorytwo,
              categorythree: categorythree,
              categoryoneList: categoryoneList,
              categorytwoList: categorytwoList,
              categorythreeList: categorythreeList,
              supplierType: supplierType,
              context: context,
              onChnage: (int index, String id, String name) {
                if (index == 0) {
                  var arr = [];
                  // setState(() {
                  res.forEach((ele) {
                    if (ele['id'] == id) {
                      return arr = ele['subCategorys'];
                    }
                    // });
                  });
                  setState(() {
                    categorytwoList = arr;
                  });
                  // addressPickerState.currentState.checkedTab(index);
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
                      typeList = name;
                      categoryone = name;
                      categoryoneId = id;
                      categorytwo = '';
                      categorytwoId = '';
                      categorythree = '';
                      supplierType = '';
                    });
                    break;
                  case 1:
                    setState(() {
                      categorytwo = name;
                      categorytwoId = id;
                      typeList = categoryone + '/' + name;
                      categorythree = '';
                      supplierType = '';
                    });
                    break;
                  case 2:
                    setState(() {
                      categorythree = name;
                      supplierType = id;
                      typeList = categoryone + '/' + categorytwo + '/' + name;
                    });
                    break;
                }
              },
            );
          }, child: StatefulBuilder(builder: (context, StateSetter setState) {
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
                  typeList == null ? '请选择类别' : typeList.toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color:
                          typeList != null ? Colors.black : Color(0xFF888888)),
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
    //隐藏键盘
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    print('点击弹窗类型选着框');
    Result result = await CityPickers.showCityPicker(
        context: context,
        locationCode: companyCode,
        cancelWidget: Text('取消', style: TextStyle(color: Colors.black54)),
        confirmWidget: Text("确定", style: TextStyle(color: Colors.blue)));
    print('result==$result');
    setState(() {
      companyCode = result.areaId;
      companyProvinceCode = result.provinceId;
      companyCityCode = result.cityId;
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
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
                      companyAddressName == null ? '请选择地址' : companyAddressName,
                      style: TextStyle(
                        color: companyAddressName == null
                            ? Color(0xFF888888)
                            : Colors.black,
                        fontSize: ScreenUtil().setSp(32),
                      ),
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${companyDetailAddr == null ? "" : companyDetailAddr}',
                // 保持光标在最后
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${companyDetailAddr}'.length),
                ),
              ),
            ),
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入详细地址",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              companyDetailAddr = value;
            },
            onChanged: (value) {
              companyDetailAddr = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入详细地址";
              } else if (value.length > 50) {
                return "长度不能超过50个";
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${companyMobile == null ? "" : companyMobile}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${companyMobile}'.length),
                ),
              ),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              hintText: "请输入公司联系电话",
            ),
            onSaved: (value) {
              companyMobile = value;
            },
            onChanged: (value) {
              companyMobile = value;
            },
            validator: (value) {
              // RegExp exp = RegExp(r'^0\d{2,3}-?\d{7,16}$');
              RegExp exp = RegExp(r'^0\d{2,3}-[1-9]\d{6,7}$');
              if (value.isEmpty) {
                return "请输入公司联系电话";
              } else if (!exp.hasMatch(value)) {
                return "号码格式不对";
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text:
                    '${businessLicenseIssuedRegistrationMark == null ? "" : businessLicenseIssuedRegistrationMark}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset:
                          '${businessLicenseIssuedRegistrationMark}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入营业执照编号",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              businessLicenseIssuedRegistrationMark = value;
            },
            onChanged: (value) {
              businessLicenseIssuedRegistrationMark = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入营业执照编号";
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${businessScope == null ? "" : businessScope}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${businessScope}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入经营范围",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              businessScope = value;
            },
            onChanged: (value) {
              businessScope = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "不能为空";
              } else if (value.length > 200) {
                return "长度不能超过200个字符";
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
              // Text(
              //   '*',
              //   style: TextStyle(color: Colors.red),
              // ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${bank == null ? "" : bank}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${bank}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入开户银行名称",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              bank = value;
            },
            onChanged: (value) {
              bank = value;
            },
            validator: (value) {
              if (value.length > 50) {
                return "长度不能超过50个";
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
              // Text(
              //   '*',
              //   style: TextStyle(color: Colors.red),
              // ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${account == null ? "" : account}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${account}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入开户账号",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              account = value;
            },
            onChanged: (value) {
              account = value;
            },
            validator: (value) {
              // if (value.isEmpty) {
              //   return "请输入";
              // }
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
              // Text(
              //   '*',
              //   style: TextStyle(color: Colors.red),
              // ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${companyTelephone == null ? "" : companyTelephone}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${companyTelephone}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入固定电话",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              companyTelephone = value;
            },
            onChanged: (value) {
              companyTelephone = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return null;
              } else {
                RegExp exp = RegExp(r'^0\d{2,3}-[1-9]\d{6,7}$');
                // RegExp exp = RegExp(r'^0\d{2,3}-[1-9]\d{6,7}$');
                // RegExp exp = RegExp(r'^0\d{2,3}-?\d{7,16}$');
                if (!exp.hasMatch(value)) {
                  return "格式错误";
                }
              }

              // return null;
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${socialCreditCode == null ? "" : socialCreditCode}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${socialCreditCode}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入社会信用代码",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              socialCreditCode = value;
            },
            onChanged: (value) {
              socialCreditCode = value;
            },
            validator: (value) {
              RegExp exp =
                  RegExp(r'^[^_IOZSVa-z\W]{2}\d{6}[^_IOZSVa-z\W]{10}$');
              if (value.isEmpty) {
                return "请输入社会信用代码";
              } else if (!exp.hasMatch(value)) {
                return "格式错误";
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${contactName == null ? "" : contactName}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${contactName}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入联系人姓名",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              contactName = value;
            },
            onChanged: (value) {
              contactName = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "不能为空";
              } else if (value.length > 10) {
                return "长度不能超过10个";
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
              Text(
                title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                ),
              )
            ],
          ),
          TextFormField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32),
            ),
            autofocus: false,
            autovalidate: isValider,
            // keyboardType: TextInputType.phone,
            // keyboardType: TextInputType.phone,
            maxLines: 1, //不限制行数
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: '${contactMobile == null ? "" : contactMobile}',
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${contactMobile}'.length),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              // labelText: "用户名",
              hintText: "请输入联系人手机号码",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              contactMobile = value;
            },
            onChanged: (value) {
              contactMobile = value;
            },
            validator: (value) {
              RegExp exp = RegExp(
                  r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
              if (value.isEmpty) {
                return "请输入";
              } else if (!exp.hasMatch(value)) {
                return "手机号码错误";
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
          var prefs = await SharedPreferences.getInstance();
          setState(() {
            isValider = true;
          });
          authFormKey.currentState.save();
          if ((authFormKey.currentState as FormState).validate()) {
            // if (supplierType == '' &&
            //     categoryoneId == '' &&
            //     categorytwoId == '') {
            //   Toast.toast(context, msg: '供应商类型不能为空');
            //   return;
            // }
            var supplierTypeId;
            if (supplierType != null && supplierType != '') {
              supplierTypeId = supplierType;
            } else if (categorytwoId != null && categorytwoId != '') {
              supplierTypeId = categorytwoId;
            } else if (categoryoneId != null && categoryoneId != '') {
              supplierTypeId = categoryoneId;
            }
            if (supplierTypeId == null ||
                supplierTypeId == '' ||
                supplierTypeId == 'null') {
              Toast.toast(context, msg: '供应商类型不能为空');
              return;
            }
            if (companyCode == null ||
                companyCode == '' ||
                companyCode == 'null') {
              Toast.toast(context, msg: '公司地址不能为空');
              return;
            }
            if (businessLicenseIssuedKey == null ||
                businessLicenseIssuedKey == '' ||
                businessLicenseIssuedKey == 'null') {
              return Toast.toast(context, msg: '营业执照不能为空');
            }
            var formData = {
              "auditStatus": 1,
              "supplierType": supplierTypeId,
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
              "contactMobile": contactMobile,
              "companyProvinceCode": companyProvinceCode,
              "companyCityCode": companyCityCode
            };

            if (disableBtn) {
              return;
            }
            disableBtn = true;

            await request('suppliersUpdate', formData: formData).then((val) {
              if (val['code'] == 0) {
                prefs.setInt('auditStatusStatus', val['result']['auditStatus']);
                // setState(() {});
                Toast.toast(context, msg: "更新企业认证成功！请等待审核通过");
                if (val['result']['auditStatus'] == 0) {
                  Navigator.pop(context);
                  Application.router.navigateTo(context, "/indexPage");
                } else {
                  Navigator.pop(context);
                  Application.router.navigateTo(context, "/certificateInfo");
                }
                // disableBtn = false;
              } else {
                disableBtn = false;
                Toast.toast(context, msg: val['message']);
              }
            });
          }
        },
      ),
    );
  }
}
