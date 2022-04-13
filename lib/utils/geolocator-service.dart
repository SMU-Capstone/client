import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    return position;
  }
}