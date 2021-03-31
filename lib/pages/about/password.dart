import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/pages/about/user.dart';

class PasswordPage extends StatefulWidget {
  UserModel user;
  PasswordPage(UserModel user) : this.user = user;

  @override
  _PasswordPageState createState() => _PasswordPageState(user);
}

class _PasswordPageState extends State<PasswordPage> {
  UserModel user;

  _PasswordPageState(UserModel user) {
    this.user = user;
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _formFieldController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  String _name;
  String _password;
  String _conformPass;

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
      await _updatePassword(_name, _password);
    }
  }

  String _conformPassword(String value) {
    var password = passKey.currentState.value;
    if (value.length == 0) {
      return "Password is Required";
    } else if (value != password) {
      return 'Password is not matching';
    }
    return null;
  }

  void _updatePassword(String name, String password) async {
    var params = {"open_id": name, "pwd": password};
    var response = await DioUtil.post(
        Constant.UPDATE_PASSWORD_URL, Constant.CONTENT_TYPE_FORM,
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          Constant.PASSWORD_PAGE_NAME,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.white, // status bar color
        brightness: Brightness.light, // status bar brightness
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _forSubmitted();
          Navigator.of(context).pop();
        },
        child: Text('Submit'),
        heroTag: "password",
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: 1000,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                  readOnly: true,
                  initialValue: this.user == null ? "" : this.user.open_id,
                  onSaved: (val) {
                    this._name = val;
                  },
                ),
                TextFormField(
                  key: passKey,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onSaved: (val) {
                    this._password = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Comform Password',
                  ),
                  obscureText: true,
                  validator: _conformPassword,
                  onSaved: (val) {
                    this._conformPass = val;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
