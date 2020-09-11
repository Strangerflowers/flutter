import 'dart:async';

import 'package:bid/common/log_utils.dart';
import 'package:bid/common/network.dart';
import 'package:bid/config/service_url_holder.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

const String TAG = "ServiceMethod";
// 所有请求的方法Post请求
// 封装请求
// 获取首页主题内容
Future request(
  url, {
  formData,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Options options = new Options();
    options.headers = {
      "X-OS-KERNEL-TOKEN": token,
    };
    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.info(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);
    var responseData;
    if (formData == null) {
      responseData = await Network.post(
        requestUrl,
        options: options,
      );
    } else {
      responseData = await Network.post(
        requestUrl,
        data: formData,
        options: options,
      );
    }
    return responseData;
  } catch (e) {
    print(e);
  }
}

// 拼接参数
Future requestPostSpl(
  url, {
  spl,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Options options = new Options();
    options.headers = {
      "X-OS-KERNEL-TOKEN": token,
    };

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, spl]),
        StackTrace.current);

    var responseData;
    if (spl == null) {
      responseData = await Network.post(
        requestUrl,
        options: options,
      );
    } else {
      responseData = await Network.post(
        requestUrl + '/' + spl,
        options: options,
      );
    }
    return responseData;
  } catch (e) {
    print(e);
  }
}

//无请求头参数
Future requestNoHeader(url, {formData}) async {
  try {
    Options options = new Options();
    options.contentType = "application/json";

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);
    var responseData;
    if (formData == null) {
      responseData = await Network.post(
        requestUrl,
        options: options,
      );
    } else {
      responseData = await Network.post(
        requestUrl,
        options: options,
        data: formData,
      );
    }
    return responseData;
  } catch (e) {
    print(e);
  }
}

// get请求方法
Future requestGet(url, {formData}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Options options = new Options();
    options.headers = {
      "X-OS-KERNEL-TOKEN": token,
    };

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);
    var responseData;
    if (formData == null) {
      responseData = await Network.get(
        requestUrl,
        options: options,
      );
    } else {
      responseData = await Network.get(
        requestUrl,
        options: options,
        queryParameters: formData,
      );
    }
    return responseData;
  } catch (e) {
    print(e);
  }
}
