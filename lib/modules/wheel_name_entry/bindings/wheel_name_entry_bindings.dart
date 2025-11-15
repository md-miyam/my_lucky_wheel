import 'package:get/get.dart';
import '../controllers/wheel_name_entry_controllers.dart';

class WheelNameEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WheelNameEntryController>(
          () => WheelNameEntryController(),
    );
  }
}