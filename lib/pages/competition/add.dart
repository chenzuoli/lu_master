import 'package:flutter/material.dart';
import '../../config/constant.dart';
/// 添加作品
///

class AddWorkPage extends StatefulWidget {
  AddWorkPage({Key key}) : super(key: key);

  @override
  _AddWorkPageState createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  void showPhoto(BuildContext context, Widget image) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return GestureDetector(
        child: SizedBox.expand(
          child: Hero(
            tag: image,
            child: image,
          ),
        ),
        onTap: () {
          Navigator.maybePop(context);
        },
      );
    }));
  }

  List<Widget> _list = <Widget>[
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    ClipRRect(
      child: Image.asset(
        'assets/images/bitcoin.jpeg',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(Constant.ADD_WORK_PAGE_NAME),
          ),
          body: Column(
            children: [
              Center(
                child: RaisedButton(
                  child: const Text(Constant.COMPETITION_CONDITION_BTN_NAME),
                  onPressed: () {
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
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              padding: const EdgeInsets.all(4.0),
                              children: _list.map(
                                (Widget img) {
                                  return GestureDetector(
                                    onTap: () {
                                      showPhoto(context, img);
                                    },
                                    child: Hero(
                                      tag: img,
                                      child: img,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          )),
    );
  }
}
