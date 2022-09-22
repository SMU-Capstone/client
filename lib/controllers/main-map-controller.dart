import 'dart:async';

import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:client/utils/main-service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:client/utils/geolocator-service.dart';

class MainMapController extends GetxController {
  int _analysisData = 1;

  String _address = '';
  List<String> _trashcanStringType = ['쓰레기통', '일반 쓰레기통', '재활용 쓰레기통'];
  int _trashcanType = 0;
  int? _trashcanId;
  int _trashcanFullCount = 0;
  bool _isVisible = false;

  List<Marker> _markers = [];
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;
  Position? _position;

  List<Marker> get markers => _markers;
  Completer<NaverMapController> get controller => _controller;
  MapType get mapType => _mapType;
  Position? get position => _position;

  set markers(List<Marker> list) => _markers = list;
  set mapType(MapType type) => _mapType = type;
  set position(Position? pos) => _position = pos;
  set controller(Completer<NaverMapController> com) => _controller = com;

  int? _type = null;

  int? get type => _type;
  set type(int? type) => _type = type;

  int get analysisData => _analysisData;

  set analysisData(int data) => _analysisData = data;

  String get address => _address;
  List<String> get trashcanStringType => _trashcanStringType;
  int get trashcanType => _trashcanType;
  int? get trashcanId => _trashcanId;
  int? get trashcanFullCount => _trashcanFullCount;
  bool get isVisible => _isVisible;

  set address(String address) => _address = address;
  set trashcanType(int type) => _trashcanType = type;
  set trashcanId(int? id) => _trashcanId = id;
  set trashcanFullCount(int? count) => _trashcanFullCount = count!;
  set isVisible(bool bool) => _isVisible = bool;

  @override
  void setMarker(List coordinates) {
    markers.clear();
    for (final coordinate in coordinates) {
      markers.add(
        Marker(
          markerId: coordinate['id'].toString(),
          position: LatLng(double.parse(coordinate['latitude']),
              double.parse(coordinate['longitude'])),
          width: 20,
          height: 30,
          onMarkerTab: (marker, iconSize) {
            address = coordinate['address'];
            trashcanType = coordinate['type'];
            trashcanId = coordinate['id'];
            trashcanFullCount = coordinate['logCount'];
            isVisible = true;
            update();
          },
        ),
      );
    }
    update();
  }

  void setSingleMarker(dynamic coordinate) {
    markers.clear();

    markers.add(
      Marker(
        markerId: coordinate['id'].toString(),
        position: LatLng(double.parse(coordinate['latitude']),
            double.parse(coordinate['longitude'])),
        width: 20,
        height: 30,
        onMarkerTab: (marker, iconSize) {
          address = coordinate['address'];
          trashcanType = coordinate['type'];
          trashcanId = coordinate['id'];
          trashcanFullCount = coordinate['logCount'];
          isVisible = true;
          update();
        },
      ),
    );

    update();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initGetCoordinate();
    });
    update();
  }

  @override
  void _initGetCoordinate() async {
    position = await GeolocatorService().getCurrentPosition();
    final latitude = position?.latitude;
    final longitude = position?.longitude;

    final data = await coordinates(latitude!, longitude!, type);
    setMarker(data);
    update();
  }

  @override
  void nearestTrashcan() async {
    position = await GeolocatorService().getCurrentPosition();
    final latitude = position?.latitude;
    final longitude = position?.longitude;
    final mapController = await controller.future;

    // final latitude = 37.602638;
    // final longitude = 126.955252; //테스트용 좌표입니다.

    final nearestTrashcan =
        await getNearestTrashcan(latitude!, longitude!, analysisData);

    address = nearestTrashcan['address'];
    trashcanId = nearestTrashcan['id'];
    trashcanType = nearestTrashcan['type'];
    trashcanFullCount = nearestTrashcan['logCount'];
    isVisible = true;

    setSingleMarker(nearestTrashcan);

    CameraUpdate cameraUpdate = CameraUpdate.toCameraPosition(CameraPosition(
        target: LatLng(double.parse(nearestTrashcan['latitude']),
            double.parse(nearestTrashcan['longitude']))));

    mapController.moveCamera(cameraUpdate);

    update();
  }

  falseIsVisible() {
    isVisible = false;
    update();
  }
}
