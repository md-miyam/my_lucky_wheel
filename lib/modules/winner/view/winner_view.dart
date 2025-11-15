import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_color.dart';
import '../controllers/winner_controller.dart';

class WinnerView extends StatelessWidget {
  final String winnerName;

  WinnerView({super.key, required this.winnerName}) {
    // Initialize controller with winner name immediately
    try {
      Get.find<WinnerController>().initialize(winnerName);
    } catch (e) {
      // Controller not found, will be initialized by binding
      debugPrint('WinnerController will be initialized by binding');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final controller = Get.find<WinnerController>();
    if (!controller.isInitialized) {
      controller.initialize(winnerName);
    }

    return Scaffold(
      appBar: const WinnerAppBar(),
      body: const WinnerBody(),
    );
  }
}

class WinnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WinnerAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.darkBackground1,
      leading: const WinnerBackButton(),
    );
  }
}

class WinnerBackButton extends StatelessWidget {
  const WinnerBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.pureWhite.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.pureWhite.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.pureWhite,
          size: 20,
        ),
      ),
    );
  }
}

class WinnerBody extends StatelessWidget {
  const WinnerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColor.darkBackground1,
            AppColor.darkBackground2,
            AppColor.darkBackground3,
          ],
        ),
      ),
      child: Stack(
        children: [
          const WinnerAnimatedBackground(),
          Positioned.fill(child: CustomPaint(painter: WinnerStarsPainter())),
          const WinnerContent(),
        ],
      ),
    );
  }
}

class WinnerAnimatedBackground extends StatelessWidget {
  const WinnerAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
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

class WinnerContent extends StatelessWidget {
  const WinnerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              WinnerTitle(),
              SizedBox(height: 40),
              WinnerCard(),
              SizedBox(height: 60),
              WinnerPlayAgainButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class WinnerTitle extends StatelessWidget {
  const WinnerTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColor.primaryGold, AppColor.secondaryGold],
      ).createShader(bounds),
      child: const Text(
        "🏆GRAND WINNER!🏆",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: AppColor.pureWhite,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class WinnerCard extends StatelessWidget {
  const WinnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WinnerController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.pureWhite.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.primaryGold.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryGold.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        controller.winnerName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColor.pureWhite,
          letterSpacing: 1.5,
          shadows: [Shadow(color: AppColor.shadowBlack87, blurRadius: 8)],
        ),
      ),
    );
  }
}

class WinnerPlayAgainButton extends StatelessWidget {
  const WinnerPlayAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WinnerController>();

    return GestureDetector(
      onTap: controller.playAgain,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.primaryGold, AppColor.primaryPink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryGold.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColor.pureWhite.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, color: AppColor.pureWhite, size: 28),
              SizedBox(width: 12),
              Text(
                "PLAY AGAIN",
                style: TextStyle(
                  color: AppColor.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WinnerStarsPainter extends CustomPainter {
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