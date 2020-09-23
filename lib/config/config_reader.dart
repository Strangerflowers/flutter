import 'dart:convert';

import 'package:bid/common/log_utils.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

/// 配置文件加载器，用于加载config/app_xxx_config.json文件
/// @author DANTE FUNG
/// @date 2020-9-9 15:53:56
abstract class ConfigReader {
  static String TAG = "ConfigReader";
  static Map<String, dynamic> _config;

  static Future<void> initialize(String env) async {
    LogUtils.info(
        TAG,
        sprintf(
            '\r\n==========================================\r\n' +
                '              当前运行环境为:  %s ' +
                '\r\n==========================================\r\n',
            [env]),
        StackTrace.current);

    String configLocation = 'env/app_' + env + '_config.json';
    LogUtils.debug(
        TAG, sprintf('开始加载%s配置文件...', [configLocation]), StackTrace.current);

    final configString = await rootBundle.loadString(configLocation);
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getAppOsApiUrl() {
    return _config['appOsApiUrl'] as String;
  }

  static String getAppApiUrl() {
    return _config['appApiUrl'] as String;
  }
}
