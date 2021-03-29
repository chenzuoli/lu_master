import 'package:flutter/material.dart';

class ButtonUtil {
  static FlatButton flatButton(String text, Color color, Function onTap) {
    return FlatButton(onPressed: onTap, child: Text(text), color: color,);
  }
}
