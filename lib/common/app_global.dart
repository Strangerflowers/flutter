import 'dart:convert';

import 'package:bid/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bid/models/index.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // //初始化全局信息，会在APP启动时执行
  // static Future init() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   var _profile = _prefs.getString("profile");
  //   if (_profile != null) {
  //     try {
  //       print('jinr======');
  //       profile = Profile.fromJson(jsonDecode(_profile));
  //     } catch (e) {
  //       print(e);
  //     }
  //   }

  //   //初始化网络请求相关配置
  //   // Global.init();
  //   // init();
  // }
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    print('持久化之前的方法--------');
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("token");
    if (_profile != null) {
      try {
        profile.token = _profile;
      } catch (e) {
        print(e);
      }
    }

    var oldauditstatue = _prefs.getInt('auditStatusStatus');
    if (oldauditstatue != null) {
      try {
        profile.auditStatus = oldauditstatue;
      } catch (e) {
        print(e);
      }
    }
    await Git.checkAuditStatus();
  }

  // 持久化Profile信息
  static saveProfile() {
    print('修改变化');
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
}

class SpUtil {
  static SharedPreferences _prefs;
  // static PackageInfo packageInfo;
  static Future<bool> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    // packageInfo = await PackageInfo.fromPlatform();
    return true;
  }
}

class Git {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  static Future checkAuditStatus() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      var val = await requestGet('checkAuditStatus');
      if (val['code'] == 0) {
        _prefs.remove("auditStatusStatus");
        _prefs.setInt('auditStatusStatus', val['result']['auditStatus']);
      } else if (val['code'] == 13001010) {
        // print('token 失效');
        _prefs.clear();
      }
      return true;
    } catch (e) {
      print(e);
    }

    //  .then((val) {
    //     print('全局调用方法');
    //     if (val['code'] == 0) {
    //       Reop auditstatue = Reop.fromJson(val['result']);
    //       _prefs.setInt('auditStatusStatus', auditstatue.auditStatus);
    //     } else if (val['code'] == 13001010) {
    //       print('token 失效');
    //       _prefs.clear();
    //     }
    //   });
    // }
  }
}
