import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lu_master/pages/about/feedback/feedback_page.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'user.dart';
import 'package:lu_master/util/util.dart';
import 'nick_name.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModel user;

  @override
  void initState() {
    super.initState();
    _getDataList();
  }

  // dio
  Future<Map> _getDataList() async {
    await Util.getSharedPreferences();
    var param = {"open_id": Util.preferences.getString("open_id")};
    print("params: " + param.toString());
    var result = await DioUtil.get(
        Constant.USER_INFO_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    print("result: " + result.toString());
    setState(() {
      print("state: " + result['data'].toString());
      this.user = UserModel.fromJson(result['data']);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Constant.ABOUT_PAGE_NAME),
      ),
      body: this.user == null
          ? Center(
              child: Text("加载中..."),
            )
          : ListView(
              children: <Widget>[
                SelectTextItem(
                    title: this.user.nick_name,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return NickNamePage(user);
                      }));
                    }),
                SelectTextItem(
                  imageName: 'assets/images/lock.png',
                  title: Constant.PASSWORD_PAGE_NAME,
                  onTap: () {
                    Navigator.pushNamed(context, '/update_password',
                        arguments: Constant.PASSWORD_PAGE_NAME);
                  },
                ),
                SelectTextItem(title: '消息通知', onTap: () {}),
                SelectTextItem(
                    title: '意见反馈',
                    content: '说说你的意见，我们帮你改进！',
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FeedbackPage(user);
                      }));
                    }),
              ],
            ),
    );
  }
}
