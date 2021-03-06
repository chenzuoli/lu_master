import 'package:flutter/material.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/config/constant.dart';

class FeedbackPage extends StatefulWidget {
  UserModel user;

  FeedbackPage(UserModel user) : this.user = user;

  @override
  _FeedbackPageState createState() => _FeedbackPageState(user);
}

class _FeedbackPageState extends State<FeedbackPage> {
  UserModel user;
  _FeedbackPageState(UserModel user) {
    this.user = user;
  }
  String _content;
  var futureUtils;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _PasswordPageState(UserModel user) {
    this.user = user;
  }

  @override
  void initState() {
    futureUtils = Util.getSharedPreferences();
    super.initState();
  }

  void _forSubmitted() async {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print(this.user.open_id);
      print(_content);
      await _updateNickName(this.user.open_id, _content);
    }
  }

  void _updateNickName(String name, String _content) async {
    var params = {"open_id": name, "content": _content};
    var response = await DioUtil.post(
        Constant.ADD_FEEDBACK_API, Constant.CONTENT_TYPE_FORM,
        data: params);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
    } else {
      Util.showShortLoading(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            Constant.FEEDBACK_PAGE_NAME,
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          toolbarHeight: 40),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _forSubmitted();
          Navigator.of(context).pop();
        },
        child: new Text('Submit'),
        heroTag: "feedback",
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                    labelText: 'Your Feedback Content',
                    labelStyle: TextStyle()),
                maxLines: 8,
                onSaved: (val) {
                  this._content = val;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
