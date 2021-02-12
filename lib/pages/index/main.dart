import 'package:flutter/material.dart';
import 'package:lu_master/pages/index/index.dart';
import 'package:lu_master/config/constant.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Constant.APP_NAME),
      ),
      bottomNavigationBar: new Index(),
    );
  }
}