import 'package:flutter/material.dart';

class SelectCardItem extends StatelessWidget {
  const SelectCardItem({
    Key key,
    this.title,
    this.onTap,
    this.content: "",
    this.textAlign: TextAlign.start,
    this.titleStyle,
    this.contentStyle,
    this.height,
    @required this.img_url,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final double height;
  final String img_url; //左侧图片名字 不传则不显示图片

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: const Alignment(0.0, 0.6),
        children: [
          Card(
              margin: EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 16 / 9, //控制子元素的宽高比
                child: Image.network(
                  this.img_url,
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Text(
              this.title == null ? "" : this.title,
              style: this.titleStyle == null
                  ? TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  : this.titleStyle,
            ),
          ),
        ],
      ),
      onTap: this.onTap,
    );
  }
}
