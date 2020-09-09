import 'dart:async';

import 'package:bid/common/log_utils.dart';
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
    Response response;
    Dio dio = new Dio();
    // dio.options.contentType = "application/json";
    // dio.options.responseType = "ResponseType.plain";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers = {
      "X-OS-KERNEL-TOKEN": token,
      // "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ3NhbjEiLCJ1c2VyX25hbWUiOiJ6aGFuZ3NhbjEiLCJfdXNlcl9uYW1lIjoi5byg5LiJIiwiZXhwIjoxNjAxNzE0NDg0LCJ1c2VySWQiOiIwN2UwOTY1M2IyMDQzMjQwZGZmNDk4ODZhODhmYTk4MyJ9.6rChGbeaWFv_tilidm0W5ZQBSICViEMQA-ETrXv8Mnk",
    };
    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.info(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);

    if (formData == null) {
      response = await dio.post(requestUrl);
    } else {
      response = await dio.post(requestUrl, data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
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
    Response response;
    Dio dio = new Dio();
    // dio.options.contentType = "application/json";
    // dio.options.responseType = "ResponseType.plain";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    dio.options.headers = {
      "X-OS-KERNEL-TOKEN": token,
      // "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ3NhbjEiLCJ1c2VyX25hbWUiOiJ6aGFuZ3NhbjEiLCJfdXNlcl9uYW1lIjoi5byg5LiJIiwiZXhwIjoxNjAxNzE0NDg0LCJ1c2VySWQiOiIwN2UwOTY1M2IyMDQzMjQwZGZmNDk4ODZhODhmYTk4MyJ9.6rChGbeaWFv_tilidm0W5ZQBSICViEMQA-ETrXv8Mnk",
    };

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, spl]),
        StackTrace.current);

    if (spl == null) {
      response = await dio.post(requestUrl);
    } else {
      response = await dio.post(requestUrl + '/' + spl);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    print(e);
  }
}

//无请求头参数
Future requestNoHeader(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();

    dio.options.contentType = "application/json";

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);

    if (formData == null) {
      response = await dio.post(requestUrl);
    } else {
      response = await dio.post(requestUrl, data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    print(e);
  }
}

// get请求方法
Future requestGet(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    // dio.options.contentType = "application/x-www-form-urlencoded";
    dio.options.headers = {
      "X-OS-KERNEL-TOKEN": token,
      // "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ3NhbjEiLCJ1c2VyX25hbWUiOiJ6aGFuZ3NhbjEiLCJfdXNlcl9uYW1lIjoi5byg5LiJIiwiZXhwIjoxNjAxNzE0NDg0LCJ1c2VySWQiOiIwN2UwOTY1M2IyMDQzMjQwZGZmNDk4ODZhODhmYTk4MyJ9.6rChGbeaWFv_tilidm0W5ZQBSICViEMQA-ETrXv8Mnk",
    };

    String requestUrl = ServiceUrlHolder.getUrl(url);
    LogUtils.debug(
        TAG,
        sprintf('开始获取数据，请求地址:%s, 请求参数:%s  ....', [requestUrl, formData]),
        StackTrace.current);

    if (formData == null) {
      response = await dio.get(requestUrl);
    } else {
      response = await dio.get(requestUrl, queryParameters: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    print(e);
  }
}
