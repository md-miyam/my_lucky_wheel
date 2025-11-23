import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../routes/app_pages.dart';

class WheelNameEntryController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final RxString restaurantName = ''.obs;
  final RxBool canStartGame = false.obs;

  @override
  void onInit() {
    super.onInit();
    restaurantName.listen((_) {
      _updateGameStatus();
    });
  }

  void _updateGameStatus() {
    canStartGame.value = restaurantName.value.isNotEmpty;
  }

  void addRestaurant() {
    final name = nameController.text.trim();

    // Invalid Name
    if (name.isEmpty) {
      Get.snackbar(
        'Invalid Name',
        'Please enter a valid restaurant name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    restaurantName.value = name;
    nameController.clear();

    Get.snackbar(
      'Success',
      '$name added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primaryGreen.withValues(alpha: 0.9),
      colorText: AppColor.pureWhite,
      duration: const Duration(seconds: 1),
    );
  }

  void removeRestaurant() {
    final removedName = restaurantName.value;
    restaurantName.value = '';

    Get.snackbar(
      'Removed',
      '$removedName removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
      colorText: AppColor.pureWhite,
      duration: const Duration(seconds: 1),
    );
  }

  void startGame() {
    if (restaurantName.value.isEmpty) {
      Get.snackbar(
        'No Restaurant',
        'Please add a restaurant name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Navigate to wheel game without passing any participants
    // The wheel will use its default 6 player names
    Get.toNamed(Routes.WHEEL_GAME);
  }

  void clearAll() {
    restaurantName.value = '';
    nameController.clear();

    Get.snackbar(
      'Cleared',
      'Restaurant removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.secondaryGold.withValues(alpha: 0.9),
      colorText: AppColor.pureWhite,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}