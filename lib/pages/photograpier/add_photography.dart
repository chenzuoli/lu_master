import 'package:flutter/material.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/dio_util.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/pages/about/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:lu_master/util/tag_page.dart';
import 'package:lu_master/util/util.dart';

/// 添加动态
/// 2021-05-17 添加作品标签，最多添加3个标签，标签从底部弹出到标签栏高度
///   可以搜索标签，也可以直接选择热门标签（热门标签不打印对应使用量）

class AddPhotographyPage extends StatefulWidget {
  AddPhotographyPage({Key key}) : super(key: key);

  @override
  _AddPhotographyPageState createState() => _AddPhotographyPageState();
}

class _AddPhotographyPageState extends State<AddPhotographyPage> {
  final _formKey = GlobalKey<FormState>();

  String _nick_name;
  String _subject;

  File _image;
  final picker = ImagePicker();
  String _imgServerPath;

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
        onSaved: (value) => _nick_name = value.trim(),
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

  Widget _search() {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // showSearch(context: context, delegate: SearchDelegate());
      },
    );
  }

  Widget _showTag() {
    return SelectTextItem(
      title: Constant.PHOTOGRAPHY_TAG_NAME,
      titleStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
      imageName: "assets/images/tag.png",
      height: 60,
      width: 16,
      onTap: () => {
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
                  height: 700,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      // _search(),
                      TagPage(Data.tags)]),
                  ));
            })
      },
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
                await _uploadImage();
                await _submitAction();
              }),
        ));
  }

  //上传图片到服务器
  Future _uploadImage() async {
    final form = _formKey.currentState;
    form.save();
    if (this._nick_name == '' || this._nick_name == null) {
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
    Navigator.pop(context, true); // close dialog
    if (response['status'] == 200) {
      Util.showShortLoading("上传成功");
      setState(() {
        this._imgServerPath = "${response["data"]}";
      });
    }
    if (this._imgServerPath == '' || this._imgServerPath == null) {
      Util.showMessageDialog(context, "作品不能为空");
      return;
    }
    return response;
  }

  Future _submitAction() async {
    String open_id = await Util.getString("open_id");
    Data.user = await UserModel.requestUserInfo(open_id);
    var params = {
      "nick_name": this._nick_name,
      "subject": this._subject,
      "url": this._imgServerPath,
      "type": "image",
      "open_id": open_id,
      "photographer": Data.user.nick_name
    };
    var response = await DioUtil.post(
        Constant.PHOTOGRAPHY_ADD_API, Constant.CONTENT_TYPE_JSON,
        data: params);
    if (response['status'] == 200) {
      Util.showShortLoading(response['data']);
      Navigator.of(context).pop("xxx");
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
          heroTag: 'add_photography',
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
                      _showTag(),
                      Divider(
                          height: 0.5, indent: 16.0, color: Colors.grey[300]),
                      _showImgInput(),
                      _submitBtn()
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
