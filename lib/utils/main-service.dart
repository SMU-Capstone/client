import 'package:dio/dio.dart';

//지도에 좌표를 가져오는 함수
Future<String> coordinates(double latitude, double longitude) async {

  BaseOptions options = BaseOptions(
    baseUrl: 'http://127.0.0.1:3000',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Dio dio = Dio(options);

  Response? response;

  try {
    response = await dio.get(
      '/trashcan/range',
      queryParameters: {'lat': latitude, 'lon': longitude,}, 
    );
  } on Exception catch (e) {
    print(e);
  }

  return response!.data.toString();
}
