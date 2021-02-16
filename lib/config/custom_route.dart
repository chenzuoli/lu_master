import 'package:flutter/material.dart';
import 'package:lu_master/pages/about/nick_name.dart';
import 'package:lu_master/pages/competition/choose_img.dart';
import 'package:lu_master/pages/login/login.dart';
import 'package:lu_master/pages/about/password.dart';
import 'package:lu_master/pages/competition/info.dart';
import 'package:lu_master/pages/index/main.dart';

//配置路由
final routes = {
  "/main": (context, {argument}) => MainPage(),
  "/update_password": (context, {arguments}) => PasswordPage(),
  "/update_nick_name": (context, {arguments}) => NickNamePage(arguments),
  "/competition_info": (context, {arguments}) => CompetitionInfoPage(),
  "/register": (context, {arguments}) => LoginPage(),
  "/choose_img": (context, {arguments}) => ChooseImg()
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  print("name  ---->  " + name);
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
