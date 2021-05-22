import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget childWidget() {
  Widget childWidget = Stack(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.blueAccent,
            size: 30.0,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: Center(
          child: Text("加载中~~"),
        ),
      ),
    ],
  );
  return childWidget;
}

Widget showLoading(bool isShowLoading) {
  return Offstage(offstage: !isShowLoading, child: childWidget());
}
