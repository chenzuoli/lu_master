import 'package:flutter/material.dart';
import 'package:lu_master/util/select_text_item.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/config/custom_route.dart';
import 'package:lu_master/pages/competition/competition.dart';
import 'package:lu_master/pages/competition/latest_competition.dart';
import 'work_recommend.dart';

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
          // "http://cdn.pipilong.pet//mnt/pet/avatar/1608557511506wx7ba6300f3f9c05f8.o6zAJs09zvEoKvOGMm5fvNJjD-K0.oSbPwVLjNNFa771df18d8d213320a64e3d6798d9c67b.jpeg",
          "http://cdn.pipilong.pet/home3.png",
          fit: BoxFit.cover),
    );
    imageList.add(Image.network(
      "http://cdn.pipilong.pet//mnt/pet/avatar/1608558850736wx7ba6300f3f9c05f8.o6zAJs09zvEoKvOGMm5fvNJjD-K0.H95waxmF3xfxee6f34906624c247d5139cc54fe0fde8.jpeg",
      fit: BoxFit.cover,
    ));
    imageList.add(Image.network("http://cdn.pipilong.pet/creator.jpeg",
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              Constant.HOME_PAGE_NAME,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            centerTitle: true,
            toolbarHeight: 40,
            backgroundColor: Colors.white, // status bar color
            brightness: Brightness.light, // status bar brightness
          ),
          body: ListView(
            // 这里使用listView是因为本地写了几组不同样式的展示，太懒了，所以这里就没有改
            children: <Widget>[
              swiperView(),
              // ServiceBotton(Constant.PHOTOGRAPHY_NAME, ''),
              SelectTextItem(
                imageName: "assets/images/camera.png",
                title: Constant.PHOTOGRAPHY_NAME,
                isShowArrow: true,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CompetitionPage();
                  }));
                },
              ),
              LatestCompetitionPage(),
              SelectTextItem(
                imageName: "assets/images/recommend.png",
                title: Constant.WORK_RECOMMEND_NAME,
                isShowArrow: false,
              ),
              WorkRecommend(width)
            ],
          )),
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
