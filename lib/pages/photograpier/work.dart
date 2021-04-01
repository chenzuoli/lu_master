import 'package:flutter/material.dart';
import 'package:lu_master/pages/photograpier/comment_model.dart';
import 'package:lu_master/config/constant.dart';
import 'work_model.dart';
import 'work_like_comment.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/util/user_util.dart';
import 'package:lu_master/pages/about/user.dart';

class WorkPage extends StatefulWidget {
  WorkItemModel item;

  WorkPage(WorkItemModel item) : this.item = item;

  @override
  _WorkPageState createState() => _WorkPageState(this.item);
}

class _WorkPageState extends State<WorkPage> {
  WorkItemModel item;
  bool is_like = false;
  bool is_comment = false;
  UserModel user;

  _WorkPageState(WorkItemModel item) {
    this.item = item;
  }

  @override
  initState() {
    super.initState();
    Util.getSharedPreferences();
    var open_id = Util.preferences.getString('open_id');
    // this.is_like = _isLike(item, open_id);
    // this.is_comment = _isComment(item, open_id);
    _getUserInfo(this.item.open_id);
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

  static void updateVote(
      bool is_vote, int photography_id, String open_id) async {
    Map<String, dynamic> params = {
      "is_vote": is_vote,
      "photography_id": photography_id,
      "open_id": open_id
    };
    var result = await DioUtil.post(
        Constant.WORK_ADD_LIKE_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (result['status'] == 200) {
      Util.showShortLoading(result['data']);
    } else {
      Util.showShortLoading(result['message']);
    }
  }

  void _getUserInfo(String open_id) async {
    UserModel user = await UserUtil.get_user_info_by_id(open_id);
    setState(() {
      this.user = user;
    });
  }

  Widget _listItemBuilder(WorkItemModel item) {
    return this.user == null
        ? Container(child: Text(""))
        : Column(children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                child: GestureDetector(
                  child: Image.network(
                    item.url,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CommentPage(item);
                    }));
                  },
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(this.user.avatar_url),
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
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CommentPage(item);
                      }));
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
