import 'package:flutter/material.dart';
import './checkbox.dart';
import './add_quote_area/add_quote_bottom.dart';
import './add_quote_area/add_quote_body.dart';

class AddQuoteProductPage extends StatelessWidget {
  final String id;
  AddQuoteProductPage(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('报价'),
      ),
      body: Stack(
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
    );
  }
}
