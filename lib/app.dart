import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/home/home.dart';
import 'package:flutter_wanandroid/pages/main.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.

  void init(){
    LogUtil.init(isDebug: true);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      title: 'Flutter Android',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(),
      routes: {
        "main": (context) => Main(),
        "home": (context) => HomePage(),
      },
    );
  }
}
