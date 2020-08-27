import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/home/home.dart';
import 'package:flutter_wanandroid/pages/main.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Android',
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
