import 'package:get/get.dart';
import 'package:orion_tek_app/presentation/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(apiRepository: Get.find()),
    );
  }
}
