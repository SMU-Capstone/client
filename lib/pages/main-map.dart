import 'dart:async';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NaverMap(
          onMapCreated: _onMapCreated,
          mapType: _mapType,
      )
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}