
import 'package:flutter/material.dart';
import 'package:lu_master/pages/competition/competition.dart';
import 'package:lu_master/pages/blank/blank.dart';

class ServiceBotton extends StatelessWidget {
  String name;
  String url;
  ServiceBotton(String name, String url) {
    this.name = name;
    this.url = url;
  }

  Widget picAndTextButton(String imgpath, String text, BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            image:
                DecorationImage(image: NetworkImage(imgpath), fit: BoxFit.fill),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(20),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                if (this.name == "摄影比赛") {
                  return CompetitionPage();
                } else {
                  return BlankPage();
                }
              }));
            },
            child: Text(
              text,
              style: TextStyle(fontSize: 15),
            ),
            color: Colors.transparent,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: AspectRatio(
        aspectRatio: 16 / 3,
        child: Opacity(
          opacity: 1,
          child: this.picAndTextButton(this.url, this.name, context),
        ),
      ),
    );
  }
}
