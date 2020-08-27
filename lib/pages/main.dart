import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/classify/classify.dart';
import 'package:flutter_wanandroid/pages/home/home.dart';
import 'package:flutter_wanandroid/pages/mine/mine.dart';

/// @author sunxianglei
/// @date 2020/8/15
/// @desc

class Main extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<Main> with SingleTickerProviderStateMixin {
  final List<String> tabs = ['首页', '分类', '我的'];
  final List<IconData> icons = [Icons.home, Icons.list, Icons.person];
  TabController _tabController;
  List<Widget> _tabBarView = [
    HomePage(),
    ClassifyPage(),
    MinePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Android'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabBarView,
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black87,
        indicatorWeight: 0.1,
        tabs: [
          Tab(text: tabs[0], icon: Icon(Icons.home)),
          Tab(text: tabs[1], icon: Icon(Icons.list)),
          Tab(text: tabs[2], icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
