import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:xyz_address_picker/xyz_address_picker.dart';

class XYZAddressPickerTestPage extends StatelessWidget {
  const XYZAddressPickerTestPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XYZAddressPickerTestPageContainer();
  }
}

class XYZAddressPickerTestPageContainer extends StatefulWidget {
  const XYZAddressPickerTestPageContainer({Key key}) : super(key: key);

  @override
  _XYZAddressPickerTestPageContainerState createState() =>
      _XYZAddressPickerTestPageContainerState();
}

typedef MyOnChange = Function(int index, String id, String name);

class _XYZAddressPickerTestPageContainerState
    extends State<XYZAddressPickerTestPageContainer> {
  List res = [];
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
    await requestGet('getCategory').then((val) {
      if (val['code'] == 0) {
        res = _func(val['result']);
        provinceList = res;
        cityList = provinceList[0]['subCategorys'];
        streetList = cityList[0]['subCategorys'];
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

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      color: Color(0xFF4A4A4A),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          color: Color(0xFFF7F7F7),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.bottom -
              60,
          child: Column(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _showBottomSheet(
                  province: province,
                  city: city,
                  street: street,
                  provinceList: provinceList,
                  cityList: cityList,
                  streetList: streetList,
                  context: context,
                  onChnage: (int index, String id, String name) {
                    if (index == 0) {
                      this.setState(() {
                        res.forEach((ele) {
                          if (ele['id'] == id) {
                            return cityList = ele['subCategorys'];
                          }
                        });
                      });
                    }
                    if (index == 1) {
                      cityList.forEach((element) {
                        if (element['id'] == id) {
                          return streetList = element['subCategorys'];
                        }
                      });
                    }

                    switch (index) {
                      case 0:
                        setState(() {
                          province = name;
                          provinceId = id;
                        });
                        break;
                      case 1:
                        this.setState(() {
                          city = name;
                          cityId = id;
                        });
                        break;
                      case 2:
                        this.setState(() {
                          street = name;
                          cityId = id;
                        });
                        break;
                    }
                  },
                ),
                child:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                width: 70,
                                child: Text('收货地址：', style: labelStyle)),
                            SizedBox(width: 30),
                            Text(province == ''
                                ? '选择所在地区'
                                : province + city + street)
                          ],
                        ),
                        Container(
                          width: 50,
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF000000),
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
    // );
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
      // builder: (BuildContext context) {
      //   return AddressPicker(
      //     province: province,
      //     city: city,
      //     district: street,
      //     provinceList: provinceList,
      //     cityList: cityList,
      //     districtList: streetList,
      //     onChanged: onChnage,
      //   );
      // },
    );
  }
}
