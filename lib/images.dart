// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:async';
// import 'package:multi_image_picker/multi_image_picker.dart';

// class ImagesPage extends StatefulWidget {
//   @override
//   _ImagesPageState createState() => _ImagesPageState();
// }

// class _ImagesPageState extends State<ImagesPage> {
//   List<Asset> _imageList = [];
//   StreamController _imageListStreamCtrl = StreamController();
//   set _imageStream(List<Asset> list) {
//     _imageList.addAll(list);
//     _imageListStreamCtrl.sink.add(_imageList);
//   }

//   get _imageStream => _imageListStreamCtrl.stream;
//   @override
//   void dispose() {
//     _imageListStreamCtrl.close();
//     super.dispose();
//     // super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: _imageStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Container();
//           List<Asset> datas = snapshot.data;
//           return ListView.builder(
//             itemCount: datas.length,
//             itemBuilder: (context, idx) {
//               return _imageTile(datas[idx]);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.image),
//       ),
//     );
//   }

//   getImages() async {
//     _imageStream = await MultiImagePicker.pickImages(maxImages: 1);
//   }
// }

// class _imageTile extends StatelessWidget {
//   final Asset imageAsset;
//   _imageTile(this.imageAsset);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           AssetThumb(asset: imageAsset, width: 100, height: 100),
//           FutureBuilder(
//             future: imageAsset.requestMetadata(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) return Container();
//               Metadata imageMatadata = snapshot.data;
//               return Text('${imageMatadata.exif.artist}');
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';
import 'package:bid/service/service_method.dart';

// void main() => runApp(new MyImage());

class MyImage extends StatefulWidget {
  @override
  _MyImageState createState() => new _MyImageState();
}

class _MyImageState extends State<MyImage> {
  double _process = 0.0;

  @override
  void initState() {
    _getUpdateToken();
    super.initState();
  }

  void _getUpdateToken() async {
    // 调本地接口
    var data = {
      'token':
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwdGVzdCIsInVzZXJfbmFtZSI6InB0ZXN0IiwiX3VzZXJfbmFtZSI6ImhpbnMiLCJleHAiOjE1OTk5NzUwMzcsInVzZXJJZCI6IjBlMDhlMTUzYjA0YTExZTliMzFiYjA2ZWJmMTRhNDc2In0.lMd37OTGQ-TQB-fAT6II3d0Ckd62Xyf55YIcCt5QJkQ'
    };
    print('获取七牛云同肯');
    await request('getpictrueToken').then(
      (value) {
        print('获取图片上传的token${value['upToken']}');
        var keys = {'token': value['upToken']};
        requestNoHeader('getKey', formData: data).then(
          (value) {
            print('获取图片上传的token$value');
          },
        );
      },
    );
  }

  _onUpload() async {
    Dio dio = new Dio();
    String token =
        "WrWenNoo1MR7n9ukB2WayIaOhkD9BU7ZJPjVcKn_:otjdGOWdpVNPEdOnHizgeVkDT5I=:eyJzY29wZSI6Im9zLXByZS1wcm9kIiwicmV0dXJuQm9keSI6IntcImtleVwiOiAkKGtleSksIFwiaGFzaFwiOiAkKGV0YWcpLCBcIndpZHRoXCI6ICQoaW1hZ2VJbmZvLndpZHRoKSwgXCJoZWlnaHRcIjogJChpbWFnZUluZm8uaGVpZ2h0KSxcImZzaXplXCI6JChmc2l6ZSl9IiwiZGVhZGxpbmUiOjE1OTk0MTcxMDB9";
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
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
      'token': token, // 上传前，向七牛云获取到的token
      // 'key': _key(file)
    });

    //上传文件
    // var formData = {file.path, token, _key(file)};
    var result = await dio.post('https://up-z2.qbox.me/', data: formData);
    // var result = await syStorage.upload(file.path, token, _key(file));
    print(result);
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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('七牛云存储SDK demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              LinearProgressIndicator(
                value: _process,
              ),
              RaisedButton(
                child: Text('上传'),
                onPressed: _onUpload,
              ),
              RaisedButton(
                child: Text('取消上传'),
                onPressed: _onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
