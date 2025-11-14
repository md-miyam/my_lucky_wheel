import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_color.dart';
import '../../winner/view/winner_view.dart';

class WheelGameView extends StatefulWidget {
  const WheelGameView({super.key});

  @override
  State<WheelGameView> createState() => _WheelGameViewState();
}

class _WheelGameViewState extends State<WheelGameView>
    with TickerProviderStateMixin {
  // Constants
  static const List<String> _participantNames = [
    'James Smith',
    'Liam Williams',
    'Emma Brown',
    'Noah Jones',
    'Ava Garcia',
    'Emma Brown',
    'Noah Jones',
  ];

  // State variables
  final StreamController<int> _selectedController = StreamController<int>();
  int? _lastSelectedIndex;
  bool _isSpinning = false;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _selectedController.close();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;

    setState(() => _isSpinning = true);

    final randomIndex = Random().nextInt(_participantNames.length);
    _lastSelectedIndex = randomIndex;
    _selectedController.add(randomIndex);
    debugPrint("Selected: ${_participantNames[randomIndex]}");
  }

  void _handleSpinComplete() {
    if (_lastSelectedIndex == null || !_isSpinning) return;

    setState(() => _isSpinning = false);

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.to(
        () => WinnerView(winnerName: _participantNames[_lastSelectedIndex!]),
        transition: Transition.downToUp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.darkBackground1,
      leading: _buildBackButton(),
      title: const Text(
        "🎰 LUCKY WHEEL",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColor.secondaryGold,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBackButton() {
    return IconButton(
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
    );
  }

  Widget _buildBody() {
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
          _buildAnimatedBackground(),
          Positioned.fill(child: CustomPaint(painter: _StarsPainter())),
          _buildWheelSection(),
          _buildSpinButton(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Positioned.fill(
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
        ),
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0, -0.15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size =
                    min(constraints.maxWidth, constraints.maxHeight) * 0.95;
                return SizedBox(
                  height: size,
                  width: size,
                  child: Stack(
                    children: [
                      Lottie.asset(
                        'assets/animations/wheel_bg.json',
                        fit: BoxFit.cover,
                      ),
                      Lottie.asset(
                        'assets/animations/wheel_bg.json',
                        reverse: true,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWheelSection() {
    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wheelSize =
                  min(constraints.maxWidth, constraints.maxHeight) * 0.85;
              return GestureDetector(
                onTap: _isSpinning ? null : _spinWheel,
                onHorizontalDragEnd: _isSpinning ? null : (_) => _spinWheel(),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isSpinning ? 1.0 : _pulseAnimation.value,
                      child: SizedBox(
                        height: wheelSize,
                        width: wheelSize,
                        child: _buildWheelWithEffects(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWheelWithEffects() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        final glowSize = size * 1.2;
        final wheelSize = size * 0.85;
        final centerSize = size * 0.12;

        return Stack(
          alignment: Alignment.center,
          children: [
            _buildGlowEffect(glowSize),
            _buildWheelContainer(wheelSize),
            _buildCenterDecoration(centerSize),
          ],
        );
      },
    );
  }

  Widget _buildGlowEffect(double size) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryGold.withOpacity(
                  _glowAnimation.value * 0.3,
                ),
                blurRadius: size * 0.11,
                spreadRadius: size * 0.028,
              ),
              BoxShadow(
                color: AppColor.primaryPink.withOpacity(
                  _glowAnimation.value * 0.2,
                ),
                blurRadius: size * 0.17,
                spreadRadius: size * 0.056,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWheelContainer(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [AppColor.pureWhite.withOpacity(0.1), Colors.transparent],
        ),
        border: Border.all(color: AppColor.primaryGold, width: size * 0.014),
        boxShadow: [
          BoxShadow(
            color: AppColor.pureBlack.withOpacity(0.5),
            blurRadius: size * 0.107,
            spreadRadius: size * 0.018,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.pureWhite.withOpacity(0.05),
          ),
          child: _buildFortuneWheel(),
        ),
      ),
    );
  }

  Widget _buildFortuneWheel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        final fontSize = size * 0.05;
        final borderWidth = size * 0.01;
        final indicatorSize = size * 0.14;

        return FortuneWheel(
          selected: _selectedController.stream,
          animateFirst: false,
          duration: const Duration(seconds: 6),
          curve: Curves.easeOutQuart,
          onAnimationEnd: _handleSpinComplete,
          items: List.generate(
            _participantNames.length,
            (index) => FortuneItem(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                child: Text(
                  _participantNames[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: AppColor.pureWhite,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(color: AppColor.shadowBlack54, blurRadius: 4),
                    ],
                  ),
                ),
              ),
              style: FortuneItemStyle(
                color:
                    AppColor.wheelColors[index % AppColor.wheelColors.length],
                borderColor: AppColor.pureWhite,
                borderWidth: borderWidth,
              ),
            ),
          ),
          indicators: [
            FortuneIndicator(
              alignment: Alignment.topCenter,
              child: TriangleIndicator(
                color: AppColor.primaryGold,
                width: indicatorSize,
                height: indicatorSize,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCenterDecoration(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColor.primaryGold, AppColor.secondaryGold],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryGold.withOpacity(0.5),
            blurRadius: size * 0.33,
            spreadRadius: size * 0.033,
          ),
        ],
      ),
      child: Icon(
        Icons.stars_rounded,
        color: AppColor.pureWhite,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildSpinButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: GestureDetector(
          onTap: _isSpinning ? null : _spinWheel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              gradient: _isSpinning
                  ? const LinearGradient(
                      colors: [AppColor.grey, AppColor.darkGrey],
                    )
                  : const LinearGradient(
                      colors: [AppColor.primaryGold, AppColor.primaryPink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _isSpinning
                      ? AppColor.shadowBlack26
                      : AppColor.primaryGold.withOpacity(0.5),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSpinning ? Icons.hourglass_empty : Icons.casino,
                    color: AppColor.pureWhite,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isSpinning ? "SPINNING" : "SPIN NOW",
                    style: const TextStyle(
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
