import 'dart:io';

import 'package:bid/common/app_manager.dart';
import 'package:bid/common/log_utils.dart';
import 'package:bid/routers/routers.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';

class Network {
  static String TAG = "Network";
  static Dio _dio;
  static AndroidDeviceInfo _androidInfo;
  static IosDeviceInfo _iosInfo;

  static String get platform {
    return Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : '');
  }

  static Dio get instance => _dio;

  static void setHttpProxy(String host, String port) {
    if (host.length != 0) {
      AppManager.httpProxy = host + ':' + port;
    } else {
      AppManager.httpProxy = '';
    }
    _initDio();
  }

  static Future<void> _initDio() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      _androidInfo = await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      _iosInfo = await deviceInfo.iosInfo;
    }

    _dio = Dio(BaseOptions(
      contentType: 'application/json',
//      baseUrl: Config.BASE_URL,
    ));
    _dio.options.receiveTimeout = 5000;
    _dio.options.connectTimeout = 30000;

    if (AppManager.httpProxy.length > 5) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        //这一段是解决安卓https抓包的问题
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return Platform.isAndroid;
        };

        client.findProxy = (uri) {
          //注入代理
          LogUtils.debug(
              TAG,
              sprintf('=======>注入的代理地址为:%s', [AppManager.httpProxy]),
              StackTrace.current);
          return "PROXY ${AppManager.httpProxy}";
        };
      };
    }
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (Options options) {
          options.headers['Source'] = platform.toLowerCase();
          options.headers['utm'] = AppManager.channel;
          return options;
        },
        onResponse: (Response res) {
          try {
            LogUtils.debug(TAG, '接口: ${res.request.baseUrl}${res.request.path}',
                StackTrace.current);
            if (res.request.method == "POST") {
              LogUtils.debug(
                  TAG, '参数: ${res.request.data}', StackTrace.current);
            } else {
              LogUtils.debug(TAG, '参数: ${res.request.queryParameters}',
                  StackTrace.current);
            }
            LogUtils.debug(TAG, '返回数据: ${res.data}', StackTrace.current);
            print('\n');
            return res.data;
          } catch (e) {
            LogUtils.error(TAG, '接口响应发生错误, 堆栈信息: ', StackTrace.current, e: e);
            return res;
          }
        },
        onError: (DioError e) {
          print('\n');
          LogUtils.error(TAG, '接口请求发生错误, 捕获DioError的堆栈信息: ', StackTrace.current,
              e: e);
          print('\n');
          LogUtils.error(TAG, '报错接口: ${e.request.baseUrl}${e.request.path}',
              StackTrace.current);
          if (e.request.method == "POST") {
            LogUtils.error(TAG, '参数: ${e.request.data}', StackTrace.current);
          } else {
            LogUtils.error(
                TAG, '参数: ${e.request.queryParameters}', StackTrace.current);
          }
          switch (e.type) {
            case DioErrorType.CONNECT_TIMEOUT:
              // Fluttertoast.showToast(msg: '请求超时，请检查网络连接后重试');
              break;
            case DioErrorType.RESPONSE:
              LogUtils.error(
                  TAG, 'response: ${e.response.data}', StackTrace.current);
              final data = e.response.data;
              if (data != null) {
                Fluttertoast.showToast(
                  msg: data['errorCode'] != null
                      ? '${data['errorCode']} ${data['errorMsg']}'
                      : '请求出现错误',
                );
              }
              break;
            default:
          }
          return e;
        },
      ),
    ]);
  }

  static Future get(
    String path, {
    String baseUrl = '',
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    bool isShowToast = false, //是否显示提示框
    PopPage popPage = PopPage.popNone, //是否返回上一页
    void Function(int, int) onReceiveProgress,
  }) async {
    if (_dio == null) {
      await _initDio();
    }
    var res;
    try {
      res = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      //responseHandling(res.data, popPage: popPage, isShowToast: isShowToast);
    } catch (e) {
      if (isShowToast) {
        Fluttertoast.showToast(
            msg: '网络错误，请检查网络连接后重试', gravity: ToastGravity.CENTER);
      }
    }

    return res.data;
  }

  static Future post(
    String path, {
    String baseUrl = '',
    dynamic data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    bool isShowToast = false, //是否显示提示框
    PopPage popPage = PopPage.popNone, //是否返回上一页
    void Function(int, int) onSendProgress,
    void Function(int, int) onReceiveProgress,
  }) async {
    if (_dio == null) {
      await _initDio();
    }
    var res;
    try {
      res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      // responseHandling(res.data, popPage: popPage, isShowToast: isShowToast);
    } catch (e) {
      if (isShowToast) {
        Fluttertoast.showToast(
            msg: '网络错误，请检查网络连接后重试', gravity: ToastGravity.CENTER);
      }
    }
    return res.data;
  }

  //处理逻辑
  /* static responseHandling(
    ResponseModel data, {
    bool isShowToast, //是否显示提示框
    PopPage popPage,
  }) {
    if (data.code == 1 && data.bizCode != 20000) {
      if (isShowToast) {
        Fluttertoast.showToast(msg: data.bizMsg, gravity: ToastGravity.CENTER);
      }
    } else if (data.code == -1 || data.code == -2) {
      AppRoutesManager.pushPage({
        'page': PushPage.goLogin,
        'popPage': PopPage.popUp,
        'code': -data.code
      });
    }
  } */
}
