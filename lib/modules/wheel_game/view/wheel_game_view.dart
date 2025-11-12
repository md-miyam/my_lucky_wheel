import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:my_lucky_wheel/utils/app_color.dart';

import '../../winner/view/winner_view.dart';
class WheelGameScreen extends StatefulWidget {
  const WheelGameScreen({super.key});

  @override
  State<WheelGameScreen> createState() => _WheelGameScreenState();
}

class _WheelGameScreenState extends State<WheelGameScreen> with SingleTickerProviderStateMixin {
  final List<String> items = [
    'James Smith',
    'Liam Williams',
    'Emma Brown',
    'Noah Jones',
    'Ava Garcia',
    'Elijah Miller',
  ];

  final StreamController<int> selected = StreamController<int>();
  int? lastIndex;
  bool isSpinning = false;

  // Background animation controller
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    // Slow rotating background animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    selected.close();
    _backgroundController.dispose();
    super.dispose();
  }

  void spinWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    int randomNumber = Random().nextInt(items.length);
    lastIndex = randomNumber;
    selected.add(randomNumber);
    print("Selected: ${items[randomNumber]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spinning Wheel Demo"),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Stack(
        children: [
          // ✅ Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    colors: [
                      AppColor.primaryColor.withOpacity(0.3),
                      AppColor.primaryColor.withOpacity(0.5),
                      AppColor.primaryColor.withOpacity(0.7),
                      AppColor.primaryColor.withOpacity(0.5),
                      AppColor.primaryColor.withOpacity(0.3),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    transform: GradientRotation(_backgroundController.value * 2 * pi),
                  ),
                ),
              );
            },
          ),

          // ✅ Decorative circles in background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: CirclesPainter(
                    animation: _backgroundController.value,
                    color: AppColor.primaryColor,
                  ),
                );
              },
            ),
          ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (!isSpinning) {
                    spinWheel();
                  }
                },
                onVerticalDragEnd: (details) {
                  if (!isSpinning) {
                    spinWheel();
                  }
                },
                onTap: () {
                  if (!isSpinning) {
                    spinWheel();
                  }
                },
                child: Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppColor.primaryColor,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: FortuneWheel(
                        selected: selected.stream,
                        animateFirst: false,
                        duration: const Duration(seconds: 6),
                        curve: Curves.easeOutQuart,
                        onAnimationEnd: () {
                          if (lastIndex != null && isSpinning) {
                            setState(() {
                              isSpinning = false;
                            });
                            Future.delayed(const Duration(milliseconds: 500), () {
                              Get.to(
                                    () => WinnerView(
                                  winnerName: items[lastIndex!],
                                ),
                                transition: Transition.downToUp,
                              );
                            });
                          }
                        },
                        items: [
                          for (int i = 0; i < items.length; i++)
                            FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  items[i],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: i.isEven
                                    ? AppColor.primaryColor
                                    : AppColor.primaryColor.withOpacity(0.7),
                                borderColor: Colors.white,
                                borderWidth: 2,
                              ),
                            ),
                        ],
                        indicators: const <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.amber,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSpinning
                      ? Colors.orange.withOpacity(0.8)
                      : Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  isSpinning
                      ? "🎡 Spinning... Wait!"
                      : "👆 Tap or Swipe wheel to spin",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
                onPressed: isSpinning ? null : spinWheel,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.casino, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      isSpinning ? "Spinning..." : "Spin Now",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ✅ Custom Painter for decorative circles
class CirclesPainter extends CustomPainter {
  final double animation;
  final Color color;

  CirclesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw rotating circles
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 2) * (0.3 + i * 0.2);
      final opacity = 0.2 - (i * 0.05);

      paint.color = color.withOpacity(opacity);

      // Rotate circles
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(animation * 2 * pi * (i + 1) * 0.5);
      canvas.translate(-center.dx, -center.dy);

      canvas.drawCircle(center, radius, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) => true;
}