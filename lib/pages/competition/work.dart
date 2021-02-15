import 'package:lu_master/pages/competition/competition_model.dart';
import 'work_model.dart';
import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'work_item_page.dart';

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
    var result = await DioUtil.get(
        Constant.COMPETITION_WORK_LIST_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    print(result);
    CompetitionWorkModel workModel = CompetitionWorkModel.fromJson(result);
    return workModel;
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      //数据处理
      var data = snapshot.data;
      List<CompetitionWorkItemModel> listData = (data.result as List).cast();

      return ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          CompetitionWorkItemModel item = listData[index];
          return CompetitionWorkItemPage(item);
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
