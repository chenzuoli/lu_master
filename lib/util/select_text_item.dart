import 'package:flutter/material.dart';

class SelectTextItem extends StatelessWidget {
  const SelectTextItem({
    Key key,
    @required this.title,
    this.onTap,
    this.content: "",
    this.textAlign: TextAlign.start,
    this.titleStyle,
    this.contentStyle,
    this.height,
    this.isShowArrow: true,
    this.imageName,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final double height;
  final bool isShowArrow; //是否显示右侧箭头
  final String imageName; //左侧图片名字 不传则不显示图片
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        height: this.height ?? 50.0,
        margin: EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                //下面的分割线 width 这个参数应该是控制分割线高度的
                bottom: Divider.createBorderSide(context,
                    color: Color(0xFFEEEEEE), width: 1))),
        child: Row(
          children: <Widget>[
            this.imageName == null
                ? Container()
                : Image.asset(
                    '${this.imageName}',
                    width: 22,
                    height: 22,
                  ),
            Text(this.title,
                style: this.titleStyle ??
                    new TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.0,
                    )),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(this.content,
                    textAlign: this.textAlign,
                    overflow: TextOverflow.ellipsis,
                    style: this.contentStyle ??
                        new TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFCCCCCC),
                        )),
              ),
            ),
            //这里为了方便用了系统icon 可以设置一张arrow 的图片
            // Image.asset(
            //   '',
            //   width: 16,
            //   height: 16,
            // )
            this.isShowArrow
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
