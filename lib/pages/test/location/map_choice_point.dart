import 'package:flutter/material.dart';
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// 地图选择点控件
class MapChoicePoint extends StatefulWidget {
  /// 选择点后回调事件
  final Function onChoicePoint;
  MapChoicePoint(this.onChoicePoint);
  @override
  _MapChoicePointState createState() => _MapChoicePointState();
}

class _MapChoicePointState extends State<MapChoicePoint>
    with SingleTickerProviderStateMixin {
  //----属性----

  //地图控制器
  AmapController _amapController;
  //选择的点
  Marker _markerSelect;
  //搜索出来之后选择的点
  Marker _markerSeached;
  //所在城市
  String city;
  //搜索框文字控制器
  TextEditingController _serachController;
  //自定义marker点图标图片路径
  Uri _imgUri = Uri.parse('images/position.png');

  //----方法----

  /// 获取权限
  Future<bool> _requestPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 根据搜索条件选出想要的点
  Future _openModalBottomSheet() async {
    //收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    //根据关键字及城市进行搜索
    final poiList = await AmapSearch.searchKeyword(
      _serachController.text,
      city: city,
    );
    List<Map> points = [];
    //便利拼接信息
    for (var item in poiList) {
      points.add({
        'title': await item.title,
        'address': await item.adName + await item.address,
        'position': await item.latLng,
      });
    }
    //弹出底部对话框并等待选择
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return points.length > 0
              ? ListView.builder(
                  itemCount: points.length,
                  itemBuilder: (BuildContext itemContext, int i) {
                    return ListTile(
                      title: Text(points[i]['title']),
                      subtitle: Text(points[i]['address']),
                      onTap: () {
                        Navigator.pop(context, points[i]);
                      },
                    );
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(40),
                  child: Text('暂无数据'));
        });

    if (option != null) {
      LatLng selectlatlng = option['position'];
      //将地图中心点移动到选择的点
      _amapController.setCenterCoordinate(selectlatlng);
      //删除原来地图上搜索出来的点
      if (_markerSeached != null) {
        _markerSeached.remove();
      }
      //将搜索出来的点显示在界面上 --此处不能使用自定义图标的marker，使用会报错，至今也没有解决
      _markerSeached = await _amapController.addMarker(MarkerOption(
        latLng: selectlatlng,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _serachController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget marker() {
    return Container(
      child: Image.asset("dep/images/location.png"),
      width: 64,
      height: 64,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        AmapView(
          // 地图类型 (可选)
          mapType: MapType.Standard,
          // 是否显示缩放控件 (可选)
          showZoomControl: true,
          // 是否显示指南针控件 (可选)
          showCompass: false,
          // 是否显示比例尺控件 (可选)
          showScaleControl: true,
          // 是否使能缩放手势 (可选)
          zoomGesturesEnabled: true,
          // 是否使能滚动手势 (可选)
          scrollGesturesEnabled: true,
          // 是否使能旋转手势 (可选)
          rotateGestureEnabled: false,
          // 是否使能倾斜手势 (可选)
          tiltGestureEnabled: false,
          // 缩放级别 (可选)
          zoomLevel: 16,
          // 中心点坐标 (可选)
          // centerCoordinate: LatLng(39, 116),
          // 标记 (可选)
          markers: <MarkerOption>[],
          // 标识点击回调 (可选)
          onMarkerClicked: (Marker marker) async {
            if (_markerSeached == null) {
              return;
            }
            //获取点击点的位置
            var location = await marker.location;
            var lon = location.longitude;
            var lat = location.latitude;
            //获取搜索点的位置
            var slocation = await _markerSeached.location;
            var slon = slocation.longitude;
            var slat = slocation.latitude;
            //比较位置
            if (lon == slon && lat == slat) {
              //移除原来的点
              if (_markerSeached != null) {
                _markerSeached.remove();
              }
              if (_markerSelect != null) {
                _markerSelect.remove();
              }
              //画上新的点
              _markerSelect = await _amapController.addMarker(MarkerOption(
                  latLng: location,
                  widget: this.marker(),
                  // imageConfig: createLocalImageConfiguration(context),
                  anchorV: 0.7,
                  anchorU: 0.5));
            }
          },
          // 地图点击回调 (可选)
          onMapClicked: (LatLng coord) async {
            if (_amapController != null) {
              //移除原来的点
              if (_markerSelect != null) {
                _markerSelect.remove();
              }
              if (_markerSeached != null) {
                _markerSeached.remove();
              }
              //画上新的点
              _markerSelect = await _amapController.addMarker(MarkerOption(
                  latLng: coord,
                  widget: this.marker(),
                  // imageConfig: createLocalImageConfiguration(context),
                  anchorV: 0.7,
                  anchorU: 0.5));
              widget.onChoicePoint(coord);
            }
          },
          onMapMoveStart: (MapMove move) {},
          // 地图创建完成回调 (可选)
          onMapCreated: (controller) async {
            _amapController = controller;
            //申请权限
            if (await _requestPermission()) {
              //获取所在城市
              final location = await AmapLocation.fetchLocation();
              city = await location.city;
              //显示自己的定位
              await controller.showMyLocation(MyLocationOption(show: true));
              // await initSerach();
            }
          },
        ),
        Container(
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: 46,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width - 20 - 80,
                child: TextField(
                  controller: _serachController,
                  decoration: InputDecoration(border: InputBorder.none),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10) //限制长度
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(Icons.search), onPressed: _openModalBottomSheet)
            ],
          ),
        )
      ],
    );
  }
}
