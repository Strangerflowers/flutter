import 'dart:io';

import 'package:bid/common/log_utils.dart';
import 'package:bid/common/toast.dart';
import 'package:bid/pages/component/ImageWidgetBuilder.dart';
import 'package:bid/service/service_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

class MyImage extends StatefulWidget {
  // 七牛云的key
  var businessLicenseIssuedKey;
  // 图片的URL地址
  final String url;
  // 回调处理器
  final ValueChanged<String> onChangePic;

  MyImage(this.businessLicenseIssuedKey, this.url, @required this.onChangePic);

  @override
  _MyImageState createState() => new _MyImageState();
}

class _MyImageState extends State<MyImage> {
  static String TAG = "_MyImageState";
  String _uploadProcessPrecent = '0.0';
  File _image;
  String uploadToken;
  String key;
  String url;

  @override
  void initState() {
    key = widget.businessLicenseIssuedKey;
    url = widget.url;
    super.initState();
    LogUtils.debug(
        TAG, '初始化MyImage组件, url: ${url}, key: ${key}', StackTrace.current);
  }

  @override
  void dispose() {
    widget.businessLicenseIssuedKey = key;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
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
            Row(
              children: <Widget>[
                Container(
                  child: _loadingImage(),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _getUploadToken();
                    _onUpload();
                    //_onUploadBySyFlutterQiniuStorage();
                  },
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------
  /// 加载图片
  /// ----------------------
  Widget _loadingImage() {
    if (url != '') {
      return Container(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(200),
          child: ImageWidgetBuilder.loadImage(url,
              width: double.parse('200'), height: double.parse('200')));
    } else if (_image != null) {
      return Image.file(
        _image,
        width: 200,
        height: 100,
      );
    } else if ('0.0' != _uploadProcessPrecent) {
      return Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setHeight(100),
        // padding: EdgeInsets.only(left: 20),
        child: Text(_uploadProcessPrecent.toString()),
      );
    } else {
      return Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setHeight(100),
        // padding: EdgeInsets.only(left: 20),
        child: Text(''),
      );
    }
  }

  /// 获取七牛云的上传token
  void _getUploadToken() async {
    await request('getQiniuToken').then(
      (value) {
        uploadToken = value['result']['upToken'];
        LogUtils.debug(
            TAG, '七牛云图片上传的token: ${uploadToken}', StackTrace.current);
      },
    );
  }

  /// =========================
  /// 通过原生网络请求文件上传
  /// =========================
  _onUpload() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    setState(() {
      _image = File(file.path);
      url = '';
    });

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromFileSync(file.path, filename: _filename(file)),
      "token": uploadToken,
    });

    //上传文件
    await request('qiniuyunUrl', formData: formData).then((value) {
      LogUtils.debug(TAG, value, StackTrace.current);
      key = value['key'];
      setState(() {
        widget.onChangePic(key);
      });
    });
    // 通过key换取url
    await request('getUrlByKey', formData: {"key": key, "fileType": "Media"})
        .then((value) {
      LogUtils.debug(TAG, 'key换取的url为:${value}', StackTrace.current);
      setState(() {
        url = value;
      });
    });
  }

  /// ============================
  /// 通过七牛云插件进行文件上传
  /// ============================
  _onUploadBySyFlutterQiniuStorage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    setState(() {
      _image = File(file.path);
      url = '';
    });

    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double speed = percent * double.parse('100');
      LogUtils.debug(TAG, '上传进度为:${speed}%', StackTrace.current);
      setState(() {
        _uploadProcessPrecent = speed.toString();
      });
    });

    // 通过七牛云插件上传文件
    await syStorage
        .upload(file.path, uploadToken, _filename(file))
        .then((value) {
      LogUtils.debug(TAG, value, StackTrace.current);
      if (value.success == true) {
        var result = value.result;
        key = null != result ? result['hash'] : '';
      } else {
        LogUtils.error(TAG, '文件上传失败! 失败原因: ${value.error}', StackTrace.current);
        Toast.toast(
          context,
          msg: '文件上传失败! 失败原因: ${value.error}',
        );
      }
    });

    // 通过key换取url
    await request('getUrlByKey', formData: {"key": key, "fileType": "Media"})
        .then((value) {
      LogUtils.debug(TAG, 'key换取的url为:${value}', StackTrace.current);
      setState(() {
        url = value;
      });
    });
  }

  /// --------------------
  /// 生成时间戳格式的文件名
  /// --------------------
  String _filename(File file) {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        file.path.split('.').last;
  }

  //取消上传
  _onCancel() {
    SyFlutterQiniuStorage.cancelUpload();
  }
}
