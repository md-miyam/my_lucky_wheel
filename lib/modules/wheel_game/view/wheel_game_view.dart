// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import '../../../utils/app_color.dart';
// import '../controllers/wheel_game_controller.dart';
//
// class WheelGameView extends StatelessWidget {
//   const WheelGameView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: WheelAppBar(), body: WheelBody());
//   }
// }
//
// class WheelAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const WheelAppBar({super.key});
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColor.darkBackground1,
//       leading: const WheelBackButton(),
//       title: const Text(
//         "🎰 LUCKY WHEEL",
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: AppColor.secondaryGold,
//           letterSpacing: 2,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
// }
//
// class WheelBackButton extends StatelessWidget {
//   const WheelBackButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () => Get.back(),
//       icon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColor.pureWhite.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: AppColor.pureWhite.withValues(alpha: 0.2),
//             width: 1,
//           ),
//         ),
//         child: const Icon(
//           Icons.arrow_back_ios_new,
//           color: AppColor.pureWhite,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }
//
// class WheelBody extends StatelessWidget {
//   const WheelBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColor.darkBackground1,
//             AppColor.darkBackground2,
//             AppColor.darkBackground3,
//           ],
//         ),
//       ),
//       child: Stack(
//         children: [
//           const WheelAnimatedBackground(),
//           Positioned.fill(child: CustomPaint(painter: StarsPainter())),
//           const WheelSection(),
//           const WheelSpinButton(),
//         ],
//       ),
//     );
//   }
// }
//
// class WheelAnimatedBackground extends StatelessWidget {
//   const WheelAnimatedBackground({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Opacity(
//             opacity: 0.3,
//             child: Lottie.network(
//               'https://assets2.lottiefiles.com/packages/lf20_u4yrau.json',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     gradient: RadialGradient(
//                       colors: [
//                         AppColor.primaryPink.withValues(alpha: 0.1),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: Align(
//             alignment: const Alignment(0, -0.15),
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final size =
//                     min(constraints.maxWidth, constraints.maxHeight) * 0.95;
//                 return SizedBox(
//                   height: size,
//                   width: size,
//                   child: Stack(
//                     children: [
//                       Lottie.asset(
//                         'assets/animations/wheel_bg.json',
//                         fit: BoxFit.cover,
//                       ),
//                       Lottie.asset(
//                         'assets/animations/wheel_bg.json',
//                         reverse: true,
//                         fit: BoxFit.cover,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class WheelSection extends StatelessWidget {
//   const WheelSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<WheelGameController>();
//
//     return Positioned.fill(
//       child: SafeArea(
//         child: Align(
//           alignment: const Alignment(0, -0.15),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final wheelSize =
//                   min(constraints.maxWidth, constraints.maxHeight) * 0.85;
//               return Obx(
//                 () => GestureDetector(
//                   onTap: controller.isSpinning.value
//                       ? null
//                       : controller.spinWheel,
//                   onHorizontalDragEnd: controller.isSpinning.value
//                       ? null
//                       : (_) => controller.spinWheel(),
//                   child: AnimatedBuilder(
//                     animation: controller.pulseAnimation,
//                     builder: (context, child) {
//                       return Transform.scale(
//                         scale: controller.isSpinning.value
//                             ? 1.0
//                             : controller.pulseAnimation.value,
//                         child: SizedBox(
//                           height: wheelSize,
//                           width: wheelSize,
//                           child: const WheelWithEffects(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WheelWithEffects extends StatelessWidget {
//   const WheelWithEffects({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final size = min(constraints.maxWidth, constraints.maxHeight);
//         final glowSize = size * 1.2;
//         final wheelSize = size * 0.85;
//         final centerSize = size * 0.12;
//
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             WheelGlowEffect(size: glowSize),
//             WheelContainer(size: wheelSize),
//             WheelCenterDecoration(size: centerSize),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class WheelGlowEffect extends StatelessWidget {
//   final double size;
//
//   const WheelGlowEffect({super.key, required this.size});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<WheelGameController>();
//
//     return AnimatedBuilder(
//       animation: controller.glowAnimation,
//       builder: (context, child) {
//         return Container(
//           height: size,
//           width: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: AppColor.primaryGold.withValues(
//                   alpha: controller.glowAnimation.value * 0.3,
//                 ),
//                 blurRadius: size * 0.11,
//                 spreadRadius: size * 0.028,
//               ),
//               BoxShadow(
//                 color: AppColor.primaryPink.withValues(
//                   alpha: controller.glowAnimation.value * 0.2,
//                 ),
//                 blurRadius: size * 0.17,
//                 spreadRadius: size * 0.056,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class WheelContainer extends StatelessWidget {
//   final double size;
//
//   const WheelContainer({super.key, required this.size});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: size,
//       width: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient(
//           colors: [
//             AppColor.pureWhite.withValues(alpha: 0.1),
//             Colors.transparent,
//           ],
//         ),
//         border: Border.all(color: AppColor.primaryGold, width: size * 0.014),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.pureBlack.withValues(alpha: 0.5),
//             blurRadius: size * 0.107,
//             spreadRadius: size * 0.018,
//           ),
//         ],
//       ),
//       child: ClipOval(
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColor.pureWhite.withValues(alpha: 0.05),
//           ),
//           child: const WheelFortuneWheel(),
//         ),
//       ),
//     );
//   }
// }
//
// class WheelFortuneWheel extends StatelessWidget {
//   const WheelFortuneWheel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<WheelGameController>();
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final size = min(constraints.maxWidth, constraints.maxHeight);
//         final fontSize = size * 0.05;
//         final borderWidth = size * 0.01;
//         final indicatorSize = size * 0.14;
//
//         return FortuneWheel(
//           selected: controller.selectedController.stream,
//           animateFirst: false,
//           duration: const Duration(seconds: 6),
//           curve: Curves.easeOutQuart,
//           onAnimationEnd: controller.handleSpinComplete,
//           items: List.generate(
//             WheelGameController.participantNames.length,
//             (index) => FortuneItem(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: size * 0.04),
//                 child: Text(
//                   WheelGameController.participantNames[index],
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     color: AppColor.pureWhite,
//                     fontWeight: FontWeight.bold,
//                     shadows: const [
//                       Shadow(color: AppColor.shadowBlack54, blurRadius: 4),
//                     ],
//                   ),
//                 ),
//               ),
//               style: FortuneItemStyle(
//                 color:
//                     AppColor.wheelColors[index % AppColor.wheelColors.length],
//                 borderColor: AppColor.pureWhite,
//                 borderWidth: borderWidth,
//               ),
//             ),
//           ),
//           indicators: [
//             FortuneIndicator(
//               alignment: Alignment.topCenter,
//               child: TriangleIndicator(
//                 color: AppColor.primaryGold,
//                 width: indicatorSize,
//                 height: indicatorSize,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class WheelCenterDecoration extends StatelessWidget {
//   final double size;
//
//   const WheelCenterDecoration({super.key, required this.size});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: size,
//       width: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: const LinearGradient(
//           colors: [AppColor.primaryGold, AppColor.secondaryGold],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.primaryGold.withValues(alpha: 0.5),
//             blurRadius: size * 0.33,
//             spreadRadius: size * 0.033,
//           ),
//         ],
//       ),
//       child: Icon(
//         Icons.stars_rounded,
//         color: AppColor.pureWhite,
//         size: size * 0.5,
//       ),
//     );
//   }
// }
//
// class WheelSpinButton extends StatelessWidget {
//   const WheelSpinButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<WheelGameController>();
//
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 40),
//         child: Obx(
//           () => GestureDetector(
//             onTap: controller.isSpinning.value ? null : controller.spinWheel,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 200,
//               height: 50,
//               decoration: BoxDecoration(
//                 gradient: controller.isSpinning.value
//                     ? const LinearGradient(
//                         colors: [AppColor.grey, AppColor.darkGrey],
//                       )
//                     : const LinearGradient(
//                         colors: [AppColor.primaryGold, AppColor.primaryPink],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: controller.isSpinning.value
//                         ? AppColor.shadowBlack26
//                         : AppColor.primaryGold.withValues(alpha: 0.5),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(
//                     color: AppColor.pureWhite.withValues(alpha: 0.3),
//                     width: 2,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       controller.isSpinning.value
//                           ? Icons.hourglass_empty
//                           : Icons.casino,
//                       color: AppColor.pureWhite,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       controller.isSpinning.value ? "SPINNING" : "SPIN NOW",
//                       style: const TextStyle(
//                         color: AppColor.pureWhite,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class StarsPainter extends CustomPainter {
//   static const int _starCount = 50;
//   static const int _randomSeed = 42;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppColor.pureWhite
//       ..style = PaintingStyle.fill;
//
//     final random = Random(_randomSeed);
//
//     for (int i = 0; i < _starCount; i++) {
//       final x = random.nextDouble() * size.width;
//       final y = random.nextDouble() * size.height;
//       final radius = random.nextDouble() * 2 + 1;
//       final opacity = random.nextDouble() * 0.5 + 0.3;
//
//       paint.color = AppColor.pureWhite.withValues(alpha: opacity);
//       canvas.drawCircle(Offset(x, y), radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_color.dart';
import '../controllers/wheel_game_controller.dart';

class WheelGameView extends StatelessWidget {
  const WheelGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WheelAppBar(),
      body: WheelBody(),
    );
  }
}

class WheelAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WheelAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.darkBackground1,
      leading: const WheelBackButton(),
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
}

class WheelBackButton extends StatelessWidget {
  const WheelBackButton({super.key});

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

class WheelBody extends StatelessWidget {
  const WheelBody({super.key});

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
          const WheelAnimatedBackground(),
          Positioned.fill(child: CustomPaint(painter: StarsPainter())),
          const WheelSection(),
          const WheelSpinButton(),
        ],
      ),
    );
  }
}

class WheelAnimatedBackground extends StatelessWidget {
  const WheelAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
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
                        AppColor.primaryPink.withValues(alpha: 0.1),
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
}

class WheelSection extends StatelessWidget {
  const WheelSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelGameController>();

    return Positioned.fill(
      child: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wheelSize =
                  min(constraints.maxWidth, constraints.maxHeight) * 0.85;
              return Obx(
                    () => GestureDetector(
                  onTap: controller.isSpinning.value ? null : controller.spinWheel,
                  onHorizontalDragEnd: controller.isSpinning.value
                      ? null
                      : (_) => controller.spinWheel(),
                  child: AnimatedBuilder(
                    animation: controller.pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.isSpinning.value
                            ? 1.0
                            : controller.pulseAnimation.value,
                        child: SizedBox(
                          height: wheelSize,
                          width: wheelSize,
                          child: const WheelWithEffects(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WheelWithEffects extends StatelessWidget {
  const WheelWithEffects({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        final glowSize = size * 1.2;
        final wheelSize = size * 0.85;
        final centerSize = size * 0.12;

        return Stack(
          alignment: Alignment.center,
          children: [
            WheelGlowEffect(size: glowSize),
            WheelContainer(size: wheelSize),
            WheelCenterDecoration(size: centerSize),
          ],
        );
      },
    );
  }
}

class WheelGlowEffect extends StatelessWidget {
  final double size;

  const WheelGlowEffect({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelGameController>();

    return AnimatedBuilder(
      animation: controller.glowAnimation,
      builder: (context, child) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryGold.withValues(
                  alpha: controller.glowAnimation.value * 0.3,
                ),
                blurRadius: size * 0.11,
                spreadRadius: size * 0.028,
              ),
              BoxShadow(
                color: AppColor.primaryPink.withValues(
                  alpha: controller.glowAnimation.value * 0.2,
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
}

class WheelContainer extends StatelessWidget {
  final double size;

  const WheelContainer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [AppColor.pureWhite.withValues(alpha: 0.1), Colors.transparent],
        ),
        border: Border.all(color: AppColor.primaryGold, width: size * 0.014),
        boxShadow: [
          BoxShadow(
            color: AppColor.pureBlack.withValues(alpha: 0.5),
            blurRadius: size * 0.107,
            spreadRadius: size * 0.018,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.pureWhite.withValues(alpha: 0.05),
          ),
          child: const WheelFortuneWheel(),
        ),
      ),
    );
  }
}

class WheelFortuneWheel extends StatelessWidget {
  const WheelFortuneWheel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelGameController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        final fontSize = size * 0.05;
        final borderWidth = size * 0.01;
        final indicatorSize = size * 0.14;

        return Obx(
              () => FortuneWheel(
            selected: controller.selectedController.stream,
            animateFirst: false,
            duration: const Duration(seconds: 6),
            curve: Curves.easeOutQuart,
            onAnimationEnd: controller.handleSpinComplete,
            items: List.generate(
              controller.participantNames.length,
                  (index) => FortuneItem(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size * 0.04),
                  child: Text(
                    controller.participantNames[index],
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
          ),
        );
      },
    );
  }
}

class WheelCenterDecoration extends StatelessWidget {
  final double size;

  const WheelCenterDecoration({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
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
            color: AppColor.primaryGold.withValues(alpha: 0.5),
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
}

class WheelSpinButton extends StatelessWidget {
  const WheelSpinButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WheelGameController>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Obx(
              () => GestureDetector(
            onTap: controller.isSpinning.value ? null : controller.spinWheel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                gradient: controller.isSpinning.value
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
                    color: controller.isSpinning.value
                        ? AppColor.shadowBlack26
                        : AppColor.primaryGold.withValues(alpha: 0.5),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.isSpinning.value
                          ? Icons.hourglass_empty
                          : Icons.casino,
                      color: AppColor.pureWhite,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      controller.isSpinning.value ? "SPINNING" : "SPIN NOW",
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
      ),
    );
  }
}

class StarsPainter extends CustomPainter {
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