import 'dart:async';
import 'package:client/controllers/dropdown-controller.dart';
import 'package:client/controllers/main-map-controller.dart';
import 'package:client/pages/loading.dart';
import 'package:client/utils/geolocator-service.dart';
import 'package:client/pages/main-drawer.dart';
import 'package:client/utils/main-service.dart';
import 'package:client/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:get/get.dart'; // 상태관리용 GetX 패키지

class NaverMapWidget extends StatelessWidget {
  NaverMapWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainMapController>(
      init: MainMapController(),
      builder: (_) {
        if (mainMapController.position == null) {
          return LoadingScreen();
        }
        return Container(
          child: Stack(
            children: [
              NaverMap(
                onMapCreated: _onMapCreated,
                mapType: mainMapController.mapType,
                initialCameraPosition: CameraPosition(
                  target: LatLng(mainMapController.position?.latitude,
                      mainMapController.position?.longitude),
                ),
                locationButtonEnable: true,
                markers: mainMapController.markers.toList(),
                onMapTap: (position) {
                  mainMapController.isVisible = false;
                },
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: RefreshBtn(
                    controller: mainMapController.controller,
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: TrashClassificationDropdownButton(
                  controller: mainMapController.controller,
                ), // 쓰레기통 종류 드랍다운
              ),
              Positioned(
                bottom: 10,
                left: 20,
                child: Visibility(
                  child: Container(
                    width: 335,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            mainMapController.address,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                              mainMapController.trashcanStringType[
                                  mainMapController.trashcanType],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          OutlinedButton(
                              onPressed: () {
                                applyCleaning(mainMapController.trashcanId!, 1);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title: const Text('쓰레기통 청소신청'),
                                          content:
                                              const Text('쓰레기통 청소신청이 완료되었습니다.'),
                                          actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('확인'),
                                        ),
                                      ]),
                                );
                              },
                              child: Text("청소신청"))
                        ],
                      ),
                    ),
                  ),
                  visible: mainMapController.isVisible,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (mainMapController.controller.isCompleted)
      mainMapController.controller = Completer();
    mainMapController.controller.complete(controller);
  }
}

//새로고침으로 근처 쓰레기통 마커를 가져오는 버튼
class RefreshBtn extends StatelessWidget {
  RefreshBtn({Key? key, required Completer<NaverMapController> controller})
      : this._controller = controller,
        super(key: key);


  final Completer<NaverMapController> _controller;

  refresh() async {
    final controller = await _controller.future;
    final xy = await controller.getCameraPosition();
    final double latitude = xy.target.latitude;
    final double longitude = xy.target.longitude;
    //카메라 주변 쓰레기통 좌표들을 가져온다.
    final data = await coordinates(latitude, longitude, mainMapController.type);
    mainMapController.setMarker(data);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      //현재 카메라의 중심좌표 반환
      onPressed: () async {
        await refresh();
      },
      icon: Icon(
        Icons.autorenew,
        size: 30,
      ),
    );
  }
}

// 쓰레기통종류 드랍다운 버튼 with GetX
class TrashClassificationDropdownButton extends StatelessWidget {
  TrashClassificationDropdownButton(
      {Key? key, required Completer<NaverMapController> controller})
      : this._controller = controller,
        super(key: key);

  DropdownController dropdownController =
      Get.put(DropdownController()); // DropdownController 의존성 주입

  final Completer<NaverMapController> _controller;

  refresh() async {
    final controller = await _controller.future;
    final xy = await controller.getCameraPosition();
    final double latitude = xy.target.latitude;
    final double longitude = xy.target.longitude;
    //카메라 주변 쓰레기통 좌표들을 가져온다.
    final data = await coordinates(latitude, longitude, mainMapController.type);
    mainMapController.setMarker(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(
            color: Colors.black,
            width: 0.3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        // 드랍다운 버튼
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            alignment: Alignment.centerRight,
            borderRadius: BorderRadius.circular(20),
            value: dropdownController.dropdownValue.value,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 0,
            elevation: 16,
            underline: Container(
              color: Colors.transparent,
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            onChanged: (String? data) async {
              dropdownController.dropdownValue.value = data!;
              switch (data) {
                case '일반 쓰레기통':
                  mainMapController.type = 1;
                  break;
                case '재활용 쓰레기통':
                  mainMapController.type = 2;
                  break;
                default:
                  mainMapController.type = null;
                  break;
              }
              await refresh();
            },
            items: dropdownController.valueList.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Center(
                    child: Text(
                  value,
                  textAlign: TextAlign.center,
                )),
              );
            }).toList(),
          ),
        ));
  }
}
