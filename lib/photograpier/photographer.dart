import 'package:flutter/material.dart';

class PhotographerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PhotographerPage();
}

class _PhotographerPage extends State<PhotographerPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("摄影师"),
          actions: <Widget>[new Container()],
        ),
        body: new Center(
          child: null,
        ),
      ),
    );
  }
}
