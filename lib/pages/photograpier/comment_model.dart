import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'work_model.dart';

class CommentPage extends StatefulWidget {
  WorkItemModel item;

  CommentPage(WorkItemModel item) {
    this.item = item;
  }

  @override
  _CommentPageState createState() => _CommentPageState(item);
}

class _CommentPageState extends State<CommentPage> {
  WorkItemModel item;
  _CommentPageState(WorkItemModel item) {
    this.item = item;
  }

  Widget getComments(WorkItemModel item) {
    print("评论为：");
    print(item.comments.result);
    return ClipRRect(
      child: Column(children: []),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Constant.WORK_COMMENT_PAGE_NAME)),
        body: FlatButton(
          child: getComments(item),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return Container(
                      child: SingleChildScrollView(
                    child: getComments(item),
                  ));
                });
          },
        ));
  }
}
