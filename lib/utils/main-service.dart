import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//지도에 좌표를 가져오는 함수
Future coordinates(double latitude, double longitude, int? type) async {

  BaseOptions options = BaseOptions(
    baseUrl: '${dotenv.get('NEST_BASE_URL')}',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Dio dio = Dio(options);

  Response? response;

  try {
    response = await dio.get(
      '/trashcan/range',
      queryParameters: {'lat': latitude, 'lon': longitude, 'type': type}, 
    );
  } on Exception catch (e) {
    print(e);
  }

  return response!.data;
}
