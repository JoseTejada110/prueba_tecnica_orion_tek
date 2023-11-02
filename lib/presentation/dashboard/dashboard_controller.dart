import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:orion_tek_app/core/error_handling/failures.dart';
import 'package:orion_tek_app/data/models/chart_data.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';
import 'package:orion_tek_app/domain/usecases/dashboard_usecase.dart';

class DashboardController extends GetxController with StateMixin {
  DashboardController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }

  Future<void> getDashboardData() async {
    change(null, status: RxStatus.loading());
    final result = await DashboardUsecase(apiRepository).getDashboardData();
    result.fold(
      (failure) {
        final messages = getMessageFromFailure(failure);
        change(
          null,
          status: RxStatus.error(messages.toString()),
        );
      },
      (r) {
        chartData = r['clients_by_months'] ?? <ChartData>[];
        totalClients = r['total_clients_addresses']['total_clients'];
        totalAddresses = r['total_clients_addresses']['total_addresses'];
        addressByTypeChartData = r['addresses_by_type'];
        change(null, status: RxStatus.success());
      },
    );
  }

  List<ChartData> chartData = [];
  List<ChartData> addressByTypeChartData = [];
  int totalClients = 0;
  int totalAddresses = 0;
}
