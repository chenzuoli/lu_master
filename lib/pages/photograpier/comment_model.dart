import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
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

  _CommentPageState(WorkItemModel item) {
    this.item = item;
  }

  @override
  void initState() {
    super.initState();
    getComments(item);
  }

  void _forSubmitted() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      comment(this.item.id, "0", _fieldKey.currentState.value);
    }
  }

  void comment(int photography_id, String comment_id, String comment) async {
    // 评论人
    String open_id = Util.preferences.getString("open_id");
    Map<String, dynamic> params = {
      "photography_id": photography_id,
      "open_id": open_id,
      "comment_id": comment_id,
      "comment": comment
    };
    print("评论为：" + params.toString());
    Map result = await DioUtil.post(
        Constant.WORK_COMMENT_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (result['status'] == '200') {
      Util.showShortLoading(result['data']);
      Navigator.of(context).pop();
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
    print("get comment params: " + params.toString());
    var comments = await DioUtil.get(
        Constant.WORK_LIKE_COMMENT_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    WorkLikeCommentModel workLikeCommentModel =
        WorkLikeCommentModel.fromJson(comments);
    item.comments = workLikeCommentModel;
    workLikeCommentModel.printInfo();
    return workLikeCommentModel.result;
  }

  Widget getComments(WorkItemModel item) {
    Widget res;
    request_comment(item).then((comments) {
      // 过滤只点赞的数据
      comments = item.filterNoComment(comments);
      res = Column(
        children: [
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
          Column(
            children: comments.map((comment) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.url),
                    ),
                    title: Text(comment.comment),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          ),
        ],
      );
      setState(() {
        flag = true;
        page = res;
      });
    });
    return res;
  }

  Row textField() {
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
              hintText: 'Say something here...', //提示文字
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
            _forSubmitted();
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
                  child: textField(),
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
        appBar: AppBar(title: Text(Constant.WORK_COMMENT_PAGE_NAME)),
        body: FlatButton(
          child: flag
              ? page
              : Center(
                  child: Text("加载中..."),
                ),
          onPressed: () {
            // showModalBottomSheet<void>(
            //     context: context,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(20),
            //         topRight: Radius.circular(20),
            //       ),
            //     ),
            //     builder: (BuildContext context) {
            //       return Container(
            //           child: SingleChildScrollView(
            //         child: getComments(item),
            //       ));
            //     });
          },
        ));
  }
}
