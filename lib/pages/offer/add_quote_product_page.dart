import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import './checkbox.dart';
import './add_quote_area/add_quote_bottom.dart';
import './add_quote_area/add_quote_body.dart';

class AddQuoteProductPage extends StatelessWidget {
  final String id;
  AddQuoteProductPage(this.id);
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF242526),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '报价',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF242526),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            //隐藏键盘
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            // 失去焦点
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 80),
                  constraints: BoxConstraints(
                    // minWidth: 180,
                    minHeight: MediaQuery.of(context).size.height - 126,
                  ),
                  child: AddQuoteBody(),
                ),
              ),
              Positioned(
                bottom: -5,
                left: 0,
                right: 0,
                child: AddQuoteBottom(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
