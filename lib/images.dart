import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';
import 'package:bid/service/service_method.dart';

// void main() => runApp(new MyImage());

class MyImage extends StatefulWidget {
  var businessLicenseIssuedKey;
  final String url;
  MyImage(this.businessLicenseIssuedKey, this.url, @required this.onChangePic);

  final ValueChanged<String> onChangePic;
  @override
  _MyImageState createState() => new _MyImageState();
}

class _MyImageState extends State<MyImage> {
  double _process = 0.0;
  File _image;
  String updateToken;
  String key;
  String url;
  @override
  void initState() {
    key = widget.businessLicenseIssuedKey;
    url = widget.url;
    // _getUpdateToken();
    super.initState();
  }

  @override
  void dispose() {
    widget.businessLicenseIssuedKey = key;
    super.dispose();
  }

  void _getUpdateToken() async {
    print('获取七牛云同肯');
    await request('getpictrueToken').then(
      (value) {
        updateToken = value['upToken'];
        print('获取图片上传的token${value['upToken']}');
        // var keys = {'token': value['upToken']};
        // requestNoHeader('getKey', formData: data).then(
        //   (value) {
        //     print('获取图片上传的token$value');
        //   },
        // );
      },
    );
  }

  _onUpload() async {
    Dio dio = new Dio();
    String token = updateToken;

    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    setState(() {
      _image = File(file.path);
      url = '';
    });
    // print('拿到的本地图片$_image');
    // print('上传图片返回信息${file.toString().substring(5)}===$_image');
    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double p = percent;
      setState(() {
        _process = p;
      });
      print(percent);
    });

    FormData formData = FormData.fromMap({
      "file": file.path,
      'token': updateToken, // 上传前，向七牛云获取到的token
      // 'key': _key(file)
    });

    //上传文件
    print('获取参数${updateToken}');
    // var formData = {file.path, token, _key(file)};
    await dio.post('https://up-z2.qbox.me/', data: formData).then((value) {
      setState(() {
        key = value.data['key'];
        widget.onChangePic(key);
        // widget.businessLicenseIssuedKey =result
      });
      print(key);
    });
    // var result = await syStorage.upload(file.path, token, _key(file));
  }

  String _key(File file) {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        file.path.split('.').last;
  }

  //取消上传
  _onCancel() {
    SyFlutterQiniuStorage.cancelUpload();
  }

  @override
  Widget build(BuildContext context) {
    print('网络图片${url}');
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
                  child: url == ''
                      ? _image == null
                          ? Container(
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setHeight(100),
                              // padding: EdgeInsets.only(left: 20),
                              child: Text(''),
                            )
                          : Image.file(
                              _image,
                              width: 200,
                              height: 100,
                            )
                      : Image.network(
                          url,
                          width: 200,
                          height: 100,
                        ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _getUpdateToken();
                    _onUpload();
                    // _multiImage();
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

  Widget _picture() {
    if (url == null) {
      return Container(
        width: 200,
        height: 200,
        child: url == ''
            ? _image == null ? Text('') : Image.file(_image)
            : Image.network(url),
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        child: Image.network(url),
      );
    }
  }
}
