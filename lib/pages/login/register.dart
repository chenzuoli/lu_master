import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/loading.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/dio_util.dart';

// 用户注册，默认给一个nick_name、avatar_url
// nick_name: 用户+时间戳
// avatar_url: http://cdn.pipilong.pet/Cat.png   http://cdn.pipilong.pet/dog2.png

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  String _userID;
  String _password;
  String _conformPassword;
  bool _isChecked = true;
  bool _isLoading;
  bool _autoValidate;
  IconData _checkIcon = Icons.check_box;

  @override
  void initState() {
    Util.getSharedPreferences();
    super.initState();
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
  }

  void _onRegister(BuildContext context) {
    final form = _formKey.currentState;
    form.save();

    if (_userID == '') {
      Util.showMessageDialog(context, '账号不可为空');
      return;
    }
    if (_password == '') {
      Util.showMessageDialog(context, '密码不可为空');
      return;
    }
    if (!_isChecked) {
      Util.showMessageDialog(context, "请查看服务条例与隐私协议");
      return;
    }
    _registerRequest(_userID, _password).then((value) => {
          if (value['status'] == 200)
            {
              Util.showShortLoading("注册成功"),
              // Navigator.pushNamed(context, '/main'),
              Navigator.pushNamedAndRemoveUntil(
                  context, "/main", (route) => false),
              Util.preferences.setString("open_id", _userID),
              Util.preferences.setString('token', value['data']),
              Data.open_id = _userID,
              Data.token = value['data']
            }
          else
            {Util.showMessageDialog(context, value['message'])}
        });
  }

  Future _registerRequest(String userId, String pwd) async {
    var current_timestamp = DateTime.now().millisecondsSinceEpoch;
    var nick_name = Constant.DEFAULT_NICK_NAME + current_timestamp.toString();
    var avatar_url = Constant.DEFAULT_AVATAR_URL;
    var params = {
      "open_id": userId,
      "password": pwd,
      "nick_name": nick_name,
      "avatar_url": avatar_url
    };
    var result = await DioUtil.post(
        Constant.REGISTER_APP_USER_URL, Constant.CONTENT_TYPE_JSON,
        data: params);
    return result;
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '请输入帐号',
              icon: Icon(
                Icons.email,
                color: Colors.grey,
              )),
          onSaved: (value) => _userID = value.trim()),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        key: passKey,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => this._password = value.trim(),
      ),
    );
  }

  Widget _confirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        validator: validatePasswordMatching,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请确认密码',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => this._conformPassword = value.trim(),
      ),
    );
  }

  String validatePasswordMatching(String value) {
    var password = passKey.currentState.value;
    if (value.length == 0) {
      return "Password is Required";
    } else if (value != password) {
      return 'Password is not matching';
    }
    return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      //Make a REST Api Call with success Go to Login Page after User Created.

      _formKey.currentState.save();
      showLoading(true);

      // Util.checkConnection().then((connectionResult) {
      //   if (connectionResult) {
      //   } else {
      //     showLoading(false);
      //     Util.showMessageDialog(context,
      //         "Internet is not connected. Please check internet connection.");
      //   }
      // });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String _loginwx() {
    // var response = fluwx.registerWxApi(universalLink: "");
    // fluwx.responseFromAuth.listen((response) {
    //   //监听授权登录回调
    //   print("code: " + response.code);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: routes,
        onGenerateRoute: onGenerateRoute,
        home: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                Constant.REGISTER_PAGE_NAME,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              centerTitle: true,
              toolbarHeight: 40,
              backgroundColor: Colors.white, // status bar color
              brightness: Brightness.light, // status bar brightness
            ),
            body: ListView(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 16 / 9, //控制子元素的宽高比
                    child: Image.network(
                      Constant.DEFAULT_IMAGE_URL,
                      fit: BoxFit.cover,
                    )),
                Padding(padding: EdgeInsets.only(top: 30)),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          _showEmailInput(),
                          Divider(
                            height: 0.5,
                            indent: 16.0,
                            color: Colors.grey[300],
                          ),
                          _showPasswordInput(),
                          Divider(
                            height: 0.5,
                            indent: 16.0,
                            color: Colors.grey[300],
                          ),
                          _confirmPasswordInput(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(80, 30, 80, 0),
                  child: OutlineButton(
                    child: Text(Constant.REGISTER_PAGE_NAME),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    onPressed: () {
                      showLoading(true);
                      _validateInputs();
                      _onRegister(context);
                    },
                  ),
                ),
                // Row(children: <Widget>[
                //   Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                //   Expanded(child: Divider()),
                //   Text(
                //     " OR ",
                //     style: TextStyle(color: Colors.grey),
                //   ),
                //   Expanded(child: Divider()),
                // ]),
                // Column(
                //   children: [
                //     GestureDetector(
                //       child: Image.asset("dep/images/wechat.png"),
                //       onTap: () {
                //         _loginwx();
                //       },
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 50, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(_checkIcon),
                          color: Colors.orange,
                          onPressed: () {
                            setState(() {
                              _isChecked = !_isChecked;
                              if (_isChecked) {
                                _checkIcon = Icons.check_box;
                              } else {
                                _checkIcon = Icons.check_box_outline_blank;
                              }
                            });
                          }),
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: '我已经详细阅读并同意',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                children: <TextSpan>[
                              TextSpan(
                                  text: '《隐私政策》',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                    child:
                                                        SingleChildScrollView(
                                                  child: Text(
                                                      Data.privacy_content),
                                                ));
                                              })
                                        }),
                              TextSpan(text: '和'),
                              TextSpan(
                                  text: '《用户协议》',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                    child:
                                                        SingleChildScrollView(
                                                  child: Text(
                                                      Data.service_content),
                                                ));
                                              })
                                        })
                            ])),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
