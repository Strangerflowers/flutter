import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../../provide/demand_quotation/demand_quotation_provide.dart';
import '../../../provide/demand_detail_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectSkul extends StatefulWidget {
  final skulList;
  SelectSkul(this.skulList);

  @override
  _SelectSkulState createState() => _SelectSkulState();
}

class _SelectSkulState extends State<SelectSkul> {
  var result;
  var goodsItem;
  var skugoodsItem;
  List<String> skuldataList;
  List skulObjectData = new List(); //在该数组存放规格对应商品信息；
  void initState() {
    skuldataList = [];
    result = widget.skulList;
    goodsItem = widget.skulList.subjectItemList[0];
    goodsItem.skuList.forEach((ele) {
      var valueArr = [];

      ele.items.forEach((subele) {
        valueArr.add(subele.value);
      });
      var obj = {
        'id': ele.id,
        "skul": valueArr.join(',').replaceAll(",", "-"),
        "skulgood": ele,
        "price": ele.price,
      };
      skulObjectData.add(obj);
      return skuldataList.add(valueArr.join(',').replaceAll(",", "-"));
    });
    print('skulObjectData$skulObjectData');
  }

  int currentIndex = 0;
  bool isSelect = false;
  // var list = skuldataList;
  var list = [
    'Hamilton1',
    'Lafayette1',
    '1米',
    'Mulligan1',
    'Laurens1',
    '黑-1米',
    '白-1米'
  ];
  List<String> selectedItemsList = List(); //存放选中的规格
  String showSelectItem; //展示最后确定的规格
  @override
  Widget build(BuildContext context) {
    // print('规格选择页面${goodsItem.skuList}');
    return Provide<DemandQuotationProvide>(builder: (context, child, val) {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.all(20),
        // height: ScreenUtil().setHeight(70),
        width: ScreenUtil().setWidth(750),
        child: InkWell(
          onTap: () {},
          child: _select(goodsItem, context),
          // child: _growView(),
        ),
      );
    });
  }

  // 合并商品
  Widget _mergeItem(goodsItem) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(120),
            padding: EdgeInsets.only(top: 0, right: 10),
            // child: Image.network(goodsItem.image),
            child: Image.asset('images/icon.png'),
          ),
          Expanded(
            child: _right(goodsItem),
          ),
        ],
      ),
    );
  }

  // 左侧商品
  Widget _right(goodsItem) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      // width: ScreenUtil().setWidth(750),
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      goodsItem.name,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, 1);
                      },
                      child: Icon(
                        IconData(0xebd2, fontFamily: 'iconfont'),
                        color: Color(0xFF999DA0),
                      ),
                    ),
                  ),
                ],
              )),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     '库存  999999',
          //     maxLines: 2,
          //   ),
          // ),
          Row(
            children: <Widget>[
              Text(
                '${goodsItem.priceRange}',
                style: TextStyle(color: Color(0xFFF0B347)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet(goodsItem, context) {
    return showModalBottomSheet<int>(
      context: context,
      // isScrollControlled: false,
      builder: (context) => GestureDetector(
        child: Container(
          height: ScreenUtil().setHeight(700),
          child: Column(
            children: <Widget>[
              _mergeItem(skugoodsItem == null ? goodsItem : skugoodsItem),
              Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.bottomLeft,
                height: ScreenUtil().setHeight(40),
                child: Text(
                  '规格',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      height: ScreenUtil().setHeight(400),
                      child: MultiSelectChip(
                        skuldataList,
                        // list,
                        showSelectItem,
                        onSelectionChanged: (selectedList) {
                          // selectedList选中的规格
                          print('单选的回调$selectedList');
                          setState(() {
                            selectedItemsList = selectedList;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 20,
                    left: 20,
                    child: FlatButton(
                      //自定义按钮颜色
                      color: Color(0xFF2A83FF),
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.blue,
                      child: Text("确定"),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        setState(() {
                          showSelectItem = selectedItemsList.join('');
                        });
                        skulObjectData.forEach((element) {
                          if (element['skul'] == showSelectItem) {
                            result.goodsPrice =
                                double.parse(element['price'].toString());
                            return result.specificaId = element['id'];
                          }
                        });
                        // 选择规格时给一个默认的价格
                        double price = result.goodsPrice / 100;
                        Provide.value<DemandDetailProvide>(context)
                            .changeGoodsPrice(price, result.specificaId);
                        Navigator.pop(context, 1);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onVerticalDragStart: (_) {},
      ),
      isDismissible: false,
      isScrollControlled: false,
      // isScrollControlled: true,
    );
  }

  Widget _select(goodsItem, context) {
    return Container(
      child: InkWell(
        onTap: () async {
          int type = await _showModalBottomSheet(goodsItem, context);
        },
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Text('规格'),
            ),
            Expanded(
              child: Container(
                child:
                    Text('${showSelectItem == null ? '请选择' : showSelectItem}'),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            // RaisedButton(
            //   child: Text("显示底部菜单列表"),
            //   onPressed: () async {
            //     int type = await _showModalBottomSheet(context);
            //     print(type);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

// 单独写一个管理状态的组件
class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  String selectItem;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, this.selectItem, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();

  int selectIndex = 0;

  _buildChoiceList() {
    List<Widget> choices = List();
    print('${widget.selectItem == null}===${widget.selectItem}}');
    if (widget.selectItem != null) {
      setState(() {
        selectedChoices.add(widget.selectItem);
        widget.selectItem = null;
      });
    }

    // if (selectedChoices1 != []) {}
    widget.reportList.forEach((item) {
      choices.add(Container(
        // alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            selectedChoices = [];
            setState(() {
              if (selectedChoices.contains(item)) {
                selectedChoices.remove(item);
              } else {
                selectedChoices = [];
                selectedChoices.add(item);
              }
              print('object$selectedChoices');
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
