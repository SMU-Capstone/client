import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class CameraController extends GetxController {

  final ImagePicker _picker = ImagePicker();
  XFile? image;

  Future getImage(ImageSource imageSource) async {
    FormData? _formData;
    final XFile? pickedFile = await _picker.pickImage(
      source: imageSource,
      imageQuality: 30,
    );
    if(pickedFile != null) {
      image = XFile(pickedFile.path);
    }

    if(image != null) {
      _formData = FormData.fromMap({"file": MultipartFile.fromFileSync(image!.path)});
    }

    update();

    //NOTE: 이 부분은 나중에 서버와의 통신을 위해 사용해야할 부분입니다.
    Dio dio = Dio();

    // dio.options.headers["authorization"] = AuthProvider.token;
    dio.options.contentType = "multipart/form-data";
    final res = await dio.post("${dotenv.get('FLASK_BASE_URL')}/predict/", data: _formData )
      .then((res) {
        Get.back();
        return res.data;
      });

    return res;
  }
}