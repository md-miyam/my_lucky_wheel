import 'package:get/get.dart';
import '../controllers/wheel_game_controller.dart';

class WheelGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WheelGameController>(
          () => WheelGameController(),
    );
  }
}