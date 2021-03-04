import 'package:flutter/material.dart';
import 'service_botton.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../config/constant.dart';
import '../../config/custom_route.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imageList = List<Widget>();

  @override
  void initState() {
    imageList.add(
      Image.network(
          "http://cdn.pipilong.pet//mnt/pet/avatar/1608557511506wx7ba6300f3f9c05f8.o6zAJs09zvEoKvOGMm5fvNJjD-K0.oSbPwVLjNNFa771df18d8d213320a64e3d6798d9c67b.jpeg",
          fit: BoxFit.cover),
    );
    imageList.add(Image.network(
      "http://cdn.pipilong.pet//mnt/pet/avatar/1608558101301wx7ba6300f3f9c05f8.o6zAJs09zvEoKvOGMm5fvNJjD-K0.HdHkdhNLTbUh141dd346544edfb8410fbfe637268125.jpg",
      fit: BoxFit.cover,
    ));
    imageList.add(Image.network(
        "http://cdn.pipilong.pet//mnt/pet/avatar/1608558850736wx7ba6300f3f9c05f8.o6zAJs09zvEoKvOGMm5fvNJjD-K0.H95waxmF3xfxee6f34906624c247d5139cc54fe0fde8.jpeg",
        fit: BoxFit.cover));
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (imageList[index]);
  }

  Widget swiperView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Swiper(
        itemCount: imageList.length,
        itemBuilder: _swiperBuilder,
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
            builder: DotSwiperPaginationBuilder(
                color: Colors.black54, activeColor: Colors.white)),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(
              Constant.HOME_PAGE_NAME,
              style: TextStyle(fontSize: 16),
            ),
            centerTitle: true,
            toolbarHeight: 40,
            actions: <Widget>[new Container()],
          ),
          body: ListView(
            // 这里使用listView是因为本地写了几组不同样式的展示，太懒了，所以这里就没有改
            children: <Widget>[
              swiperView(),
              ServiceBotton("摄影比赛", ''),
              // Divider(height: 1.0, indent: 2.0, color: Colors.black),
              // ServiceBotton("溜溜", ''),
              // ServiceBotton("寄养", ''),
              // ServiceBotton("配种", ''),
              // ServiceBotton("领养", ''),
              // ServiceBotton("养宠百科", ''),
              // ServiceBotton("在线寻诊", ''),
            ],
          )),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
