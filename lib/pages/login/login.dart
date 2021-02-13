import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'register.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/util/dio_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _userID;
  String _password;
  bool _isChecked = true;
  bool _isLoading;
  IconData _checkIcon = Icons.check_box;

  void _changeFormToLogin() {
    _formKey.currentState.reset();
  }

  void _onLogin(BuildContext context) {
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
    _loginAction(_userID, _password).then((value) => {
          if (value['status'] == 200)
            {
              Util.showShortLoading("注册成功"),
              Navigator.pushNamed(context, '/main'),
              Util.saveString("open_id", _userID),
              Util.saveString('token', value['data'])
            }
          else
            {Util.showMessageDialog(context, value['message'])}
        });
  }

  Future _loginAction(String userId, String pwd) async {
    var params = {"open_id": userId, "pwd": pwd};
    // var result = await DioUtil.request(Constant.REGISTER_APP_API,
    //     method: DioUtil.POST, data: params);
    var result = await DioUtil.post(Constant.LOGIN_APP_URL, params);
    return result;
  }

  void _onRegister(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegisterPage();
    }));
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入帐号',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onSaved: (value) => _userID = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  String _loginwx() {
    var response = fluwx.registerWxApi(universalLink: "");
    // fluwx.responseFromAuth.listen((response) {
    //   //监听授权登录回调
    //   print("code: " + response.code);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.blue,
          middle: const Text(Constant.LOGIN_PAGE_NAME),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: 220,
              child: Image(image: AssetImage('assets/images/disneyland.jpeg')),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Form(
              key: _formKey,
              child: Container(
                height: 130,
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
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(80, 30, 80, 0),
              child: OutlineButton(
                child: Text(Constant.LOGIN_PAGE_NAME),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.black, width: 1),
                onPressed: () {
                  _onLogin(context);
                },
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
                  _onRegister(context);
                },
              ),
            ),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
              Expanded(child: Divider()),
              Text(
                " OR ",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(child: Divider()),
            ]),
            Column(
              children: [
                GestureDetector(
                  child: Image.asset("assets/images/wechat.png"),
                  onTap: () {
                    print("点击了微信");
                    _loginwx();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 50, 0),
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: <TextSpan>[
                          TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                          TextSpan(text: '和'),
                          TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline))
                        ])),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
