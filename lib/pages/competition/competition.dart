import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import '../../util/dio_util.dart';
import 'competition_model.dart';
import 'package:http/http.dart' as http;
import 'competition_item_page.dart';
import '../../config/custom_route.dart';

class CompetitionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> {
  // http
  Future<CompetitionModel> fetchPost() async {
    final response = await http.get(Constant.PHOTOGRAPHY_LIST_URL);
    Utf8Decoder utf8decoder = Utf8Decoder(); //fix 中文乱码
    var result = json.decode(utf8decoder.convert(response.bodyBytes));
    return CompetitionModel.fromJson(result);
  }

  // dio
  Future<CompetitionModel> _getDataList() async {
    var result = await DioUtil.request(Constant.COMPETITION_LIST_URL,
        method: DioUtil.GET);
    print(result);
    CompetitionModel competitionModel = CompetitionModel.fromJson(result);
    return competitionModel;
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      //数据处理
      var data = snapshot.data;
      List<CompetitionItemModel> listData = (data.result as List).cast();

      return ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          CompetitionItemModel item = listData[index];
          return CompetitionItemPage(item);
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
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: new Text(Constant.COMPETITION_LIST_PAGE_NAME),
          ),
          // floatingActionButton: FloatingActionButton(
          //     child: Icon(Icons.arrow_back),
          //     onPressed: () => {Navigator.of(context).pop()}),
          body: new Container(
              child: FutureBuilder(
            builder: _buildFuture,
            future: _getDataList(),
          ))),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
