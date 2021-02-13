import 'package:flutter/material.dart';
import '../../config/constant.dart';
import 'work_model.dart';
import 'work_like_comment.dart';
import '../../util/dio_util.dart';
import 'package:lu_master/util/util.dart';

class WorkPage extends StatefulWidget {
  WorkItemModel item;

  WorkPage(WorkItemModel item) : this.item = item;

  @override
  _WorkPageState createState() => _WorkPageState(this.item);
}

class _WorkPageState extends State<WorkPage> {
  WorkItemModel item;
  bool is_like;
  bool is_comment;
  _WorkPageState(WorkItemModel item) {
    this.item = item;
  }

  @override
  initState() {
    var open_id = Util.getString('open_id');
    this.is_like = _isLike(item, open_id);
    this.is_comment = _isComment(item, open_id);
  }

  bool _isLike(WorkItemModel item, dynamic open_id) {
    bool flag = false;
    List<WorkLikeCommentItemModel> comments = item.comments.result;
    if (comments == null) return flag;
    if (comments.length == 0) return flag;
    for (WorkLikeCommentItemModel comment in comments) {
      if (comment.open_id == open_id) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  bool _isComment(WorkItemModel item, dynamic open_id) {
    bool flag = false;
    List<WorkLikeCommentItemModel> comments = item.comments.result;
    if (comments == null) return flag;
    if (comments.length == 0) return flag;
    for (WorkLikeCommentItemModel comment in comments) {
      if (comment.open_id == open_id && comment.comment_id != null) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  void updateVote(bool is_vote, int photography_id, String open_id) async {
    Map<String, dynamic> params = {
      "photography_id": photography_id,
      "open_id": open_id
    };
    var result = await DioUtil.request(Constant.WORK_UPDATE_VOTE_API,
        method: DioUtil.POST, data: params);
    print(result);
  }

  void comment(
      int photography_id, String open_id, BigInt comment_id, String comment) async {
    Map<String, dynamic> params = {
      "photography_id": photography_id,
      "open_id": open_id,
      "comment_id": comment_id,
      "comment": comment
    };
    await DioUtil.request(Constant.WORK_COMMENT_API,
        data: params, method: DioUtil.POST);
  }

  void deleteComment(BigInt id) async {
    Map<String, dynamic> params = {"id": id};
    await DioUtil.request(Constant.WORK_DELETE_COMMENT_API,
        data: params, method: DioUtil.POST);
  }

  Widget _listItemBuilder(WorkItemModel item) {
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
          child: Image.network(
            item.url,
            fit: BoxFit.cover,
          ),
        ),
      ),
      ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.url),
        ),
        title: Text(item.nick_name),
        subtitle: Text(item.photographer),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(16.0),
        child: Text(
          item.subject,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ButtonBarTheme(
        data: ButtonBarThemeData(buttonTextTheme: ButtonTextTheme.accent),
        child: ButtonBar(
          buttonPadding: EdgeInsets.all(10),
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.favorite,
                color: is_like ? Colors.blue : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  is_like = !is_like;
                  updateVote(is_like, item.id, item.open_id);
                });
              },
            ),
            FlatButton(
              child: Icon(
                Icons.chat_bubble,
                color: is_comment ? Colors.blue : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  is_comment = !is_comment;
                });
              },
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _listItemBuilder(this.item));
  }
}
