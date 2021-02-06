import 'package:flutter/material.dart';
import 'package:lu_master/util/select_text_item.dart';
import '../../config/constant.dart';
// 搜索框
// 联系人，标签，群聊，点击显示所有该分类的联系人
// 单个联系人
// 单击某个联系人，页面右滑进入聊天窗口

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(Constant.CONTACT_PAGE_NAME)),
        body: Container(
          child: ListView(
            padding: EdgeInsets.only(top: 20),
            children: <Widget>[
              SelectTextItem(title: "消息"),
              SelectTextItem(title: "联系人"),
              SelectTextItem(title: "标签"),
              SelectTextItem(title: "群聊"),
            ],
          ),
        ),
      ),
    );
  }
}
