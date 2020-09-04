import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/servie_url.dart';

// 所有请求的方法Post请求
// 封装请求
// 获取首页主题内容
Future request(
  url, {
  formData,
}) async {
  try {
    print('开始获取数据..........');
    Response response;
    Dio dio = new Dio();
    // dio.options.contentType = "application/json";
    // dio.options.responseType = "ResponseType.plain";
    dio.options.headers = {
      "X-OS-KERNEL-TOKEN":
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ3NhbjEiLCJ1c2VyX25hbWUiOiJ6aGFuZ3NhbjEiLCJfdXNlcl9uYW1lIjoi5byg5LiJIiwiZXhwIjoxNjAxNzE0NDg0LCJ1c2VySWQiOiIwN2UwOTY1M2IyMDQzMjQwZGZmNDk4ODZhODhmYTk4MyJ9.6rChGbeaWFv_tilidm0W5ZQBSICViEMQA-ETrXv8Mnk",
    };
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
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
    print('开始获取数据..........');
    Response response;
    Dio dio = new Dio();

    dio.options.contentType = "application/json";

    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
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
    print('开始获取数据..........');
    Response response;
    Dio dio = new Dio();

    // dio.options.contentType = "application/x-www-form-urlencoded";
    dio.options.headers = {
      "X-OS-KERNEL-TOKEN":
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6aGFuZ3NhbjEiLCJ1c2VyX25hbWUiOiJ6aGFuZ3NhbjEiLCJfdXNlcl9uYW1lIjoi5byg5LiJIiwiZXhwIjoxNjAxNzE0NDg0LCJ1c2VySWQiOiIwN2UwOTY1M2IyMDQzMjQwZGZmNDk4ODZhODhmYTk4MyJ9.6rChGbeaWFv_tilidm0W5ZQBSICViEMQA-ETrXv8Mnk",
    };
    if (formData == null) {
      response = await dio.get(servicePath[url]);
    } else {
      response = await dio.get(servicePath[url], queryParameters: formData);
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

Future getHomePageContent() async {
  try {
    Response response;
    Dio dio = new Dio();

    dio.options.contentType = "application/x-www-form-urlencoded";
    // dio.options.contentType =
    //     ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    print(e);
  }
}

// 获取火爆专区列表商品方法
Future getHomePageBeloConten() async {
  try {
    Response response;
    Dio dio = new Dio();

    dio.options.contentType = "application/x-www-form-urlencoded";
    // dio.options.contentType =
    //     ContentType.parse("application/x-www-form-urlencoded");
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'], data: page);
    if (response.statusCode == 200) {
      // print('测试是否调用火爆专区方法${response.data}');
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    print(e);
  }
}
