import 'package:dartz/dartz.dart';
import 'package:orion_tek_app/core/error_handling/failures.dart';
import 'package:orion_tek_app/data/models/chart_data.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';
import 'package:orion_tek_app/domain/requests/api_params_request.dart';
import 'package:orion_tek_app/domain/usecases/catch_request_exceptions.dart';

class DashboardUsecase {
  DashboardUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, Map<String, dynamic>>> getDashboardData() async {
    return catchRequestExceptions<Map<String, dynamic>>(() async {
      final clientsByMonthParams = ApiParamsRequest(url: '/getClientsByMonth');
      final clientsByMonthFuture = apiRepository.executeGetRequest(
        clientsByMonthParams,
      );
      final totalClientsAndAdressesParams = ApiParamsRequest(
        url: '/getActiveClientsAndAddresses',
      );
      final totalClientsAndAdressesFuture = apiRepository.executeGetRequest(
        totalClientsAndAdressesParams,
      );
      final addressesByTypeParams = ApiParamsRequest(
        url: '/getaddressesByType',
      );
      final addressesByTypeFuture = apiRepository.executeGetRequest(
        addressesByTypeParams,
      );
      final results = await Future.wait([
        clientsByMonthFuture,
        totalClientsAndAdressesFuture,
        addressesByTypeFuture,
      ]);

      return {
        'clients_by_months': chartDataFromJson(results[0]),
        'total_clients_addresses': results[1],
        'addresses_by_type': chartDataFromJson(results[2]),
      };
    });
  }
}
