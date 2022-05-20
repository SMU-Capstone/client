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

  Map<String, dynamic> query = {
    'lat': latitude,
    'lon': longitude,
  };

  if (type != null) {
    query['type'] = type;
  }

  try {
    response = await dio.get(
      '/trashcan/range',
      queryParameters: query, 
    );
  } on Exception catch (e) {
    print(e);
  }

  return response!.data;
}
