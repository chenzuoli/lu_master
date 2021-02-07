import 'package:flutter/material.dart';
import 'package:lu_master/pages/competition/competition_model.dart';
import 'info.dart';

class CompetitionWorkItemPage extends StatefulWidget {
  CompetitionItemModel item;
  CompetitionWorkItemPage(CompetitionItemModel item) {
    this.item = item;
  }

  @override
  _CompetitionWorkItemPageState createState() => _CompetitionWorkItemPageState(item);
}

class _CompetitionWorkItemPageState extends State<CompetitionWorkItemPage> {
  CompetitionItemModel item;
  _CompetitionWorkItemPageState(CompetitionItemModel item) {
    this.item = item;
  }

  Widget _listItemBuilder(CompetitionItemModel item) {
    return ListTile(
      title: new Text(item.name),
      leading: Image.network(item.img_url),
      subtitle: new Text(item.subject),
      onTap: () {
        // Navigator.pushNamed(context, "/competition_info",
        //     arguments: {"item": item});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CompetitionInfoPage(item: item);
        }));
      },
    );
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
