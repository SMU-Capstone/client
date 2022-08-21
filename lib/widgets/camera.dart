import 'package:client/controllers/camera-controller.dart';
import 'package:client/controllers/main-map-controller.dart';
import 'package:client/utils/geolocator-service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/utils/main-service.dart';
import 'package:geolocator/geolocator.dart';

MainMapController mainMapController = Get.put(MainMapController());

class UseCamera extends StatelessWidget {
  final controller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //카메라 버튼이 눌렸을 경우 실행되는 함수
        final data = await controller.getImage(ImageSource.camera);
        final label = data['predicted_label'];
        if (label == '고철류' ||
            label == '도기류' ||
            label == '스티로폼' ||
            label == '유리병' ||
            label == '자전거' ||
            label == '전자제품' ||
            label == '캔류' ||
            label == '페트병' ||
            label == '플라스틱류' ||
            label == '형광등') {
          mainMapController.analysisData = 2;
        } else {
          mainMapController.analysisData = 1;
        }

        print(label);
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("쓰레기통 분류"),
            content: Text("분류 : ${label}"),
            actions: [
              FlatButton(
                  child: Text("쓰레기통 찾기"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    mainMapController.nearestTrashcan();
                  }),
            ],
          ),
        );
      },
      icon: Icon(Icons.camera),
      iconSize: 60,
    );
  }
}
