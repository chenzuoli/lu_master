import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:tuple/tuple.dart';
import 'work_model.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/pages/photograpier/work_like_comment.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/util/util.dart';

class CommentPage extends StatefulWidget {
  WorkItemModel item;

  CommentPage(WorkItemModel item) {
    this.item = item;
  }

  @override
  _CommentPageState createState() => _CommentPageState(item);
}

class _CommentPageState extends State<CommentPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormFieldState> _fieldKey = new GlobalKey<FormFieldState>();

  bool flag = false;
  WorkItemModel item;
  Widget page;
  String _comment;
  Map<int, Tuple2<bool, bool>> status = Map();

  _CommentPageState(WorkItemModel item) {
    this.item = item;
  }

  @override
  void initState() {
    super.initState();
    getComments(item);
  }

  void _forSubmitted(int comment_id) {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      comment(this.item.id, comment_id, _fieldKey.currentState.value);
    }
  }

  void comment(int photography_id, int comment_id, String comment) async {
    // 评论人
    String open_id = Util.preferences.getString("open_id");
    Map<String, dynamic> params = {
      "photography_id": photography_id,
      "open_id": open_id,
      "comment_id": comment_id,
      "comment": comment
    };
    Map result = await DioUtil.post(
        Constant.WORK_COMMENT_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (result['status'] == 200) {
      Util.showShortLoading(result['data']);
      setState(() {
        this.status[comment_id] = Tuple2(
            !this.status[comment_id].item1, this.status[comment_id].item2);
      });
    } else {
      Util.showShortLoading(result['msg']);
    }
  }

  void deleteComment(BigInt id) async {
    Map<String, dynamic> params = {"id": id};
    await DioUtil.post(
        Constant.WORK_DELETE_COMMENT_API, Constant.CONTENT_TYPE_JSON,
        data: params);
  }

  Future<List<WorkLikeCommentItemModel>> request_comment(
      WorkItemModel item) async {
    var params = {"photography_id": item.id, "open_id": item.open_id};
    print("request comment params: " + params.toString());
    var comments = await DioUtil.get(
        Constant.WORK_LIKE_COMMENT_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    WorkLikeCommentModel workLikeCommentModel =
        WorkLikeCommentModel.fromJson(comments);
    item.comments = workLikeCommentModel;
    return workLikeCommentModel.result;
  }

  static void addCommentVote(
      bool is_vote, int photography_id, String open_id, int comment_id) async {
    Map<String, dynamic> params = {
      "is_vote": is_vote,
      "photography_id": photography_id,
      "open_id": open_id,
      "comment_id": comment_id
    };
    var result = await DioUtil.post(
        Constant.COMMENT_ADD_LIKE_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (result['status'] == 200) {
      Util.showShortLoading(result['data']);
    } else {
      Util.showShortLoading(result['message']);
    }
  }

  Future<Map<int, UserModel>> request_users(
      List<WorkLikeCommentItemModel> comments) async {
    Map<int, UserModel> users = {};
    for (WorkLikeCommentItemModel comment in comments) {
      var userModel = await UserModel.requestUserInfo(comment.open_id);
      users[comment.id] = userModel;
    }
    return users;
  }

  void _initStatus(List<WorkLikeCommentItemModel> comments) {
    for (WorkLikeCommentItemModel comment in comments) {
      this.status[comment.id] = Tuple2(false, false);
    }
  }

  Future<Widget> getComments(WorkItemModel item) async {
    Widget res;
    // 获取评论
    var comments = await request_comment(item);
    // 获取评论用户信息
    var users = await request_users(comments);

    // 初始化like comment状态
    _initStatus(comments);

    // 过滤只点赞的数据
    comments = item.filterNoComment(comments);
    res = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Column(children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
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
          SelectTextItem(
            title: Constant.WORK_COMMENT_PAGE_NAME,
            isShowArrow: false,
            titleStyle: TextStyle(fontSize: 20),
          ),
          comments.length == 0
              ? Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      Constant.WORK_COMMENT_EMPTY_CONTENT,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                )
              : Column(
                  children: comments.map((comment) {
                    return Container(
                        child: Row(
                      children: [
                        Container(
                          width: 250,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(users[comment.id].avatar_url),
                            ),
                            title: Text(users[comment.id].nick_name),
                            subtitle: Text(comment.comment),
                          ),
                        ),
                        Expanded(child: SizedBox()), //自动扩展挤压
                        IconButton(
                            icon: Icon(Icons.favorite),
                            color: this.status[comment.id].item1
                                ? Colors.blue
                                : Colors.grey[400],
                            onPressed: () {
                              addCommentVote(status[comment.id].item1, item.id,
                                  item.open_id, comment.id);
                              setState(() {
                                this.status[comment.id] = Tuple2(
                                    !this.status[comment.id].item1,
                                    this.status[comment.id].item2);
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.chat_bubble),
                            color: this.status[comment.id].item1
                                ? Colors.blue
                                : Colors.grey[400],
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      // 评论某个人的评论，comment_id为此评论的id
                                      // @某人
                                      child: textField(comment.id,
                                          '@' + users[comment.id].nick_name),
                                      padding: EdgeInsets.all(7),
                                    );
                                  });
                            })
                      ],
                    ));
                  }).toList(),
                )
        ])));
    setState(() {
      flag = true;
      page = res;
    });
    return res;
  }

  Row textField(int comment_id, String hintText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: Form(
          key: _formKey,
          child: TextFormField(
            key: _fieldKey,
            decoration: InputDecoration(
              hintText: hintText, //提示文字
              border: null,
              focusedBorder: UnderlineInputBorder(
                //输入框被选中时的边框样式
                borderSide: BorderSide(color: Colors.blue[300]),
              ),
            ),
            keyboardType: TextInputType.text, //键盘的类型
            maxLength: 250, //最多字数
            maxLines: 10,
            onSaved: (val) {
              this._comment = val;
            }, //最高行数
          ),
        )),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            // comment this photography work.
            _forSubmitted(comment_id);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Container bottomNewCommentButton() {
    return Container(
      child: OutlineButton(
        child: Text(Constant.WORK_COMMENT_BTN_NAME,
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        color: Colors.blue[300],
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // 评论作品，作品的comment_id为0
                  child: textField(0, 'Say something here...'),
                  padding: EdgeInsets.all(7),
                );
              });
        },
      ),
      height: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: bottomNewCommentButton(),
      ),
      appBar: AppBar(
          title: Text(
            Constant.WORK_COMMENT_PAGE_NAME,
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          toolbarHeight: 40),
      body: flag
          ? this.page
          : Center(
              child: Text("加载中..."),
            ),
    );
  }
}
