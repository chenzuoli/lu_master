import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/select_card_item.dart';
import 'competition_model.dart';
import 'package:lu_master/util/dio_util.dart';
import 'info.dart';

class LatestCompetitionPage extends StatefulWidget {
  LatestCompetitionPage({Key key}) : super(key: key);

  @override
  _LatestCompetitionPageState createState() => _LatestCompetitionPageState();
}

class _LatestCompetitionPageState extends State<LatestCompetitionPage> {
  CompetitionItemModel work = null;

  @override
  void initState() {
    _getLatestCompetition();
    super.initState();
  }

  Future _getLatestCompetition() async {
    var response = await DioUtil.get(
        Constant.LATEST_COMPETITION_API, Constant.CONTENT_TYPE_JSON);
    if (response['status'] == 200) {
      setState(() {
        work = CompetitionItemModel.fromJson(response['data']);
      });
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return work == null
        ? Center(
            child: Text(Constant.LOADING_TEXT),
          )
        : SelectCardItem(
            img_url: work.img_url,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CompetitionInfoPage(item: work);
              }));
            },
          );
  }
}
