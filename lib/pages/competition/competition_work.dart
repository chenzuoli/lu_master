import 'package:lu_master/pages/competition/competition_model.dart';
import 'package:lu_master/pages/photograpier/work_like_comment.dart';

import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'competition_work_model.dart';

/// 资讯
class CompetitionWorkPage extends StatefulWidget {
  CompetitionItemModel competition;
  CompetitionWorkPage(CompetitionItemModel competition) {
    this.competition = competition;
  }
  @override
  _CompetitionWorkPageState createState() =>
      _CompetitionWorkPageState(competition);
}

class _CompetitionWorkPageState extends State<CompetitionWorkPage> {
  CompetitionItemModel competition;
  _CompetitionWorkPageState(CompetitionItemModel competition) {
    this.competition = competition;
  }
  // dio
  Future<CompetitionWorkModel> _getDataList() async {
    Map param = {"competition_id": competition.competition_id};
    var result = await DioUtil.request(Constant.COMPETITION_WORK_LIST_URL,
        method: DioUtil.GET, data: param);
    print(result);
    CompetitionWorkModel workModel = CompetitionWorkModel.fromJson(result);
    for (WorkItemModel workItemModel in workModel.result) {
      var params = {
        "photography_id": workItemModel.id,
        "open_id": workItemModel.open_id
      };
      var comments = await DioUtil.request(Constant.WORK_LIKE_COMMENT_API,
          data: params, method: DioUtil.GET);
      print(comments);
      WorkLikeCommentModel workLikeCommentModel =
          WorkLikeCommentModel.fromJson(comments);
      workItemModel.comments = workLikeCommentModel;
      workLikeCommentModel.printInfo();
    }
    print(workModel.result);
    return workModel;
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      //数据处理
      var data = snapshot.data;
      List<WorkItemModel> listData = (data.result as List).cast();

      return ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          WorkItemModel item = listData[index];
          return WorkPage(item);
        },
        itemCount: listData.length,
      );
    }
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createListView(context, snapshot);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Container(
          child: FutureBuilder(
        builder: _buildFuture,
        future: _getDataList(),
      )),
    );
  }
}
