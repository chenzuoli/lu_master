import 'package:flutter/material.dart';
import 'add.dart';

/*
name作为appbar
主题作为一篇文章的标题
比赛条件链接形式
参赛作品按照列表形式展示，提供投票、评论、查看作者、联系作者等功能；

添加一个add按钮，跳转到编辑作品页面，编辑作品页面添加比赛注意事项链接
*/

class CompetitionInfoPage extends StatefulWidget {
  CompetitionInfoPage({Key key}) : super(key: key);

  @override
  _CompetitionInfoPageState createState() => _CompetitionInfoPageState();
}

class _CompetitionInfoPageState extends State<CompetitionInfoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("比赛名次"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddWorkPage();
                  }))
                }),
        body: Container(
          child: Text("比赛详情"),
        ),
      ),
    );
  }
}

class CompetitionContent {
  String competition_id;
  String name;
  String subject;
  String condition;
  String start_date;
  String end_date;
  String img_url;
  CompetitionContent(String competition_id, String name, String subject,
      String condition, String start_date, String end_date, String img_url) {
    this.competition_id = competition_id;
    this.name = name;
    this.subject = subject;
    this.condition = condition;
    this.start_date = start_date;
    this.end_date = end_date;
    this.img_url = img_url;
  }
  Widget conditionWidget(String condition) {
    return Container();
  }
}
