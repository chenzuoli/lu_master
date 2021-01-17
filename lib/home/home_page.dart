import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lu_master/util/httputil.dart';
import 'package:lu_master/config/constant.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _getData() {
    var list = new List<Widget>();
    void _asyncData() {
      HttpUtil.get(Constant.COMPETITION_LIST_URL, success: (value) {
        print(value);
      }, failure: (error) {
        print(error);
      }).then((result) {
        List data = json.decode(result)['data'];
        data.forEach((item) {
          print(item['name']);
          list.add(ListTile(
              title: new Text(item['name']),
              leading: Image.network(item['img_url']),
              subtitle: new Text(item['subject'])));
        });
        log("获取比赛数据完成");
      });
    }

    _asyncData();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("首页"),
              actions: <Widget>[new Container()],
            ),
            // body: new ListView(
            //   children: this._getData(),
            // )),
            body: new Center(
              child: FutureBuilder(
                initialData: _getData(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final ListTile bean = (snapshot.data)[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        child: InkWell(
                          // child: FadeInImage.assetNetwork(
                          //   image: ,
                          //   placeholder: "images/loading.gif",
                          // ),
                          child: bean,
                          onTap: () {},
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                },
              ),
            )));
  }
}
