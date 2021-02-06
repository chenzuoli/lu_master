import 'package:flutter/material.dart';
import 'package:lu_master/pages/competition/competition_model.dart';
import 'add.dart';
import '../../config/constant.dart';

/*
name作为appbar
主题作为一篇文章的标题
比赛条件链接形式
参赛作品按照列表形式展示，提供投票、评论、查看作者、联系作者等功能；

添加一个add按钮，跳转到编辑作品页面，编辑作品页面添加比赛注意事项链接
*/

class CompetitionInfoPage extends StatelessWidget {
  CompetitionItemModel item;
  CompetitionInfoPage({this.item});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(Constant.COMPETITION_INFO_NAME),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddWorkPage();
                    }))
                  }),
          body: Column(
            children: [
              Center(
                child: Image.network(item.img_url),
              ),
              Card(
                child: Text(item.name),
              ),
              Card(
                child: Text(item.subject),
              ),
              Card(
                child: Text(item.start_date),
              ),
              Card(
                child: Text(item.end_date),
              ),
            ],
          )),
    );
  }
}
