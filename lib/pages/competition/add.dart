import 'package:flutter/material.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/util/dio_util.dart';
import '../../config/constant.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lu_master/util/util.dart';

/// 添加作品
///

class AddWorkPage extends StatefulWidget {
  AddWorkPage({Key key}) : super(key: key);

  @override
  _AddWorkPageState createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  final _formKey = new GlobalKey<FormState>();

  String _nick_name;
  String _subject;
  String _url;

  File _image;
  final picker = ImagePicker();
  String _imgServerPath;

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
        onSaved: (value) => _nick_name = value.trim(),
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
        child: Icon(
          Icons.photo_camera_outlined,
          size: 80,
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

  Widget _submitBtn() {
    return Container(
        padding: EdgeInsets.only(top: 35),
        child: SizedBox(
          height: 40,
          width: 200,
          child: OutlineButton(
              child: Text(
                "提交",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () {
                print("点击了提交");
                var response = _uploadImage();
                response.then((value) => {_submitAction()});
                _submitAction();
              }),
        ));
  }

  //上传图片到服务器
  Future _uploadImage() async {
    FormData formData = FormData.fromMap({
      "name": "electric barker",
      "file": await MultipartFile.fromFile(_image.path)
    });
    Dio dio = Dio();
    Response response =
        await dio.post(Constant.UPLOAD_FILE_URL, data: formData);
    if (response.statusCode == 200) {
      Map responseMap = response.data;
      print("${responseMap["data"]}");
      setState(() {
        this._imgServerPath = "${responseMap["path"]}";
      });
    }
    return response;
  }

  void _submitAction() async {
    final form = _formKey.currentState;
    form.save();

    if (this._nick_name == '') {
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
      "nick_name": this._nick_name,
      "subject": this._subject,
      "url": this._imgServerPath,
      "type": "img",
      "open_id": await Util.getString("open_id")
    };
    var response = await DioUtil.request(Constant.WORK_ADD_API,
        method: 'post', data: params);
    if (response['status'] == "200") {
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
            child: Icon(Icons.add_a_photo)),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(Constant.ADD_WORK_PAGE_NAME),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            child: Card(
              child: Column(
                children: <Widget>[
                  _showNameInput(),
                  Divider(height: 0.5, indent: 16.0, color: Colors.grey[300]),
                  _showSubjectInput(),
                  Divider(height: 0.5, indent: 16.0, color: Colors.grey[300]),
                  _showImgInput(),
                  _submitBtn()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
