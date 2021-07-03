import 'package:flutter/material.dart';
import 'utils_test.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    Utils.preferences.setString("data", "str");
    String data = Utils.preferences.getString("data");
    print(data);
    Utils.preferences.setString("data", "abc");
    data = Utils.preferences.getString("data");
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Test")));
  }
}
