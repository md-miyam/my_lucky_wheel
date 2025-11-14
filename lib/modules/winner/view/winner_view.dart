import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_color.dart';

class WinnerView extends StatelessWidget {
  final String winnerName;

  const WinnerView({super.key, required this.winnerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            _buildAnimatedBackground(),
            Positioned.fill(child: CustomPaint(painter: _StarsPainter())),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
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
                    AppColor.primaryPink.withOpacity(0.1),
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

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildBackButton(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 40),
                    _buildWinnerCard(),
                    const SizedBox(height: 60),
                    _buildPlayAgainButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.pureWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.pureWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.pureWhite,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
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
          shadows: [
            Shadow(
              color: AppColor.shadowBlack45,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.pureWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.primaryGold.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryGold.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        winnerName,
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

  Widget _buildPlayAgainButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 220,
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
              color: AppColor.primaryGold.withOpacity(0.5),
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
              color: AppColor.pureWhite.withOpacity(0.3),
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

class _StarsPainter extends CustomPainter {
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

      paint.color = AppColor.pureWhite.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
