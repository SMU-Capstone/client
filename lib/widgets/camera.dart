import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as g;
import 'package:image_picker/image_picker.dart';

class UseCamera extends StatefulWidget {
  const UseCamera({ Key? key }) : super(key: key);

  @override
  State<UseCamera> createState() => _UseCameraState();
}

class _UseCameraState extends State<UseCamera> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    
    Future getImage(ImageSource imageSource) async {
      FormData? _formData;
      final XFile? pickedFile = await _picker.pickImage(
        source: imageSource,
        imageQuality: 30,
      );
      if(pickedFile != null) {
        setState(() {
          _image = XFile(pickedFile.path);
        }); 
      }

      if(_image != null) {
        _formData = FormData.fromMap({"file": MultipartFile.fromFileSync(_image!.path)});
      }

      //NOTE: 이 부분은 나중에 서버와의 통신을 위해 사용해야할 부분입니다.
      Dio dio = Dio();

      // dio.options.headers["authorization"] = AuthProvider.token;
      dio.options.contentType = "multipart/form-data";
      final res = await dio.post("${dotenv.get('FLASK_BASE_URL')}/predict/", data: _formData )
        .then((res) {
          g.Get.back();
          return res.data;
        });

      return res;
    }

    return IconButton(
      onPressed: () async {
        //카메라 버튼이 눌렸을 경우 실행되는 함수
        final data = await getImage(ImageSource.camera);
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



