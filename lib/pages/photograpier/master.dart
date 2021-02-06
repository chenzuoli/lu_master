import 'dart:convert';
import 'package:lu_master/pages/photograpier/work_like_comment.dart';

import 'work_model.dart';
import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:http/http.dart' as http;
import 'work.dart';
import '../../config/custom_route.dart';

/// 资讯
class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  // http
  Future<WorkModel> fetchPost() async {
    final response = await http.get(Constant.PHOTOGRAPHY_LIST_URL);
    Utf8Decoder utf8decoder = Utf8Decoder(); //fix 中文乱码
    var result = json.decode(utf8decoder.convert(response.bodyBytes));
    return WorkModel.fromJson(result);
  }

  // dio
  Future<WorkModel> _getDataList() async {
    var result = await DioUtil.request(Constant.PHOTOGRAPHY_LIST_API,
        method: DioUtil.GET);
    print(result);
    WorkModel workModel = WorkModel.fromJson(result);
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
    return MaterialApp(
      home: Scaffold(
          appBar: new AppBar(
            title: Text(Constant.MASTER_PAGE_NAME),
          ),
          body: Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5)
            ),
            child: Container(
                child: FutureBuilder(
              builder: _buildFuture,
              future: _getDataList(),
            )),
          )),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
