import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget childWidget() {
  Widget childWidget = new Stack(
    children: <Widget>[
      new Padding(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
        child: new Center(
          child: SpinKitFadingCircle(
            color: Colors.blueAccent,
            size: 30.0,
          ),
        ),
      ),
      new Padding(
        padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: new Center(
          child: new Text("加载中~~"),
        ),
      ),
    ],
  );
  return childWidget;
}

Widget showLoading(bool isShowLoading) {
  return Offstage(offstage: !isShowLoading, child: childWidget());
}
