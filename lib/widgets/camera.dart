import 'package:client/controllers/camera-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UseCamera extends StatelessWidget {

  final controller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //카메라 버튼이 눌렸을 경우 실행되는 함수
        final data = await controller.getImage(ImageSource.camera);
        final label = data['predicted_label'];
        print(label);
        showDialog(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Text("쓰레기통 분류"),
            content: Text("분류 : ${label}"),
          ),
        );
      },
      icon: Icon(Icons.camera),
      iconSize: 60,
      
    );
  }
}