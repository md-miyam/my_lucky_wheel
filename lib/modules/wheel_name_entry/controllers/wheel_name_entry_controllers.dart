import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../routes/app_pages.dart';

class WheelNameEntryController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final RxList<String> participantNames = <String>[].obs;
  final RxBool canStartGame = false.obs;

  @override
  void onInit() {
    super.onInit();
    participantNames.listen((_) {
      _updateGameStatus();
    });
  }

  void _updateGameStatus() {
    canStartGame.value = participantNames.length >= 2;
  }

  void addParticipant() {
    final name = nameController.text.trim();

    // Invalid Name
    if (name.isEmpty) {
      Get.snackbar(
        'Invalid Name',
        'Please enter a valid name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Duplicate Name
    if (participantNames.contains(name)) {
      Get.snackbar(
        'Duplicate Name',
        'This name already exists',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.secondaryGold.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    participantNames.add(name);
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

  void removeParticipant(int index) {
    if (index >= 0 && index < participantNames.length) {
      final removedName = participantNames[index];
      participantNames.removeAt(index);

      Get.snackbar(
        'Removed',
        '$removedName removed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void startGame() {
    if (participantNames.length < 2) {
      Get.snackbar(
        'Not Enough Participants',
        'Please add at least 2 participants',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primaryPink.withValues(alpha: 0.9),
        colorText: AppColor.pureWhite,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Get.toNamed(
      Routes.WHEEL_GAME,
      arguments: {'participants': participantNames.toList()},
    );
  }

  void clearAll() {
    participantNames.clear();
    nameController.clear();

    Get.snackbar(
      'Cleared',
      'All participants removed',
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
