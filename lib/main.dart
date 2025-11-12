import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/name_entry/view/name_entry_view.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Wheel App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Optional: Set default text color for dark theme consistency
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: SpinWheelView(participants: [],),
      // home: NameEntryView(),
    );
  }
}