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

//drawer의 윗부분
class InfoPart extends StatelessWidget {
  const InfoPart({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.green,
      child: Column(
        children: [
          //상단바
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {
                  Navigator.of(context).pop(null),
                },
              ),
            ),
          ),
          //body부분
          Flexible(
            flex: 3,
            child: Container(
              child: Text('가로쓰레기통 알리미',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//drawer의 아랫부분
class MenuPart extends StatelessWidget {
  const MenuPart({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView(
          children: [
            ListTile(title: Text("쓰레기통 추가신청"),),
            ListTile(title: Text("쓰레기통 철거신청"),),
            ListTile(title: Text("쓰레기통 청소신청"),),
          ],
        ),
      ),
    );
  }
}

// class MainDrawerMenu extends StatelessWidget {
//   MainDrawerMenu({required TrashManageWidget trashManageWidget}):
//     this.trashManageWidget = trashManageWidget;
      
//   //쓰레기통관리 위젯
//   TrashManageWidget trashManageWidget;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: trashManageWidget.getTitle(),
//       onTap: () => {

//       },
//     );
//   }
// }