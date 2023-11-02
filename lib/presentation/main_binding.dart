import 'package:get/instance_manager.dart';
import 'package:orion_tek_app/data/datasource/api_repository_impl.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiRepositoryInteface>(
      ApiRepositoryImpl(),
      permanent: true,
    );
  }
}
