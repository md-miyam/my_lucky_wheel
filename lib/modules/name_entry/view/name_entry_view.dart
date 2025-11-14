// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import '../../winner/view/winner_view.dart';
//
// class SpinWheelView extends StatefulWidget {
//   const SpinWheelView({super.key});
//
//   @override
//   State<SpinWheelView> createState() => _SpinWheelViewState();
// }
//
// class _SpinWheelViewState extends State<SpinWheelView>
//     with TickerProviderStateMixin {
//   final List<String> items = [
//     'James Smith',
//     'Liam Williams',
//     'Emma Brown',
//     'Noah Jones',
//     'Ava Garcia',
//     'Elijah Miller',
//   ];
//
//   final StreamController<int> selected = StreamController<int>();
//   int? lastIndex;
//   bool isSpinning = false;
//
//   late AnimationController _pulseController;
//   late AnimationController _glowController;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _glowAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Pulse animation for the wheel
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     // Glow animation
//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);
//     _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     selected.close();
//     _pulseController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }
//
//   void spinWheel() {
//     if (isSpinning) return;
//
//     setState(() {
//       isSpinning = true;
//     });
//
//     int randomNumber = Random().nextInt(items.length);
//     lastIndex = randomNumber;
//     selected.add(randomNumber);
//     print("Selected: ${items[randomNumber]}");
//   }
//
//   // Color palette for wheel items
//   final List<Color> wheelColors = [
//     Color(0xFFFF6B6B), // Red
//     Color(0xFF4ECDC4), // Cyan
//     Color(0xFFFFE66D), // Yellow
//     Color(0xFF95E1D3), // Mint
//     Color(0xFFF38181), // Pink
//     Color(0xFFAA96DA), // Purple
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF1a1a2e),
//               Color(0xFF16213e),
//               Color(0xFF0f3460),
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // ✅ Animated particles background using Lottie
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0.3,
//                 child: Lottie.network(
//                   'https://assets2.lottiefiles.com/packages/lf20_u4yrau.json',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         gradient: RadialGradient(
//                           colors: [
//                             Colors.purple.withOpacity(0.1),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // ✅ Floating stars/sparkles
//             Positioned.fill(
//               child: CustomPaint(
//                 painter: StarsPainter(),
//               ),
//             ),
//
//             SafeArea(
//               child: Column(
//                 children: [
//                   // ✅ Premium Header
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () => Get.back(),
//                           icon: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.arrow_back_ios_new,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                         ShaderMask(
//                           shaderCallback: (bounds) => LinearGradient(
//                             colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
//                           ).createShader(bounds),
//                           child: Text(
//                             "🎰 LUCKY WHEEL",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 2,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 48),
//                       ],
//                     ),
//                   ),
//
//                   Expanded(
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // ✅ Premium Wheel with glow effect
//                           GestureDetector(
//                             onTap: () {
//                               if (!isSpinning) {
//                                 spinWheel();
//                               }
//                             },
//                             onHorizontalDragEnd: (details) {
//                               if (!isSpinning) {
//                                 spinWheel();
//                               }
//                             },
//                             child: AnimatedBuilder(
//                               animation: _pulseAnimation,
//                               builder: (context, child) {
//                                 return Transform.scale(
//                                   scale: isSpinning ? 1.0 : _pulseAnimation.value,
//                                   child: Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       // Outer glow rings
//                                       AnimatedBuilder(
//                                         animation: _glowAnimation,
//                                         builder: (context, child) {
//                                           return Container(
//                                             height: 360,
//                                             width: 360,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Color(0xFFFFD700)
//                                                       .withOpacity(_glowAnimation.value * 0.3),
//                                                   blurRadius: 40,
//                                                   spreadRadius: 10,
//                                                 ),
//                                                 BoxShadow(
//                                                   color: Color(0xFFFF6B6B)
//                                                       .withOpacity(_glowAnimation.value * 0.2),
//                                                   blurRadius: 60,
//                                                   spreadRadius: 20,
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//
//                                       // Main wheel container
//                                       Container(
//                                         height: 320,
//                                         width: 320,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: RadialGradient(
//                                             colors: [
//                                               Colors.white.withOpacity(0.1),
//                                               Colors.transparent,
//                                             ],
//                                           ),
//                                           border: Border.all(
//                                             color: Color(0xFFFFD700),
//                                             width: 4,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(0.5),
//                                               blurRadius: 30,
//                                               spreadRadius: 5,
//                                             ),
//                                           ],
//                                         ),
//                                         child: ClipOval(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white.withOpacity(0.05),
//                                             ),
//                                             child: FortuneWheel(
//                                               selected: selected.stream,
//                                               animateFirst: false,
//                                               duration: const Duration(seconds: 6),
//                                               curve: Curves.easeOutQuart,
//                                               onAnimationEnd: () {
//                                                 if (lastIndex != null && isSpinning) {
//                                                   setState(() {
//                                                     isSpinning = false;
//                                                   });
//                                                   Future.delayed(
//                                                       const Duration(milliseconds: 500), () {
//                                                     Get.to(
//                                                           () => WinnerView(
//                                                         winnerName: items[lastIndex!],
//                                                       ),
//                                                       transition: Transition.downToUp,
//                                                     );
//                                                   });
//                                                 }
//                                               },
//                                               items: [
//                                                 for (int i = 0; i < items.length; i++)
//                                                   FortuneItem(
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(
//                                                           horizontal: 12.0),
//                                                       child: Text(
//                                                         items[i],
//                                                         textAlign: TextAlign.center,
//                                                         style: const TextStyle(
//                                                           fontSize: 15,
//                                                           color: Colors.white,
//                                                           fontWeight: FontWeight.bold,
//                                                           shadows: [
//                                                             Shadow(
//                                                               color: Colors.black54,
//                                                               blurRadius: 4,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     style: FortuneItemStyle(
//                                                       color: wheelColors[i % wheelColors.length],
//                                                       borderColor: Colors.white,
//                                                       borderWidth: 3,
//                                                     ),
//                                                   ),
//                                               ],
//                                               indicators: const <FortuneIndicator>[
//                                                 FortuneIndicator(
//                                                   alignment: Alignment.topCenter,
//                                                   child: TriangleIndicator(
//                                                     color: Color(0xFFFFD700),
//                                                     width: 40,
//                                                     height: 40,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//
//                                       // Center circle decoration
//                                       Container(
//                                         height: 60,
//                                         width: 60,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               Color(0xFFFFD700),
//                                               Color(0xFFFFAA00),
//                                             ],
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Color(0xFFFFD700).withOpacity(0.5),
//                                               blurRadius: 20,
//                                               spreadRadius: 2,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Icon(
//                                           Icons.stars_rounded,
//                                           color: Colors.white,
//                                           size: 30,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//
//                           const SizedBox(height: 50),
//
//                           // ✅ Status indicator
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30, vertical: 12),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: isSpinning
//                                     ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
//                                     : [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//                               ),
//                               borderRadius: BorderRadius.circular(25),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: (isSpinning
//                                       ? Color(0xFFFF6B6B)
//                                       : Color(0xFF4ECDC4))
//                                       .withOpacity(0.4),
//                                   blurRadius: 20,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 if (isSpinning)
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                     ),
//                                   )
//                                 else
//                                   Icon(Icons.touch_app, color: Colors.white, size: 20),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   isSpinning
//                                       ? "Spinning... 🎡"
//                                       : "Tap wheel to spin! 👆",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 30),
//
//                           // ✅ Premium Spin Button
//                           GestureDetector(
//                             onTap: isSpinning ? null : spinWheel,
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               width: 200,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 gradient: isSpinning
//                                     ? LinearGradient(
//                                   colors: [Colors.grey, Colors.grey.shade600],
//                                 )
//                                     : LinearGradient(
//                                   colors: [
//                                     Color(0xFFFFD700),
//                                     Color(0xFFFFAA00),
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: isSpinning
//                                         ? Colors.black26
//                                         : Color(0xFFFFD700).withOpacity(0.5),
//                                     blurRadius: 20,
//                                     spreadRadius: 2,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(0.3),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       isSpinning ? Icons.hourglass_empty : Icons.casino,
//                                       color: Colors.white,
//                                       size: 28,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       isSpinning ? "SPINNING" : "SPIN NOW",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         letterSpacing: 2,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ✅ Custom painter for stars
// class StarsPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     final random = Random(42); // Fixed seed for consistent stars
//
//     for (int i = 0; i < 50; i++) {
//       final x = random.nextDouble() * size.width;
//       final y = random.nextDouble() * size.height;
//       final radius = random.nextDouble() * 2 + 1;
//
//       paint.color = Colors.white.withOpacity(random.nextDouble() * 0.5 + 0.3);
//       canvas.drawCircle(Offset(x, y), radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }