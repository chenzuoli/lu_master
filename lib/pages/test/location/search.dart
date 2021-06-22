import 'package:flutter/material.dart';
import 'map_choice_point.dart';

class LocationSearchPage extends StatefulWidget {
  String title;
  LocationSearchPage(this.title) {
    this.title = title;
  }
  @override
  _LocationSearcState createState() => _LocationSearcState(title);
}

class _LocationSearcState extends State<LocationSearchPage> {
  String title;
  _LocationSearcState(String title) {
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: Container(
          child: Center(child: MapChoicePoint((point) {
            debugPrint(point.toString());
          })),
        ));
  }
}
