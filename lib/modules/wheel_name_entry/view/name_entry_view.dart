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
              "🎯 ADD PARTICIPANTS",
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
      actions: const [
        NameEntryClearButton(),
        SizedBox(width: 4),
      ],
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
          () => controller.participantNames.isEmpty
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
          Positioned.fill(
            child: CustomPaint(painter: NameEntryStarsPainter()),
          ),
          SafeArea(
            child: Column(
              children: const [
                SizedBox(height: 12),
                Flexible(child: NameEntryInputSection()),
                SizedBox(height: 12),
                Expanded(child: NameEntryParticipantsList()),
                NameEntryStartButton(),
                SizedBox(height: 24),
              ],
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

    return SingleChildScrollView(
      child: Padding(
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
                  "Enter Participant Name",
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
                        hintText: "Add Name",
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
                      onSubmitted: (_) => controller.addParticipant(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.addParticipant,
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
                        Icons.add_rounded,
                        color: AppColor.pureWhite,
                        size: screenWidth < 360 ? 22 : 26,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                    () => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Participants: ${controller.participantNames.length} (Min: 2)",
                    style: TextStyle(
                      color: controller.canStartGame.value
                          ? AppColor.primaryGold
                          : AppColor.primaryPink,
                      fontSize: screenWidth < 360 ? 11 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameEntryParticipantsList extends StatelessWidget {
  const NameEntryParticipantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Obx(
          () => controller.participantNames.isEmpty
          ? const NameEntryEmptyState()
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.participantNames.length,
          padding: const EdgeInsets.only(bottom: 4, top: 4),
          itemBuilder: (context, index) {
            return NameEntryParticipantCard(
              name: controller.participantNames[index],
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class NameEntryEmptyState extends StatelessWidget {
  const NameEntryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: screenWidth < 360 ? 60 : 70,
                color: AppColor.pureWhite.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                "No participants yet",
                style: TextStyle(
                  color: AppColor.pureWhite.withValues(alpha: 0.6),
                  fontSize: screenWidth < 360 ? 15 : 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                "Add at least 2 participants to start",
                style: TextStyle(
                  color: AppColor.pureWhite.withValues(alpha: 0.4),
                  fontSize: screenWidth < 360 ? 12 : 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameEntryParticipantCard extends StatelessWidget {
  final String name;
  final int index;

  const NameEntryParticipantCard({
    super.key,
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.pureWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColor.primaryGold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth < 360 ? 32 : 36,
            height: screenWidth < 360 ? 32 : 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColor.primaryGold, AppColor.primaryPink],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: AppColor.pureWhite,
                  fontSize: screenWidth < 360 ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: AppColor.pureWhite,
                fontSize: screenWidth < 360 ? 13 : 15,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => controller.removeParticipant(index),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            icon: Icon(
              Icons.close_rounded,
              color: AppColor.primaryPink.withValues(alpha: 0.8),
              size: screenWidth < 360 ? 18 : 22,
            ),
          ),
        ],
      ),
    );
  }
}

class NameEntryStartButton extends StatelessWidget {
  const NameEntryStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelNameEntryController>();
    final screenWidth = MediaQuery.of(context).size.width;

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
                            : "ADD MORE PARTICIPANTS",
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