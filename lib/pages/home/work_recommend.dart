import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/pages/competition/work_model.dart';
import 'package:lu_master/pages/competition/work_info.dart';

class WorkRecommend extends StatefulWidget {
  double width;
  WorkRecommend(double width) {
    this.width = width;
  }

  @override
  _WorkRecommendState createState() => _WorkRecommendState(this.width);
}

class _WorkRecommendState extends State<WorkRecommend> {
  Map<int, List<Widget>> dataList;
  double width;

  _WorkRecommendState(double width) {
    this.width = width;
  }

  @override
  void initState() {
    _getDataList();
  }

  void _getDataList() async {
    var params = {"num": 10};
    var response = await DioUtil.get(
        Constant.RECOMMEND_WORK_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (response['status'] == 200) {
      setState(() {
        this.dataList = _rowSplit(_worksWidget(response));
      });
    }
  }

  List<Widget> _worksWidget(Map<String, dynamic> response) {
    CompetitionWorkModel workModel = CompetitionWorkModel.fromJson(response);
    List<Widget> listWidget = List();
    for (CompetitionWorkItemModel work in workModel.result) {
      listWidget.add(Container(
        child: Card(
          margin: EdgeInsets.all(10),
          child: GestureDetector(
            child: Column(
              children: [
                AspectRatio(
                    aspectRatio: 16 / 9, //控制子元素的宽高比
                    child: Image.network(
                      work.url,
                      fit: BoxFit.cover,
                    )),
                ListTile(
                  title: Text(work.nick_name),
                  subtitle: Text(
                    work.subject,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            onTap: () {
              // 跳转到比赛作品详情页
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WorkInfoPage(work);
              }));
            },
          ),
        ),
      ));
    }
    return listWidget;
  }

  Map<int, List<Widget>> _rowSplit(List<Widget> listWidget) {
    Map<int, List<Widget>> map = Map();
    List<Widget> rowFirst = List();
    List<Widget> rowSecond = List();
    List.generate(listWidget.length, (index) {
      Widget val = listWidget[index];
      if (index % 2 == 0) {
        rowFirst.add(val);
      } else
        rowSecond.add(val);
    });
    map.putIfAbsent(1, () => rowFirst);
    map.putIfAbsent(2, () => rowSecond);
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return dataList == null
        ? Center(child: Text(Constant.LOADING_TEXT))
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(children: this.dataList[1])),
                  Expanded(child: Column(children: this.dataList[2])),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "已经到底啦...",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          );
  }
}
