import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../util/select_text_item.dart';
import '../../config/constant.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Constant.ABOUT_PAGE_NAME),
      ),
      body: ListView(
        children: <Widget>[
          SelectTextItem(
            imageName: 'assets/images/lock.png',
            title: Constant.UPDATE_PASSWORD,
            onTap: () {
              Navigator.pushNamed(context, '/update_password',
                  arguments: Constant.UPDATE_PASSWORD);
            },
          ),
          SelectTextItem(
            title: '密保手机号',
            content: '131****3987',
            textAlign: TextAlign.end,
            contentStyle: new TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
            ),
          ),
          SelectTextItem(
            title: '消息通知',
          ),
          SelectTextItem(
            height: 35,
            title: '清空缓存',
            content: '1024k',
            isShowArrow: false,
            textAlign: TextAlign.end,
            contentStyle: new TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
            ),
          ),
          SelectTextItem(
            title: '意见反馈',
            content: '一个很长很长的内容一个很长很长的内容一个很长很长的内容一个很长很长的内容一个很长很长的内容',
          ),
        ],
      ),
    );
  }
}
