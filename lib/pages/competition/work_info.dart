import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/button_util.dart';
import 'package:lu_master/util/tag_page.dart';
import 'work_model.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:lu_master/util/user_util.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/util/util.dart';
import 'package:lu_master/util/w_share.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

/// 摄影作品详情页
///
class WorkInfoPage extends StatefulWidget {
  CompetitionWorkItemModel work;
  WorkInfoPage(CompetitionWorkItemModel work) : this.work = work;

  @override
  _WorkInfoPageState createState() => _WorkInfoPageState(work);
}

class _WorkInfoPageState extends State<WorkInfoPage> {
  CompetitionWorkItemModel work;
  UserModel user;
  String tag_name;
  _WorkInfoPageState(CompetitionWorkItemModel work) {
    this.work = work;
  }

  @override
  void initState() {
    _get_user_info();
    _get_tag_info(this.work.tag_id);
    _initFluwx();
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

  void _get_user_info() async {
    UserModel user = await UserUtil.get_user_info();
    setState(() {
      this.user = user;
    });
  }

  void _get_tag_info(tag_id) async {
    var tag_name = await TagPage.get_tag_by_id(tag_id);
    setState(() {
      this.tag_name = tag_name;
    });
  }

  void _addVote(CompetitionWorkItemModel item) async {
    var param = {"id": item.id, "votes": item.votes + 1};
    var response = await DioUtil.post(
        Constant.UPDATE_VOTES_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
    } else {
      Util.showShortLoading(response['message']);
    }
  }

  Future<bool> sendDataToBackScreen() async {
    Navigator.pop(context, true);
    return true;
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
                // ShareInfo(this.work.subject, this.work.url,
                //     img: this.work.url, describe: "分享内容"),
                ShareInfo(this.work.subject,
                    Constant.SHARE_COMPETITION_WORK_URL + this.work.id.toString(),
                    img: this.work.url, describe: "分享内容"),
                list: this.list,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: sendDataToBackScreen,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              this.work.subject,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            centerTitle: true,
            toolbarHeight: 40,
            backgroundColor: Colors.white, // status bar color
            brightness: Brightness.light, // status bar brightness
            actions: [_shareComment()],
          ),
          body: Column(
            children: [
              this.user == null
                  ? Center(child: Text(Constant.LOADING_TEXT))
                  : Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                                child: Image.network(
                                  this.work.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(this.user.avatar_url),
                              ),
                              title: Text(this.user.nick_name),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(16.0),
                              height: 100,
                              // 可选择的文本
                              child: SelectableText(
                                this.work.subject,
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
                                      (this.tag_name != "" &&
                                              this.tag_name != null)
                                          ? "# " + this.tag_name
                                          : "",
                                      style: TextStyle(color: Colors.blue),
                                      maxLines: 200,
                                      scrollPhysics: ClampingScrollPhysics(),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
              ButtonUtil.flatButton(Constant.VOTE_NAME, Colors.blue[200], () {
                _addVote(this.work);
              })
            ],
          ),
        ));
  }
}

Future<bool> _showMessage(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
