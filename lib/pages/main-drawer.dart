import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        backgroundColor: Colors.blue,
        child: Column(
          children: [
            InfoPart(),
            MenuPart(),
          ],
        ),
      ),
    );
  }
}

class InfoPart extends StatelessWidget {
  const InfoPart({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.green,
    );
  }
}

class MenuPart extends StatelessWidget {
  const MenuPart({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}