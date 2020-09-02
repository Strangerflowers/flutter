import 'package:bid/common/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class WithdrawAddress extends StatelessWidget {
  final _itemList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: 接口请求后台数据
    _itemList.add('1111');
    _itemList.add('2222');
    _itemList.add('3333');

    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildItemList(),
    );
  }

  /**
   * 构建导航栏
   */
  _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      centerTitle: true,
      title: const Text(
        '退货地址',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
            child: Text(
              "添加退货地址",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: _addRecieveAddr)
      ],
    );
  }

  /** 
   * 添加退货地址
   */
  void _addRecieveAddr() {
    LogUtils.d('[添加退货地址]', '被点击!');
  }

  /** 
     * 构建列表项行数据
     */
  Widget _buildRow(Object item) {
    LogUtils.d('[构建列表项行数据]', item);
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        children: [
          // 将Column（列）放入Expanded中会拉伸该列以使用该行中的所有剩余空闲空间。
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    '刘德华  18911112222',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  '广东省广州市天河区科技大道198号优托邦购物中心A座19楼',
                  style: new TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ),
          ),
          new Image.asset(
            'images/edit.png',
            width: 20.0,
            height: 20.0,
          ),
        ],
      ),
    );
  }

  /** 
   * 构建列表项
   */
  Widget _buildItemList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 列表项的数量，如果为null，则为无限列表。
        //itemCount: itemList.length,
        itemBuilder: (context, i) {
          LogUtils.d('[构建列表项]', sprintf('原始i:%s', [i]));
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际列表项数量
          //
          //             item  Divider  item   Divider  item
          //页面元素序号    0      1      2        3       4
          //index          0             1                2
          final index = i ~/ 2;
          LogUtils.d('index', index);
          // 如果是建议列表中最后一个单词对
          if (index >= _itemList.length) {
            // TODO: 请求接口拿数据,追加到_itemList数组内
            LogUtils.d('[构建列表项][index >= itemList.length]', '重新发起请求!');
            return Text('');
          } 
          // 在偶数行，该函数会为单词对添加一个ListTile row.
          // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
          // 注意，在小屏幕上，分割线看起来可能比较吃力。
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();
          LogUtils.d('=======>', sprintf('%s - 是否为奇数:%s',[i, i.isOdd]));
          return _buildRow(_itemList[index]);
        });
  }
}
