import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../winner/bindings/winner_bindings.dart';
import '../../winner/view/winner_view.dart';

class WheelGameController extends GetxController with GetTickerProviderStateMixin {
  // Restaurant name from arguments
  final RxString restaurantName = ''.obs;

  // Participant names list - can be populated from arguments or use default
  final RxList<String> participantNames = <String>[
    'James Smith',
    'Liam Williams',
    'Emma Brown',
    'Noah Jones',
    'Ava Garcia',
    'Olivia Martinez',
    'Olivia Martinez',
    'Olivia Martinez',
  ].obs;

  // State variables
  final StreamController<int> selectedController = StreamController<int>();
  final RxnInt lastSelectedIndex = RxnInt();
  final RxBool isSpinning = false.obs;

  // Animation controllers
  late AnimationController pulseController;
  late AnimationController glowController;
  late Animation<double> pulseAnimation;
  late Animation<double> glowAnimation;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _initializeAnimations();
  }

  void _loadData() {
    // Get data from navigation arguments
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      // Load restaurant name
      if (arguments.containsKey('restaurant')) {
        restaurantName.value = arguments['restaurant'] as String;
      }

      // Load participants if provided
      if (arguments.containsKey('participants')) {
        final List<String> customParticipants = arguments['participants'] as List<String>;
        if (customParticipants.isNotEmpty) {
          participantNames.value = customParticipants;
        }
      }
    }
  }

  void _initializeAnimations() {
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );
  }

  void spinWheel() {
    if (isSpinning.value) return;

    isSpinning.value = true;

    final randomIndex = Random().nextInt(participantNames.length);
    lastSelectedIndex.value = randomIndex;
    selectedController.add(randomIndex);
    debugPrint("Selected: ${participantNames[randomIndex]}");
  }

  void handleSpinComplete() {
    if (lastSelectedIndex.value == null || !isSpinning.value) return;

    isSpinning.value = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.to(
            () => WinnerView(winnerName: participantNames[lastSelectedIndex.value!]),
        binding: WinnerBinding(),
        transition: Transition.downToUp,
      );
    });
  }

  @override
  void onClose() {
    selectedController.close();
    pulseController.dispose();
    glowController.dispose();
    super.onClose();
  }
}