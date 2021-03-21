import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(
      appBar: AppBar(
          title: Text(
            Constant.BLANK_PAGE_NAME,
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          toolbarHeight: 40),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () => {Navigator.of(context).pop()},
        heroTag: 'blank',
      ),
      body: Container(
        child: Container(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                Text(
                  "请返回，此路不通。",
                  style: TextStyle(fontSize: 15),
                )
              ],
            )),
      ),
    ));
  }
}
