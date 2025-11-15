import 'package:get/get.dart';
import '../wheel_game/bindings/wheel_game_binding.dart';
import '../wheel_game/view/wheel_game_view.dart';
import '../wheel_name_entry/bindings/wheel_name_entry_bindings.dart';
import '../wheel_name_entry/view/name_entry_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WHEEL_NAME_ENTRY;

  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => const HomeView(),
    //   binding: HomeBinding(),
    // ),
    // GetPage(
    //   name: _Paths.LOG_IN,
    //   page: () => const LogInView(),
    //   binding: LogInBinding(),
    // ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: _Paths.WHEEL_GAME,
      page: () => const WheelGameView(),
      binding: WheelGameBinding(),
    ),
    GetPage(
      name: _Paths.WHEEL_NAME_ENTRY,
      page: () => const WheelNameEntryView(),
      binding: WheelNameEntryBinding(),
    ),
  ];
}


