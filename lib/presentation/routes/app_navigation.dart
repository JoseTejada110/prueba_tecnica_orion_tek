import 'package:get/route_manager.dart';
import 'package:orion_tek_app/presentation/clients/create/create_client_binding.dart';
import 'package:orion_tek_app/presentation/clients/create/create_client_page.dart';
import 'package:orion_tek_app/presentation/clients/create/map_picker_page.dart';
import 'package:orion_tek_app/presentation/home/home_binding.dart';
import 'package:orion_tek_app/presentation/home/home_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String createClient = '/createClient';
  static const String mapPicker = '/mapPicker';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.createClient,
      page: () => const CreateClientPage(),
      binding: CreateClientBinding(),
    ),
    GetPage(
      name: AppRoutes.mapPicker,
      page: () => const MapPickerPage(),
    ),
  ];
}
