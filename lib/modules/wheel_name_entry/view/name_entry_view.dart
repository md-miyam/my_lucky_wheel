import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_color.dart';
import '../controllers/wheel_name_entry_controllers.dart';

class WheelNameEntryView extends StatelessWidget {
  const WheelNameEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: NameEntryAppBar(),
      body: NameEntryBody(),
    );
  }
}

class NameEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NameEntryAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.darkBackground1,
      leading: const NameEntryBackButton(),
      title: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = constraints.maxWidth < 250 ? 16.0 : 20.0;
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "🍽️ ADD RESTAURANT",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColor.secondaryGold,
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
      ),
      centerTitle: true,
      actions: const [NameEntryClearButton(), SizedBox(width: 4)],
    );
  }
}

class NameEntryBackButton extends StatelessWidget {
  const NameEntryBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.pureWhite.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.pureWhite.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.pureWhite,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class NameEntryClearButton extends StatelessWidget {
  const NameEntryClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();

    return Obx(
          () => controller.restaurantName.isEmpty
          ? const SizedBox.shrink()
          : IconButton(
        onPressed: controller.clearAll,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.primaryPink.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.primaryPink.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.delete_sweep_rounded,
            color: AppColor.primaryPink,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class NameEntryBody extends StatelessWidget {
  const NameEntryBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.darkBackground1,
            AppColor.darkBackground2,
            AppColor.darkBackground3,
          ],
        ),
      ),
      child: Stack(
        children: [
          const NameEntryAnimatedBackground(),
          Positioned.fill(child: CustomPaint(painter: NameEntryStarsPainter())),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const NameEntryInputSection(),
                          SizedBox(height: isKeyboardOpen ? 12 : 24),
                          // Hide or shrink the display card when keyboard is open
                          if (!isKeyboardOpen)
                            const Expanded(child: RestaurantDisplayCard())
                          else
                            const SizedBox(height: 12),
                          if (!isKeyboardOpen) ...[
                            const NameEntryStartButton(),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NameEntryAnimatedBackground extends StatelessWidget {
  const NameEntryAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.2,
        child: Lottie.network(
          'https://assets2.lottiefiles.com/packages/lf20_u4yrau.json',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColor.primaryPink.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NameEntryInputSection extends StatelessWidget {
  const NameEntryInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.pureWhite.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.primaryGold.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryGold.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Enter Restaurant Name",
                style: TextStyle(
                  color: AppColor.secondaryGold,
                  fontSize: screenWidth < 360 ? 13 : 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.nameController,
                    style: TextStyle(
                      color: AppColor.pureWhite,
                      fontSize: screenWidth < 360 ? 13 : 15,
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Restaurant Name",
                      hintStyle: TextStyle(
                        color: AppColor.pureWhite.withValues(alpha: 0.4),
                        fontSize: screenWidth < 360 ? 12 : 13,
                      ),
                      filled: true,
                      fillColor: AppColor.pureWhite.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColor.primaryGold.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColor.primaryGold.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColor.primaryGold,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth < 360 ? 14 : 16,
                        vertical: 14,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (_) => controller.addRestaurant(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.addRestaurant,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColor.primaryGold, AppColor.secondaryGold],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryGold.withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.done,
                      color: AppColor.pureWhite,
                      size: screenWidth < 360 ? 22 : 26,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantDisplayCard extends StatelessWidget {
  const RestaurantDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
          () => controller.restaurantName.isEmpty
          ? const RestaurantEmptyState()
          : Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryGold.withValues(alpha: 0.15),
                  AppColor.primaryPink.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColor.primaryGold.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryGold.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColor.primaryGold,
                        AppColor.primaryPink,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryGold.withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColor.pureWhite,
                    size: screenWidth < 360 ? 40 : 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Selected Restaurant",
                  style: TextStyle(
                    color: AppColor.secondaryGold,
                    fontSize: screenWidth < 360 ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.restaurantName.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.pureWhite,
                    fontSize: screenWidth < 360 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: controller.removeRestaurant,
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primaryPink.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColor.primaryPink.withValues(
                          alpha: 0.5,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColor.primaryPink,
                      size: screenWidth < 360 ? 20 : 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantEmptyState extends StatelessWidget {
  const RestaurantEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.primaryGold.withValues(alpha: 0.08),
                AppColor.primaryPink.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColor.primaryGold.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryGold.withValues(alpha: 0.15),
                      AppColor.primaryPink.withValues(alpha: 0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primaryGold.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  size: screenWidth < 360 ? 50 : 60,
                  color: AppColor.primaryGold.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "No restaurant added yet",
                style: TextStyle(
                  color: AppColor.secondaryGold,
                  fontSize: screenWidth < 360 ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryPink.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.primaryPink.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  "Add a restaurant to continue",
                  style: TextStyle(
                    color: AppColor.primaryPink.withValues(alpha: 0.9),
                    fontSize: screenWidth < 360 ? 13 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameEntryStartButton extends StatelessWidget {
  const NameEntryStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
            () => GestureDetector(
          onTap: controller.canStartGame.value ? controller.startGame : null,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: controller.canStartGame.value
                  ? const LinearGradient(
                colors: [AppColor.primaryGold, AppColor.primaryPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : LinearGradient(
                colors: [
                  AppColor.grey.withValues(alpha: 0.5),
                  AppColor.darkGrey.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: controller.canStartGame.value
                  ? [
                BoxShadow(
                  color: AppColor.primaryGold.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColor.pureWhite.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        controller.canStartGame.value
                            ? "START GAME"
                            : "ADD RESTAURANT FIRST",
                        style: const TextStyle(
                          color: AppColor.pureWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NameEntryStarsPainter extends CustomPainter {
  static const int _starCount = 50;
  static const int _randomSeed = 42;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.pureWhite
      ..style = PaintingStyle.fill;

    final random = Random(_randomSeed);

    for (int i = 0; i < _starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      final opacity = random.nextDouble() * 0.5 + 0.3;

      paint.color = AppColor.pureWhite.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}