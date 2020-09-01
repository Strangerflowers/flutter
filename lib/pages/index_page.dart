import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'purchasing_demand/purchasing_demand.dart';
import 'personal_center/personal_center.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // tabbar数组
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('需求'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person),
      title: Text('个人中心'),
    )
  ];
  final List<Widget> tabBodies = [
    PurchasingDemand(),
    PersonalCenter(),
  ];
  int currentIndex = 0;
  var currentPage;
  // 初始化展示首页
  @override
  void initState() {
    // TODO: implement initState
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 初始化设计尺寸
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
