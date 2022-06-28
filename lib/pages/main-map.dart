import 'dart:async';
import 'package:client/pages/loading.dart';
import 'package:client/utils/geolocator-service.dart';
import 'package:client/pages/main-drawer.dart';
import 'package:client/utils/main-service.dart';
import 'package:client/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

NaverMapBody naverMapBody = NaverMapBody();

class MainPage extends StatefulWidget {
  @override
  _StartMainPage createState() => _StartMainPage();
}

//Main page 시작
class _StartMainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(title: Text('가로쓰레기통 알리미')),
      body: NaverMapWidget(),
      bottomNavigationBar: MainBottomNavBar(),
    );
  }
}

//Bottom Navigation Bar
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        alignment: Alignment.center,
        height: 70,
        color: Colors.lightBlue,
        child: UseCamera(),
      ),
    );
  }
}

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({Key? key}) : super(key: key);

  @override
  NaverMapBody createState() => naverMapBody;
}

//Naver map
class NaverMapBody extends State {
  List<Marker> _markers = [];
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;
  Position? position;
  int? type = null;

  //마커에 쓰레기통 정보를 띄우기 위한 변수들
  String address = '';
  List<String> trashcanStringType = ['쓰레기통', '일반 쓰레기통', '재활용 쓰레기통'];
  int trashcanType = 0;
  int? trashcanId;

  bool isVisible = false;

  setMarker(List coordinates) {
    setState(() {
      _markers.clear();
      for (final coordinate in coordinates) {
        _markers.add(
          Marker(
            markerId: coordinate['id'].toString(),
            position: LatLng(double.parse(coordinate['latitude']),
                double.parse(coordinate['longitude'])),
            width: 20,
            height: 30,
            onMarkerTab: (marker, iconSize) {
              setState(() {
                address = coordinate['address'];
                trashcanType = coordinate['type'];
                trashcanId = coordinate['id'];
                isVisible = true;
              });
            },
          ),
        );
      }
    });
  }

  //앱시작시, 사용자 위치 근처 마커들을 표시
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initGetCoordinate();
    });
  }

  //앱시작시, 사용자 위치 근처 마커들을 표시하는 함수. initState에 들어간다.
  _initGetCoordinate() async {
    position = await GeolocatorService().getCurrentPosition();
    final latitude = position!.latitude;
    final longitude = position!.longitude;

    final data = await coordinates(latitude, longitude, type);
    setMarker(data);
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      return LoadingScreen();
    }

    return Container(
      child: Stack(
        children: [
          NaverMap(
            onMapCreated: _onMapCreated,
            mapType: _mapType,
            initialCameraPosition: CameraPosition(
              target: LatLng(position!.latitude, position!.longitude),
            ),
            locationButtonEnable: true,
            markers: _markers.toList(),
            onMapTap: (position) {
              setState(() {
                isVisible = false;
              });
            },
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: RefreshBtn(
                controller: _controller,
              )),
          Align(
            alignment: Alignment.topCenter,
            child: TrashClassification(),
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
                        address,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(trashcanStringType[trashcanType],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                      OutlinedButton(
                          onPressed: () {
                            applyCleaning(trashcanId!, 1);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: const Text('쓰레기통 청소신청'),
                                  content: const Text('쓰레기통 청소신청이 완료되었습니다.'),
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
              visible: isVisible,
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

//새로고침으로 근처 쓰레기통 마커를 가져오는 버튼
class RefreshBtn extends StatelessWidget {
  const RefreshBtn(
      {Key? key, required Completer<NaverMapController> controller})
      : this._controller = controller,
        super(key: key);

  final Completer<NaverMapController> _controller;

  refresh() async {
    final controller = await _controller.future;
    final xy = await controller.getCameraPosition();
    final double latitude = xy.target.latitude;
    final double longitude = xy.target.longitude;
    //카메라 주변 쓰레기통 좌표들을 가져온다.
    final data = await coordinates(latitude, longitude, naverMapBody.type);

    naverMapBody.setMarker(data);
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

//드롭다운버튼
class TrashClassification extends StatefulWidget {
  const TrashClassification({Key? key}) : super(key: key);

  @override
  _TrashClassificationState createState() => _TrashClassificationState();
}

//드롭다운 버튼의 create상태
class _TrashClassificationState extends State {
  String? dropdownValue = '모든 쓰레기통';
  final List<String> _valueList = ['모든 쓰레기통', '일반 쓰레기통', '재활용 쓰레기통'];

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
      child: DropdownButton<String>(
        isExpanded: true,
        alignment: Alignment.centerRight,
        borderRadius: BorderRadius.circular(20),
        value: dropdownValue,
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
        onChanged: (String? data) {
          setState(() {
            dropdownValue = data;
            switch (data) {
              case '일반 쓰레기통':
                naverMapBody.type = 1;
                break;
              case '재활용 쓰레기통':
                naverMapBody.type = 2;
                break;
              default:
                naverMapBody.type = null;
                break;
            }
          });
        },
        items: _valueList.map((String value) {
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
    );
  }
}
