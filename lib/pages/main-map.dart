import 'dart:async';
import 'package:client/utils/geolocator-service.dart';
import 'package:client/pages/main-drawer.dart';
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
      drawer: MainDrawer(),
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
          child: Stack(
            children: [
              NaverMap(
                onMapCreated: _onMapCreated,
                mapType: _mapType,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                ),
                locationButtonEnable: true,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: RefreshBtn(controller: _controller,)
              ),
              Align(
                alignment: Alignment.topCenter,
                child: TrashClassification(),
              )
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

//새로고침으로 근처 쓰레기통 마커를 가져오는 버튼
class RefreshBtn extends StatelessWidget {
  const RefreshBtn({ Key? key, required Completer<NaverMapController> controller }) : 
    this._controller = controller,
    super(key: key);

  final Completer<NaverMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      //현재 카메라의 중심좌표 반환
      onPressed: () async{
        final controller = await _controller.future;
        final a = await controller.getCameraPosition();
        print(a);
      }, 
      icon: Icon(Icons.autorenew, size: 30,),
    );
  }
}

class TrashClassification extends StatefulWidget {
  const TrashClassification({ Key? key }) : super(key: key);

  @override
  _TrashClassificationState createState() => _TrashClassificationState();
}


class _TrashClassificationState extends State {

  String? dropdownValue = '모든 쓰레기통';
  final List<String> _valueList = ['모든 쓰레기통', '재활용 쓰레기통'];

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
        style: TextStyle(color: Colors.black, fontSize: 18, ),
        onChanged: (String? data) {
          setState(() {
            dropdownValue = data;
          });
        },
        items: _valueList.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Center(child: Text(value, textAlign: TextAlign.center,)),
          );
        }).toList(),
      ),
    );
  }
}
