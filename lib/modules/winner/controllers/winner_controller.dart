import 'package:get/get.dart';

class WinnerController extends GetxController {
  String _winnerName = '';
  bool isInitialized = false;

  String get winnerName => _winnerName;

  void initialize(String name) {
    if (!isInitialized) {
      _winnerName = name;
      isInitialized = true;
    }
  }

  void playAgain() {
    Get.back();
  }

  @override
  void onClose() {
    isInitialized = false;
    super.onClose();
  }
}