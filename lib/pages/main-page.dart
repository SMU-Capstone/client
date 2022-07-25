import 'package:client/pages/loading.dart';
import 'package:client/pages/main-drawer.dart';
import 'package:client/widgets/camera.dart';
import 'package:client/widgets/main-map.dart';
import 'package:flutter/material.dart';

// MainPage stateless로 변경
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
