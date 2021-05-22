import 'package:flutter/material.dart';
import 'package:lu_master/util/select_text_item.dart';

/// 当前选中标签
/// 热门标签
/// 最多1个标签

class TagPage extends StatelessWidget {
  List<String> tags;
  TagPage(List<String> tags, String tag) {
    this.tags = tags;
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
