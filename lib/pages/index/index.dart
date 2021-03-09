import 'package:flutter/material.dart';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/pages/index/navigation_icon_view.dart';
import 'package:lu_master/pages/home/home_page.dart';
import 'package:lu_master/pages/about/about.dart';
import 'package:lu_master/pages/photograpier/master.dart';

// 创建一个带有状态的widget，因为我们需要事件触发
class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _IndexState();
}

// 要让主页面支持动效，就需要在他的定义中附加Mixin类型的对象TickerProviderStateMixin
class _IndexState extends State<Index> with TickerProviderStateMixin {
  int _currentIndex = 0; // 当前页面索引值
  List<NavigationIconView> _navigationViews; // 底部图标按钮区域
  List<StatefulWidget> _pageList; // 用来存放图标对应的页面
  StatefulWidget _currentPage; // 当前页面

  // 定义一个设置空状态的方法
  void _rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // 初始化导航图标
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: new Icon(Icons.home), label: Constant.HOME_PAGE_NAME, vsync: this),
      // new NavigationIconView(
      //     icon: new Icon(Icons.phone_in_talk), label: "通讯录", vsync: this),
      new NavigationIconView(
          icon: new Icon(Icons.all_inclusive), label: Constant.MASTER_PAGE_NAME, vsync: this),
      new NavigationIconView(
          icon: new Icon(Icons.perm_identity), label: Constant.ABOUT_PAGE_NAME, vsync: this)
    ];

    // 给每个按钮加上监听
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    // 将我们bottomBar上面的图标按钮与页面对应起来
    _pageList = <StatefulWidget>[
      new HomePage(),
      // new ContactPage(),
      // new PhotographerPage(),
      new MasterPage(),
      new AboutPage()
    ];
    _currentPage = _pageList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    // 声明定义一个底部导航的工具栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) =>
                navigationIconView.item)
            .toList(), // 添加Icon按钮
        currentIndex: _currentIndex, // 当前点击的索引值
        type: BottomNavigationBarType.fixed, // 设置底部导航栏的类型：fixed固定
        onTap: (int index) => {
              // 添加点击事件
              setState(() {
                // 点击之后需要触发的逻辑事件
                _navigationViews[_currentIndex].controller.reverse();
                _currentIndex = index;
                _navigationViews[_currentIndex].controller.forward();
                _currentPage = _pageList[_currentIndex];
              })
            });
    return Scaffold(
      body: new IndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
