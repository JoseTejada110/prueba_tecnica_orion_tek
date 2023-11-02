import 'package:dartz/dartz.dart';
import 'package:orion_tek_app/core/error_handling/failures.dart';
import 'package:orion_tek_app/data/models/address_type_model.dart';
import 'package:orion_tek_app/data/models/clients_model.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';
import 'package:orion_tek_app/domain/requests/api_params_request.dart';
import 'package:orion_tek_app/domain/usecases/catch_request_exceptions.dart';

class ClientsUsecase {
  ClientsUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, List<ClientModel>>> getClients() async {
    return catchRequestExceptions<List<ClientModel>>(() async {
      final params = ApiParamsRequest(url: '/clients');
      final clientsResult = await apiRepository.executeGetRequest(params);

      return clientModelFromJson(clientsResult);
    });
  }

  Future<Either<FailureEntity, ClientModel>> storeClient(
    Map<String, dynamic> body,
  ) async {
    return catchRequestExceptions<ClientModel>(() async {
      final url = body['id'] == null ? '/clients' : '/clients/${body['id']}';
      final params = ApiParamsRequest(url: url, body: body);
      final result = await apiRepository.executePostRequest(params);

      return ClientModel.fromJson(result);
    });
  }

  Future<Either<FailureEntity, ClientModel>> deleteClient(int id) async {
    return catchRequestExceptions<ClientModel>(() async {
      final params = ApiParamsRequest(url: '/clients/$id');
      final result = await apiRepository.executeDeleteRequest(params);

      return ClientModel.fromJson(result);
    });
  }

  Future<Either<FailureEntity, List<AddressType>>> getAddressTypes() async {
    return catchRequestExceptions<List<AddressType>>(() async {
      final params = ApiParamsRequest(url: '/addressTypes');
      final addressTypesResult = await apiRepository.executeGetRequest(params);

      return addressTypeModelFromJson(addressTypesResult);
    });
  }
}
