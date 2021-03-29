import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/pages/competition/work_info.dart';
import 'work_model.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';

class CompetitionWorkItemPage extends StatefulWidget {
  CompetitionWorkItemModel item;
  CompetitionWorkItemPage(CompetitionWorkItemModel item) {
    this.item = item;
  }

  @override
  _CompetitionWorkItemPageState createState() =>
      _CompetitionWorkItemPageState(item);
}

class _CompetitionWorkItemPageState extends State<CompetitionWorkItemPage> {
  CompetitionWorkItemModel item;
  bool isLike = false;
  _CompetitionWorkItemPageState(CompetitionWorkItemModel item) {
    this.item = item;
  }

  void _addVote() async {
    var param = {"id": item.id, "votes": item.votes + 1};
    var response = await DioUtil.post(
        Constant.UPDATE_VOTES_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
    } else {
      Util.showShortLoading(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                      title: Text(item.nick_name),
                      leading: Image.network(item.url),
                      subtitle: Text(item.subject)),
                ),
                onTap: () {
                  // 跳转到比赛作品详情页
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return WorkInfoPage(item);
                  }));
                },
              ),
            ),
            SizedBox(
              width: 120,
              child: FlatButton(
                  child: Icon(
                    Icons.favorite,
                    color: isLike ? Colors.blue : Colors.grey[400],
                  ),
                  onPressed: () {
                    setState(() {
                      isLike = !isLike;
                      _addVote();
                    });
                  }),
            )
          ],
        ),
        Divider()
      ],
    );
  }
}
