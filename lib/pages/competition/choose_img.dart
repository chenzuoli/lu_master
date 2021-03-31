import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChooseImg extends StatefulWidget {
  ChooseImg({Key key}) : super(key: key);

  @override
  _ChooseImgState createState() => _ChooseImgState();
}

class _ChooseImgState extends State<ChooseImg> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Image Picker Example',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.white, // status bar color
        brightness: Brightness.light, // status bar brightness
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
        heroTag: 'choose_img',
      ),
    );
  }
}
