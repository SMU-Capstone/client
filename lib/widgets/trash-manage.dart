// 쓰레기통 관리 위젯
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:client/utils/main-service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:client/utils/geolocator-service.dart';

class TrashManageWidget extends StatelessWidget {
  const TrashManageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView(
          children: [
            TrashAddWidget(),
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
  //쓰레기통 추가신청 이유 문자열 리스트
  final List<String> addReasons = [
    "1. 주변에 쓰레기통이 없어서",
    "2. 쓰레기통이 너무 금방 차서",
    "3. 기타",
  ];

  //쓰레기통 종류 문자열 리스트
  final List<String> addTrashType = ["1. 일반 쓰레기통", "2. 재활용 쓰레기통"];

  String? selectedAddReason = '1. 주변에 쓰레기통이 없어서';
  String? selectedAddTrashType = '1. 일반 쓰레기통';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Position position;
        position = await GeolocatorService().getCurrentPosition();
        final latitude = position!.latitude;
        final longitude = position!.longitude;
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('쓰레기통 추가신청'),
            content: Container(
              child: Column(
                children: [
                  Text('추가신청 사유'),
                  DropdownButtonFormField<String>(
                    value: selectedAddReason,
                    items: addReasons
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: TextStyle(fontSize: 16)),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAddReason = newValue;
                      });
                    },
                    onSaved: (String? newValue) {
                      setState(() {
                        selectedAddReason = newValue;
                      });
                    },
                  ),
                  Text('\n\n쓰레기통 유형'),
                  DropdownButtonFormField<String>(
                    value: selectedAddTrashType,
                    items: addTrashType
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: TextStyle(fontSize: 16)),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAddTrashType = newValue;
                      });
                    },
                    onSaved: (String? newValue) {
                      setState(() {
                        selectedAddTrashType = newValue;
                      });
                    },
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              height: 300,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  applyTrash(
                      latitude,
                      longitude,
                      int.parse(selectedAddTrashType!.split('.')[0]),
                      int.parse(selectedAddReason!.split('.')[0]));
                  selectedAddReason = '1. 주변에 쓰레기통이 없어서';
                  selectedAddTrashType = '1. 일반 쓰레기통';
                  Navigator.of(context).pop();
                },
                child: Text('신청'),
              ),
              TextButton(
                onPressed: () {
                  selectedAddReason = '1. 주변에 쓰레기통이 없어서';
                  selectedAddTrashType = '1. 일반 쓰레기통';
                  Navigator.of(context).pop();
                },
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
