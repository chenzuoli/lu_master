import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:lu_master/pages/share/share_miniprogram.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/pages/photograpier/work_like_comment.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/util/tag_page.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'work_model.dart';
import 'package:lu_master/util/w_share.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class CommentPage extends StatefulWidget {
  WorkItemModel item;

  CommentPage(WorkItemModel item) {
    this.item = item;
  }

  @override
  _CommentPageState createState() => _CommentPageState(item);
}

class _CommentPageState extends State<CommentPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  bool flag = false;
  WorkItemModel item;
  Widget page;
  String _comment;
  Map<int, Tuple2<bool, bool>> status = Map();
  String tag_name;

  _CommentPageState(WorkItemModel item) {
    this.item = item;
  }

  @override
  void initState() {
    super.initState();
    getComments(item);
    _getTagInfo(this.item.tag_id);
    _initFluwx();
  }

  void _getTagInfo(tag_id) async {
    var tag_name = await TagPage.get_tag_by_id(tag_id);
    setState(() {
      this.tag_name = tag_name;
    });
  }

  static dynamic _getShareModel(ShareType shareType, ShareInfo shareInfo) {
    var scene = fluwx.WeChatScene.SESSION;
    switch (shareType) {
      case ShareType.SESSION:
        scene = fluwx.WeChatScene.SESSION;
        break;
      case ShareType.TIMELINE:
        scene = fluwx.WeChatScene.TIMELINE;
        break;
      case ShareType.COPY_LINK:
        break;
      case ShareType.DOWNLOAD:
        break;
    }

    if (shareInfo.img != null) {
      return fluwx.WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        thumbnail: fluwx.WeChatImage.network(shareInfo.img),
        scene: scene,
      );
    } else {
      return fluwx.WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        scene: scene,
      );
    }
  }

  final List<ShareOpt> list = [
    ShareOpt(
        title: '微信',
        img: 'dep/images/icon_wechat.jpg',
        shareType: ShareType.SESSION,
        doAction: (shareType, shareInfo) async {
          var model = _getShareModel(shareType, shareInfo);
          fluwx.shareToWeChat(model);
        }),
    ShareOpt(
        title: '朋友圈',
        img: 'dep/images/icon_wechat_moments.jpg',
        shareType: ShareType.TIMELINE,
        doAction: (shareType, shareInfo) {
          var model = _getShareModel(shareType, shareInfo);
          fluwx.shareToWeChat(model);
        }),
    ShareOpt(
        title: '复制',
        img: 'dep/images/icon_copy.png',
        shareType: ShareType.COPY_LINK,
        doAction: (shareType, shareInfo) {}),
    ShareOpt(
        title: '链接',
        img: 'dep/images/icon_copylink.png',
        shareType: ShareType.COPY_LINK,
        doAction: (shareType, shareInfo) {
          if (shareType == ShareType.COPY_LINK) {
            ClipboardData data = ClipboardData(text: shareInfo.url);
            Clipboard.setData(data);
          }
        }),
  ];

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  _initFluwx() async {
    await fluwx.registerWxApi(
        appId: Data.wxAppId,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    var result = await fluwx.isWeChatInstalled;
    print("is installed $result");
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

          // 作品主题内容
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(16.0),
            height: 80,
            // 可选择的文本
            child: SelectableText(
              item.subject,
              maxLines: 200,
              scrollPhysics: ClampingScrollPhysics(),
            ),
          ),

          // 标签
          (this.tag_name != "" && this.tag_name != null)
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(16.0),
                  height: 80,
                  // 可选择的文本
                  child: SelectableText(
                    (this.tag_name != "" && this.tag_name != null)
                        ? "# " + this.tag_name
                        : "",
                    style: TextStyle(color: Colors.blue),
                    maxLines: 200,
                    scrollPhysics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),

          // 分享按钮
          // _shareComment(),

          // RaisedButton(
          //     child: Text("分享"),
          //     onPressed: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (context) {
          //         return ShareMiniProgramPage();
          //       }));
          //     }),

          // 评论
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
            setState(() {
              getComments(item);
            });
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
                  child: textField(0, Constant.WORK_COMMENT_DESC),
                  padding: EdgeInsets.all(7),
                );
              });
        },
      ),
      height: 50,
    );
  }

  Widget _shareComment() {
    return IconButton(
      icon: Icon(Icons.share),
      color: Colors.black,
      onPressed: () {
        showModalBottomSheet(
            /**
                 * showModalBottomSheet常用属性
                 * shape 设置形状
                 * isScrollControlled：全屏还是半屏
                 * isDismissible：外部是否可以点击，false不可以点击，true可以点击，点击后消失
                 * backgroundColor : 设置背景色
                 */
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return ShareWidget(
                // ShareInfo(this.item.subject, this.item.url,
                //     img: this.item.url, describe: "分享内容"),
                ShareInfo(this.item.subject,
                    Constant.SHARE_MOMENTS_URL + this.item.id.toString(),
                    img: this.item.url, describe: "分享内容"),
                list: this.list,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomAppBar(
        child: bottomNewCommentButton(),
      ),
      appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            Constant.WORK_COMMENT_PAGE_NAME,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: Colors.white, // status bar color
          brightness: Brightness.light, // status bar brightness
          actions: [_shareComment()]),
      body: flag
          ? this.page
          : Center(
              child: Text("加载中..."),
            ),
    );
  }
}
