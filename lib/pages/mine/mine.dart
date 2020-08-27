import 'package:flutter/cupertino.dart';

/// @author sunxianglei
/// @date 2020/8/15
/// @desc

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }

}

class MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('mine'),
    );
  }

}