import 'package:flutter/material.dart';
import 'package:lu_master/pages/test/test_page.dart';
import 'utils_test.dart';

class SharedPrefTest extends StatefulWidget {
  SharedPrefTest({Key key}) : super(key: key);

  @override
  _SharedPrefTestState createState() => _SharedPrefTestState();
}

class _SharedPrefTestState extends State<SharedPrefTest> {
  var futureUtils;
  @override
  void initState() {
    futureUtils = Utils.getSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureUtils,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return TestPage();
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text("数据加载中……",
                  style: TextStyle(fontSize: 20, color: Colors.orange)),
            ),
          );
        }
      },
    );
  }
}
