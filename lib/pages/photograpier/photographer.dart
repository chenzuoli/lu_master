import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lu_master/util/httputil.dart';
import 'package:lu_master/config/constant.dart';

class PhotographerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PhotographerPage();
}

class _PhotographerPage extends State<PhotographerPage> {
  bool is_like = false;
  bool is_comment = false;

  List<Widget> _getData() {
    print(is_like);
    print(is_comment);
    Icon like = Icon(
      Icons.favorite_border,
      color: is_comment ? Colors.blue : Colors.black,
    );
    Icon comment = Icon(
      Icons.chat_bubble_outline,
      color: is_comment ? Colors.blue : Colors.black,
    );
    var list = new List<Widget>();
    void _asyncData() {
      HttpUtil.get(Constant.PHOTOGRAPHY_LIST_URL, success: (value) {
        print(value);
      }, failure: (error) {
        print(error);
      }).then((result) {
        List data = json.decode(result)['data'];
        data.forEach((item) {
          print(item['nick_name']);
          list.add(
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    child: Image.network(
                      item['url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item['url']),
                  ),
                  title: Text(item['nick_name']),
                  subtitle: Text(item['photographer']),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    item['subject'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ButtonBarTheme(
                  data: ButtonBarThemeData(
                      buttonTextTheme: ButtonTextTheme.accent),
                  child: ButtonBar(
                    buttonPadding: EdgeInsets.all(10),
                    children: <Widget>[
                      FlatButton(
                        child: like,
                        onPressed: () {
                          setState(() {
                            is_like = !is_like;
                          });
                        },
                      ),
                      FlatButton(
                        child: comment,
                        onPressed: () {
                          setState(() {
                            is_comment = !is_comment;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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
          title: new Text("撸大师"),
          actions: <Widget>[new Container()],
        ),
        body: new Center(
          child: FutureBuilder(
            initialData: _getData(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Column bean = (snapshot.data)[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: InkWell(
                      child: bean,
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
