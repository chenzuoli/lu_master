import 'package:flutter/material.dart';
import 'package:lu_master/pages/login/login.dart';
import '../pages/about/password.dart';
import '../pages/competition/info.dart';

//配置路由
final routes = {
  "/update_password": (context, {arguments}) => PasswordPage(),
  "/competition_info": (context, {arguments}) => CompetitionInfoPage(),
  "/register": (context, {arguments}) => LoginPage(),
  
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
