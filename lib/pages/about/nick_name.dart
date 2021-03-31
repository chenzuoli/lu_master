import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';
import 'user.dart';

class NickNamePage extends StatefulWidget {
  UserModel user;
  NickNamePage(UserModel user) : this.user = user;

  @override
  _PasswordPageState createState() => _PasswordPageState(user);
}

class _PasswordPageState extends State<NickNamePage> {
  UserModel user;
  String _name;
  String _newName;

  TextEditingController _controller = new TextEditingController();
  TextEditingController _formFieldController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _PasswordPageState(UserModel user) {
    this.user = user;
  }

  @override
  void initState() {
    _controller.value = new TextEditingValue(text: 'Hello');
    _formFieldController.addListener(() {
      print('listener');
    });
    Util.getSharedPreferences();
    super.initState();
  }

  void _forSubmitted() async {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      await _updateNickName(this.user.open_id, _newName);
    }
  }

  void _updateNickName(String name, String _newName) async {
    var params = {"open_id": name, "nick_name": _newName};
    var response = await DioUtil.post(
        Constant.UPDATE_NICKNAME_API, Constant.CONTENT_TYPE_FORM,
        data: params);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
    } else {
      Util.showShortLoading(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            Constant.NICKNAME_PAGE_NAME,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: Colors.white, // status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _forSubmitted();
            Navigator.of(context).pop();
          },
          child: new Text('Submit'),
          heroTag: "nick_name",
        ),
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Your Name',
                      ),
                      readOnly: true,
                      initialValue: this.user.nick_name),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Your New Name',
                    ),
                    onSaved: (val) {
                      this._newName = val;
                    },
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}
