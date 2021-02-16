import 'package:flutter/material.dart';
import 'setting_page.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/util.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    Util.getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingPage(),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
