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

Future applyTrash(double latitude, double longitude, int type, int note) async {
  BaseOptions options = BaseOptions(
    baseUrl: '${dotenv.get('NEST_BASE_URL')}',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Dio dio = Dio(options);

  Response? response;

  try {
    response = await dio.post('/application', data: {
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'note': note
    });
  } on Exception catch (e) {
    print(e);
  }
}

Future applyCleaning(int trashcanId, int note) async {
  BaseOptions options = BaseOptions(
    baseUrl: '${dotenv.get('NEST_BASE_URL')}',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Dio dio = Dio(options);

  Response? response;

  try {
    response = await dio
        .post('/cleaning', data: {'trashcanId': trashcanId, 'note': note});
  } on Exception catch (e) {
    print(e);
  }
}

Future getNearestTrashcan(double latitude, double longitude, int? type) async {
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
      '/trashcan/nearest',
      queryParameters: query,
    );
  } on Exception catch (e) {
    print(e);
  }

  return response!.data;
}
