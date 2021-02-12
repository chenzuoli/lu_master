import 'package:flutter/material.dart';
import 'package:lu_master/pages/competition/competition_model.dart';
import 'info.dart';
import 'work_model.dart';

class CompetitionWorkItemPage extends StatefulWidget {
  CompetitionWorkItemModel item;
  CompetitionWorkItemPage(CompetitionWorkItemModel item) {
    this.item = item;
  }

  @override
  _CompetitionWorkItemPageState createState() =>
      _CompetitionWorkItemPageState(item);
}

class _CompetitionWorkItemPageState extends State<CompetitionWorkItemPage> {
  CompetitionWorkItemModel item;
  _CompetitionWorkItemPageState(CompetitionWorkItemModel item) {
    this.item = item;
  }

  Widget _listItemBuilder(CompetitionWorkItemModel item) {
    return ListTile(
        title: new Text(item.nick_name),
        leading: Image.network(item.url),
        subtitle: new Text(item.subject));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: _listItemBuilder(item),
        ),
        Divider()
      ],
    );
  }
}
