import 'package:flutter/cupertino.dart';

/// @author sunxianglei
/// @date 2020/8/15
/// @desc

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('home'),
    );
  }
}