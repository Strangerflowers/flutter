// 资料认证页面
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../../images.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../service/service_method.dart';
// import 'package:city_pickers/city_pickers.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("资料认证"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _headerData(),
              AuthenticationForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerData() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _headerItemRow('资料认证状态', '未提交'),
          _headerItemRow('供养商编号', 'sdffsdf1234734'),
          _headerItemRow('公司名称', '俊翔音乐设备有限公司'),
          _headerItemRow('公司简称', '俊翔音乐'),
        ],
      ),
    );
  }

  Widget _headerItemRow(left, right) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      // margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(230),
            child: Text(
              left,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          ),
          Container(
            child: Text(
              right,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthenticationForm extends StatefulWidget {
  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  bool isSelect = false;
  final authFormKey = GlobalKey<FormState>();
  String username, password;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _selectItem('供应商类型', '12345'),
          _selectItem('公司地址', '2weded'),
          _addressItem('详细地址'),
          _componyPhoneItem('公司电话'),
          _componyNumberItem('营业执照编号'),
          ImagePickerPage(),
          _rangeItem('经营范围'),
          _bankOfDepositItem('开户银行'),
          _accountItem('开户账号'),
          _telItem('固定电话'),
          _codeItem('社会信用代码'),
          _contactsItem('联系人'),
          _mobiletItem('手机号码'),
        ],
      ),
    );
  }

  void _showSelect() async {
    print('点击弹窗类型选着框');
    Result result = await CityPickers.showCityPicker(
        context: context,
        cancelWidget: Text('取消', style: TextStyle(color: Colors.black54)),
        confirmWidget: Text("确定", style: TextStyle(color: Colors.blue)));
    print('result==$result');
    setState(() {
      // this.area =
      // "${result.provinceName}/${result.cityName}/${result.areaName}";
    });
  }

  // 下拉选择供应商类型
  Widget _selectItem(title, value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          InkWell(
            onTap: _showSelect,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xFFD7D7D7),
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  value.length > 0 ? value : '请选择',
                  style: TextStyle(
                      color:
                          value.length > 0 ? Colors.black : Color(0xFFD7D7D7)),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Color(0xFFD1D1D1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 输入详细地址
  Widget _addressItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "用户名或邮箱",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入详细地址";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入公司电话
  Widget _componyPhoneItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入营业执照编号
  Widget _componyNumberItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入经营范围
  Widget _rangeItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入开户银行
  Widget _bankOfDepositItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入开户账号
  Widget _accountItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入固定电话
  Widget _telItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入社会信用代码
  Widget _codeItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入联系人
  Widget _contactsItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 输入手机号码
  Widget _mobiletItem(title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(title)
            ],
          ),
          TextFormField(
            // keyboardType: TextInputType.phone,
            keyboardType: TextInputType.phone,
            maxLines: null, //不限制行数
            decoration: InputDecoration(
              // labelText: "用户名",
              hintText: "请输入",
              // prefixIcon: Icon(Icons.person),
            ),
            onSaved: (value) {
              this.username = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return "请输入";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  /// 待上传的图片列表
  List<Asset> _images = [];

  List<Asset> images = List<Asset>();
  String _error = 'No error Dectected';
  @override
  void initState() {
    super.initState();
  }
  // StreamController _imageListStreamCtrl = StreamController();
  // set _imageStream(List<Asset> list) {
  //   _imageList.addAll(list);
  //   _imageListStreamCtrl.sink.add(_imageList);
  // }

  // get _imageStream => _imageListStreamCtrl.stream;
  // @override
  // void dispose() {
  //   _imageListStreamCtrl.close();
  //   super.dispose();
  //   // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
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
          // buildGridView(),
          FloatingActionButton(
            onPressed: () {
              _multiImage();
            },
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          // GridView.count(
          //   padding: EdgeInsets.all(8),
          //   crossAxisCount: 3,
          //   mainAxisSpacing: 5,
          //   crossAxisSpacing: 5,
          //   shrinkWrap: true,
          //   children: _getImagesFromAsset(_images),
          // )
          // StreamBuilder(
          //   stream: _imageStream,
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) return Container();
          //     List<Asset> datas = snapshot.data;
          //     return ListView.builder(
          //       itemCount: datas.length,
          //       itemBuilder: (context, idx) {
          //         // return _imageTile(datas[idx]);
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  /// 图片上传
  Future<void> _multiImage() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9, // 最多9张图片
        enableCamera: true, // 允许使用照相机
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "图片上传",
          allViewTitle: "所有图片",
          //okButtonDrawable: 'OK',
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return; // 未挂载到widget树中
    setState(() {
      _images = resultList;
      print('****图片列表***' + resultList.toString());
    });
  }

  /// 从Asset中获取Image
  /// 返回List<AssetThumb>集合
  List<Widget> _getImagesFromAsset(List<Asset> assets) {
    // 没有选择图片
    if (assets.isEmpty) {
      return null;
    }
    print('图片集合$assets');
    return assets.map((asset) {
      return Container(
        width: 30,
        height: 30,
        child: AssetThumb(asset: asset, width: 150, height: 150),
      );
    }).toList();
  }

  // 调接口
  getImages() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No error Dectected';
    // 调本地接口
    // var data = {
    //   'token':
    //       'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwdGVzdCIsInVzZXJfbmFtZSI6InB0ZXN0IiwiX3VzZXJfbmFtZSI6ImhpbnMiLCJleHAiOjE1OTk5NzUwMzcsInVzZXJJZCI6IjBlMDhlMTUzYjA0YTExZTliMzFiYjA2ZWJmMTRhNDc2In0.lMd37OTGQ-TQB-fAT6II3d0Ckd62Xyf55YIcCt5QJkQ'
    // };

    // await request('getpictrueToken', formData: data).then(
    //   (value) {
    //     print('获取图片上传的token${value['upToken']}');
    //     var keys = {'token': value['upToken']};
    //     requestNoHeader('getKey', formData: data).then(
    //       (value) {
    //         print('获取图片上传的token$value');
    //       },
    //     );
    //   },
    // );

    // try {
    //   resultList = await MultiImagePicker.pickImages(
    //     maxImages: 300,
    //     enableCamera: true,
    //     selectedAssets: images,
    //     cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
    //     materialOptions: MaterialOptions(
    //       actionBarColor: "#abcdef",
    //       actionBarTitle: "Example App",
    //       allViewTitle: "All Photos",
    //       useDetailsView: false,
    //       selectCircleStrokeColor: "#000000",
    //     ),
    //   );
    //   print('图片上传成功$resultList');
    // } on Exception catch (e) {
    //   error = e.toString();
    //   print('图片上传错误');
    // }
    // if (!mounted) return;

    // setState(() {
    //   images = resultList;
    //   _error = error;
    //   print('获取本地图片后$images-----错误$_error');
    // });
  }
}

class _imageTile extends StatelessWidget {
  final Asset imageAsset;
  _imageTile(this.imageAsset);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          AssetThumb(asset: imageAsset, width: 100, height: 100),
          FutureBuilder(
            // ignore: deprecated_member_use
            // future: imageAsset.requestMetadata(),
            future: imageAsset.getByteData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              Metadata imageMatadata = snapshot.data;
              return Text('${imageMatadata.exif.artist}');
            },
          )
        ],
      ),
    );
  }
}

// class Test{
//   List<Asset> images = List<Asset>();

//   // 选择照片并上传
//   Future<void> uploadImages() async {
//     setState(() {
//       images = List<Asset>();
//     });
//     List<Asset> resultList;

//     try {
//       resultList = await MultiImagePicker.pickImages(
//         // 选择图片的最大数量
//         maxImages: 9,
//         // 是否支持拍照
//         enableCamera: true,
//         materialOptions: MaterialOptions(
//             // 显示所有照片，值为 false 时显示相册
//             startInAllView: true,
//             allViewTitle: '所有照片',
//             actionBarColor: '#2196F3',
//             textOnNothingSelected: '没有选择照片'
//         ),
//       );
//     } on Exception catch (e) {
//       e.toString();
//     }

//     if (!mounted) return;
//     images = (resultList == null) ? [] : resultList;
//     // 上传照片时一张一张上传
//     for(int i = 0; i < images.length; i++) {
//       // 获取 ByteData
//       ByteData byteData = await images[i].getByteData();
//       List<int> imageData = byteData.buffer.asUint8List();

//       MultipartFile multipartFile = MultipartFile.fromBytes(
//         imageData,
//         // 文件名
//         filename: 'some-file-name.jpg',
//         // 文件类型
//         contentType: MediaType("image", "jpg"),
//       );
//       FormData formData = FormData.fromMap({
//         // 后端接口的参数名称
//         "files": multipartFile
//       });
//       // 后端接口 url
//       String url = ''；
//       // 后端接口的其他参数
//       Map<String, dynamic> params = Map();
//       // 使用 dio 上传图片
//       var response = await dio.post(url, data: formData, queryParameters: params);
//       //
//       // do something with response...
//     }
//   }
// }
