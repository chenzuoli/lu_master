import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static SharedPreferences preferences;
  static SharedPreferences sharedPreferences;

  static Future<void> getSharedPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }

  static Future checkConnection() async {
    bool flag = false;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        flag = true;
      } else if (result == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        flag = true;
      }
    });
    return flag;
  }

  static void showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('提示'),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("好的"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showAlert(BuildContext context, String content) async {
    bool isSelect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("温馨提示"),
          //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
          //默认底部边距 如果 content 不为null 则底部内边距为0
          //            如果 content 为 null 则底部内边距为20
          titlePadding: EdgeInsets.all(10),
          //标题文本样式
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
          //中间显示的内容
          content: Text(content),
          //中间显示的内容边距
          //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
          contentPadding: EdgeInsets.all(10),
          //中间显示内容的文本样式
          contentTextStyle: TextStyle(color: Colors.black54, fontSize: 14),
          //底部按钮区域
          actions: <Widget>[
            TextButton(
              child: Text("再考虑一下"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("考虑好了"),
              onPressed: () {
                //关闭 返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    print("弹框关闭 $isSelect");
  }

  static void showShortLoading(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue[300],
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static Future<SharedPreferences> _getInstance() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }
    return sharedPreferences;
  }

  /*
   * 利用SharedPreferences存储数据
   */
  static Future saveString(String key, String value) async {
    sharedPreferences = await _getInstance();
    sharedPreferences.setString(key, value);
  }

  /*
   * 获取存在SharedPreferences中的数据
   */
  static Future getString(String key) async {
    String v;
    await _getInstance().then((value) {
      v = value.get(key);
    });
    return v;
  }
  


}
