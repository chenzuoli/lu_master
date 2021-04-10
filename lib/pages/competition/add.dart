import 'package:flutter/material.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:lu_master/config/constant.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lu_master/util/util.dart';
import 'competition_model.dart';

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

  final _formKey = new GlobalKey<FormState>();

  String _nickName;
  String _subject;
  String _url;

  File _image;
  final picker = ImagePicker();
  String _imgServerPath;

  _AddWorkPageState(CompetitionItemModel item) {
    this.item = item;
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入宠物昵称',
            icon: new Icon(
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
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入作品主题',
            icon: new Icon(
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
                "提交",
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
    Util.showLoading(context, "上传中，请等待...");
    var response = await DioUtil.uploadFile(
        Constant.UPLOAD_FILE_URL, Constant.CONTENT_TYPE_FILE, formData);
    Navigator.of(context).pop("xxx");
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
      "phone": ""
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
    return MaterialApp(
      routes: routes,
      onGenerateRoute: onGenerateRoute,
      home: Scaffold(
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
                      Divider(
                          height: 0.5, indent: 16.0, color: Colors.grey[300]),
                      _showSubjectInput(),
                      Divider(
                          height: 0.5, indent: 16.0, color: Colors.grey[300]),
                      _showImgInput(),
                      _submitBtn()
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
