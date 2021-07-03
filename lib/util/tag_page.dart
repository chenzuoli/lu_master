import 'package:flutter/material.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/config/constant.dart';

/// 当前选中标签
/// 热门标签
/// 最多1个标签

class TagPage extends StatelessWidget {
  List<String> tags;
  TagPage(List<String> tags, String tag) {
    this.tags = tags;
  }

  static Future<String> get_tag_by_id(String tag_id) async {
    var tag_name = "";
    var params = {"tag_id": tag_id};
    var response = await DioUtil.get(
        Constant.TAG_NAME_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (response['status'] == 200) {
      tag_name = response['data'];
    }
    return tag_name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: this
            .tags
            .map((e) => SelectTextItem(
                  title: e,
                  isShowArrow: false,
                  onTap: () {
                    Navigator.pop(context, e);
                  },
                ))
            .toList(),
      ),
    );
  }
}
