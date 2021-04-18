import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/button_util.dart';
import 'work_model.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:lu_master/util/user_util.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';

/// 摄影作品详情页
///
class WorkInfoPage extends StatefulWidget {
  CompetitionWorkItemModel work;
  WorkInfoPage(CompetitionWorkItemModel work) : this.work = work;

  @override
  _WorkInfoPageState createState() => _WorkInfoPageState(work);
}

class _WorkInfoPageState extends State<WorkInfoPage> {
  CompetitionWorkItemModel work;
  UserModel user;
  _WorkInfoPageState(CompetitionWorkItemModel work) {
    this.work = work;
  }

  @override
  void initState() {
    _get_user_info();
  }

  void _get_user_info() async {
    UserModel user = await UserUtil.get_user_info();
    setState(() {
      this.user = user;
    });
  }

  void _addVote(CompetitionWorkItemModel item) async {
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

  Future<bool> sendDataToBackScreen() async{
    Navigator.pop(context, true);
return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: sendDataToBackScreen,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              this.work.subject,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            centerTitle: true,
            toolbarHeight: 40,
            backgroundColor: Colors.white, // status bar color
            brightness: Brightness.light, // status bar brightness
          ),
          body: Column(
            children: [
              this.user == null
                  ? Center(child: Text(Constant.LOADING_TEXT))
                  : Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                                child: Image.network(
                                  this.work.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(this.user.avatar_url),
                              ),
                              title: Text(this.user.nick_name),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                this.work.subject,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ButtonUtil.flatButton(Constant.VOTE_NAME, Colors.blue[200], () {
                _addVote(this.work);
              })
            ],
          ),
        ));
  }
}

Future<bool> _showMessage(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
