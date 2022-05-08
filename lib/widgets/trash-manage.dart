// 쓰레기통 관리 위젯
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TrashManageWidget extends StatelessWidget {
  const TrashManageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView(
          children: [
            TrashAddWidget(),
            TrashDeleteWidget(),
            TrashCleanWidget(),
          ],
        ),
      ),
    );
  }
}

// 쓰레기통 추가신청 위젯
class TrashAddWidget extends StatefulWidget {
  @override
  _TrashAddWidgetState createState() => _TrashAddWidgetState();
}

class _TrashAddWidgetState extends State<TrashAddWidget> {
  final List<String> addReasons = [
    "1. 주변에 쓰레기통이 없어서",
    "2. 쓰레기통이 너무 금방 차서",
    "3. 기타",
  ];

  String? selectedAddReason = '1. 주변에 쓰레기통이 없어서';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('쓰레기통 추가신청 이유'),
            content: DropdownButton<String>(
              value: selectedAddReason,
              items: addReasons
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ))
                  .toList(),
              onChanged: (item) {
                setState(() {
                  selectedAddReason = item;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('신청'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('취소'),
              ),
            ],
          ),
        );
      },
      title: Text("쓰레기통 추가신청"),
    );
  }
}

// 쓰레기통 철거신청 위젯
class TrashDeleteWidget extends StatefulWidget {
  @override
  _TrashDeleteWidgetState createState() => _TrashDeleteWidgetState();
}

class _TrashDeleteWidgetState extends State<TrashDeleteWidget> {
  final List<String> deleteReasons = [
    "1. 도시 미관을 해쳐서",
    "2. 쓰레기통이 냄새가 심해서",
    "3. 기타",
  ];

  String? selectedDeleteReason = '1. 도시 미관을 해쳐서';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('쓰레기통 철거신청 이유'),
            content: DropdownButton<String>(
              value: selectedDeleteReason,
              items: deleteReasons
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ))
                  .toList(),
              onChanged: (item) {
                setState(() {
                  selectedDeleteReason = item;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('신청'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('취소'),
              ),
            ],
          ),
        );
      },
      title: Text("쓰레기통 철거신청"),
    );
  }
}

// 쓰레기통 청소 신청 위젯
class TrashCleanWidget extends StatelessWidget {
  const TrashCleanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: const Text('쓰레기통 청소신청'),
              content: const Text(
                  '쓰레기통 청소 신청은 지도에서 해당 쓰레기통을 클릭 후 -> 청소 신청 버튼을 클릭하시면 됩니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
              ]),
        );
      },
      title: Text("쓰레기통 청소신청"),
    );
  }
}
