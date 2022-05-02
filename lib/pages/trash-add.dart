// 쓰레기통 추가신청 페이지
import 'package:flutter/material.dart';

class TrashAddPage extends StatelessWidget {
  const TrashAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('쓰레기통 추가신청'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('신청하기'),
                        content: SingleChildScrollView(
                          child: Text('미구현입니다.'),
                          ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                          ),
                          TextButton(
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
              child: Text(
                '신청하기',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
            )
          ],
        )
      )
    );
  }
}
