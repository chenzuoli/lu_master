import 'package:flutter/material.dart';

// 创建一个ICON展示组件
class NavigationIconView {
  // 创建2个属性，一个展示ICON，一个动画处理
  BottomNavigationBarItem item;
  AnimationController controller;
  // 构造方法
  NavigationIconView({Widget icon, String label, TickerProvider vsync}) {
    item = BottomNavigationBarItem(icon: icon, label: label);
    controller =
        AnimationController(vsync: vsync, duration: kThemeAnimationDuration);
  }
}
