import 'dart:async';
import 'package:client/utils/geolocator-service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class MainPage extends StatefulWidget {
  @override
  _StartMainPage createState() => _StartMainPage();
  
}

//Main page 시작
class _StartMainPage extends State<MainPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가로쓰레기통 알리미')),
      body: NaverMapBody(),
      bottomNavigationBar: MainBottomNavBar(),
    );
  }
}

//Bottom Navigation Bar
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        alignment: Alignment.center,
        height: 70,
        color: Colors.lightBlue,
        child: IconButton(
          onPressed: () {
            //카메라 버튼이 눌렸을 경우 실행되는 함수
            
          },
          icon: Icon(Icons.camera),
          iconSize: 60,
          
        ),
      ),
    );
  }
}

//Naver map
class NaverMapBody extends StatelessWidget {
  NaverMapBody({ Key? key }) : super(key: key);

  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;
  final Future<Position> position = GeolocatorService().getCurrentPosition();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: position,
      builder: (context, snapshot) {
        //에러 발생시 화면
        if(snapshot.hasError) {
          return Text('Error');
        }

        //data를 받아오기 전 화면
        if(snapshot.hasData == false) {
          return Text('아직 못받아옴');
        }

        //정상 실행시 화면
        Position position = snapshot.data as Position;
        return Container(
          child: NaverMap(
            onMapCreated: _onMapCreated,
            mapType: _mapType,
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
            ),
            locationButtonEnable: true,
          ),
        );
      }
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}