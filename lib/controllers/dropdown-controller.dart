import 'package:get/get.dart';

class DropdownController extends GetxController {
  RxString _dropdownValue = '모든 쓰레기통'.obs;
  final List<String> _valueList = ['모든 쓰레기통', '일반 쓰레기통', '재활용 쓰레기통'];

  RxString get dropdownValue => _dropdownValue;
  List<String> get valueList => _valueList;

  set dropdownValue(RxString value) => _dropdownValue = value;

  changeValue(RxString selectedValue) {
    _dropdownValue = selectedValue;
    update();
  }
}
