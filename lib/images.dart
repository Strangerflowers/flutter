import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  List<Asset> _imageList = [];
  StreamController _imageListStreamCtrl = StreamController();
  set _imageStream(List<Asset> list) {
    _imageList.addAll(list);
    _imageListStreamCtrl.sink.add(_imageList);
  }

  get _imageStream => _imageListStreamCtrl.stream;
  @override
  void dispose() {
    _imageListStreamCtrl.close();
    super.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _imageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          List<Asset> datas = snapshot.data;
          return ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, idx) {
              return _imageTile(datas[idx]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.image),
      ),
    );
  }

  getImages() async {
    _imageStream = await MultiImagePicker.pickImages(maxImages: 1);
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
            future: imageAsset.requestMetadata(),
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
