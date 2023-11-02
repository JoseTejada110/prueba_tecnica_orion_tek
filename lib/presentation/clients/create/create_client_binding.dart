import 'package:get/get.dart';
import 'package:orion_tek_app/presentation/clients/create/create_client_controller.dart';

class CreateClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateClientController(apiRepository: Get.find()),
    );
  }
}
