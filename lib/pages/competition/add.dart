import 'package:flutter/material.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/config/constant.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lu_master/util/util.dart';
import 'competition_model.dart';
import 'package:lu_master/util/select_text_item.dart';


/// 添加作品
///

class AddWorkPage extends StatefulWidget {
  CompetitionItemModel item;
  AddWorkPage(CompetitionItemModel item) : this.item = item;

  @override
  _AddWorkPageState createState() => _AddWorkPageState(item);
}

class _AddWorkPageState extends State<AddWorkPage> {
  CompetitionItemModel item;

  final _formKey = GlobalKey<FormState>();

  String _nickName;
  String _subject;
  String _url;

  File _image;
  final picker = ImagePicker();
  String _imgServerPath;
  dynamic tag;

  _AddWorkPageState(CompetitionItemModel item) {
    this.item = item;
  }

  @override
  void initState() {
    _getTags();
    super.initState();
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请输入宠物昵称',
            icon: Icon(
              Icons.pets,
              color: Colors.grey,
            )),
        onSaved: (value) => _nickName = value.trim(),
      ),
    );
  }

  Widget _showSubjectInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请输入作品主题',
            icon: Icon(
              Icons.subject,
              color: Colors.grey,
            )),
        onSaved: (value) => _subject = value.trim(),
      ),
    );
  }

  Widget _addWork() {
    return Container(
        width: double.infinity,
        height: 400,
        child: IconButton(
          icon: Icon(Icons.photo_camera_outlined),
          iconSize: 80,
          onPressed: _getImage,
        ),
        decoration: BoxDecoration(
          border: Border.all(
              width: 0.5, style: BorderStyle.solid, color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ));
  }

  
  Future<List<dynamic>> _getTags() async {
    // 获取所有tag_id
    var response =
        await DioUtil.get(Constant.WORK_TAG_API, Constant.CONTENT_TYPE_JSON);
    var res = [];
    if (response['status'] == 200) {
      var tags = response['data'];
      for (var tag in tags) {
        res.add(tag["tag_id"]);
      }
      Data.tags = tags;
    }
    return res;
  }


  Widget getTags() {
    return Container(
      child: Column(
        children: Data.tags
            .map((e) => SelectTextItem(
                  title: "# " + e['tag_name'],
                  isShowArrow: false,
                  onTap: () {
                    Navigator.pop(context, e);
                    this.tag = e;
                  },
                ))
            .toList(),
      ),
    );
  }

  void f() async {
    await showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
              height: 700,
              child: SingleChildScrollView(
                child: Column(children: [
                  getTags()
                ]),
              ));
        });
    setState(() {});
  }

  Widget _showTag() {
    return SelectTextItem(
      title: Constant.PHOTOGRAPHY_TAG_NAME,
      titleStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
      imageName: "assets/images/tag.png",
      height: 60,
      width: 16,
      content: this.tag != null ? "# " + this.tag['tag_name'] : "",
      contentStyle: TextStyle(
        fontSize: 14.0,
        color: Color(0xFFCCCCCC),
      ),
      onTap: f,
    );
  }

  Widget _showImgInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Center(
          child: _image == null
              ? _addWork()
              : Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
        ));
  }

  Future _getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<bool> _isVote() async {
    var param = {
      "competition_id": this.item.competition_id,
      "open_id": await Util.getString("open_id")
    };
    var response = await DioUtil.get(
        Constant.CHECK_VOTE_API, Constant.CONTENT_TYPE_JSON,
        data: param);
    if (response['status'] != 200) {
      Util.showShortLoading(response['message']);
      return false;
    } else {
      return true;
    }
  }

  Widget _submitBtn() {
    return Container(
        padding: EdgeInsets.only(top: 35, bottom: 35),
        child: SizedBox(
          height: 40,
          width: 200,
          child: OutlineButton(
              child: Text(
                Constant.SUBMIT_BTN_NAME,
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                bool flag = await _isVote();
                if (flag) {
                  await _uploadImage();
                  await _submitAction();
                }
              }),
        ));
  }

  //上传图片到服务器
  Future _uploadImage() async {
    final form = _formKey.currentState;
    form.save();
    if (this._nickName == '' || this._nickName == null) {
      Util.showMessageDialog(context, '昵称不能为空');
      return;
    }
    if (this._subject == '' || this._subject == null) {
      Util.showMessageDialog(context, '主题不能为空');
      return;
    }
    if (this._image == '' || this._image == null) {
      Util.showMessageDialog(context, "请上传作品");
      return;
    }
    FormData formData = FormData.fromMap({
      "name": "avatarFile",
      "avatarFile": await MultipartFile.fromFile(_image.path)
    });
    BuildContext dialogContext = await Util.showLoading(context, "上传中，请等待...");
    var response = await DioUtil.uploadFile(
        Constant.UPLOAD_FILE_URL, Constant.CONTENT_TYPE_FILE, formData);
    // Navigator.pop(dialogContext);
    Navigator.of(context, rootNavigator: true).pop();
    // Navigator.pop(context, true); // close dialog
    if (response['status'] == 200) {
      Util.showShortLoading("上传成功");
      setState(() {
        this._imgServerPath = "${response["data"]}";
      });
    } else {
      Util.showShortLoading(response['message']);
      return;
    }
    if (this._imgServerPath == '' || this._imgServerPath == null) {
      Util.showMessageDialog(context, "作品不能为空");
      return;
    }
    return response;
  }

  Future _submitAction() async {
    final form = _formKey.currentState;
    form.save();

    if (this._nickName == '') {
      Util.showMessageDialog(context, '昵称不能为空');
      return;
    }
    if (this._subject == '') {
      Util.showMessageDialog(context, '主题不能为空');
      return;
    }
    if (this._url == '') {
      Util.showMessageDialog(context, "作品不能为空");
      return;
    }
    if (this._imgServerPath == '') {
      Util.showMessageDialog(context, "作品不能为空");
      return;
    }
    var params = {
      "nick_name": this._nickName,
      "subject": this._subject,
      "url": this._imgServerPath,
      "type": "image",
      "open_id": await Util.getString("open_id"),
      "competition_id": this.item.competition_id,
      "phone": "",
      "tag_id": this.tag != null ? this.tag['tag_name'] : ""
    };
    var response = await DioUtil.post(
        Constant.WORK_ADD_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
      Navigator.of(context).pop();
    } else {
      Util.showShortLoading(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
          heroTag: "add_competition_work",
        ),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            Constant.ADD_WORK_PAGE_NAME,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: Colors.white, // status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    _showNameInput(),
                    Divider(height: 0.5, indent: 16.0, color: Colors.grey[300]),
                    _showSubjectInput(),
                    Divider(height: 0.5, indent: 16.0, color: Colors.grey[300]),
                    _showTag(),
                    _showImgInput(),
                    _submitBtn()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
