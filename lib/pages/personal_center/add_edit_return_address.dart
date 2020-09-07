import 'dart:collection';

import 'package:bid/common/log_utils.dart';
import 'package:bid/common/string_utils.dart';
import 'package:bid/model/base/BaseResponseModel.dart';
import 'package:bid/model/user_center/CertificationInfoModel.dart';
import 'package:bid/service/service_method.dart';
import 'package:flutter/material.dart';

class AddEditReturnAddress extends StatefulWidget {
  @override
  _AddEditReturnAddressState createState() => _AddEditReturnAddressState();
}

class _AddEditReturnAddressState extends State<AddEditReturnAddress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('退货地址'),
    );
  }
}
