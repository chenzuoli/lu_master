import 'package:lu_master/pages/photograpier/add_photography.dart';
import 'work_model.dart';
import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'work.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/util.dart';

/// 资讯
class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  var futureUtil;
  @override
  void initState() {
    super.initState();
  }

  // dio
  Future<WorkModel> _getDataList() async {
    await Util.getSharedPreferences();
    var result = await DioUtil.get(
        Constant.PHOTOGRAPHY_LIST_API, Constant.CONTENT_TYPE_JSON);
    WorkModel workModel = WorkModel.fromJson(result);
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
        appBar: AppBar(
          title: Text(
            Constant.MASTER_PAGE_NAME,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: Colors.white, // status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: Container(
              child: FutureBuilder(
            builder: _buildFuture,
            future: _getDataList(),
          )),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: 'photographies',
            onPressed: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddPhotographyPage();
                  })).then((value) {
                    setState(() {}); // 返回到此页面时，刷新页面
                  })
                }),
      ),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
