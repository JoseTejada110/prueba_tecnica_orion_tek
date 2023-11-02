import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:orion_tek_app/core/error_handling/failures.dart';
import 'package:orion_tek_app/core/utils/messages_utils.dart';
import 'package:orion_tek_app/data/models/clients_model.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';
import 'package:orion_tek_app/domain/usecases/clients_usecase.dart';

class ClientsController extends GetxController with StateMixin {
  ClientsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  RxList<ClientModel> clients = <ClientModel>[].obs;

  @override
  void onInit() {
    getClients();
    super.onInit();
  }

  Future<void> getClients() async {
    change(null, status: RxStatus.loading());
    final result = await ClientsUsecase(apiRepository).getClients();
    result.fold(
      (failure) {
        final messages = getMessageFromFailure(failure);
        change(
          null,
          status: RxStatus.error(messages.toString()),
        );
      },
      (clientsResult) {
        clients.value = clientsResult;
        change(null, status: RxStatus.success());
      },
    );
  }

  Future<void> deleteClient(ClientModel client) async {
    final result = await ClientsUsecase(apiRepository).deleteClient(client.id);
    result.fold(
      (failure) => MessagesUtils.errorDialog(failure,
          tryAgain: () => deleteClient(client)),
      (r) {
        clients.remove(client);
        updateClientsList();
        MessagesUtils.successSnackbar(
          'Cliente Eliminado',
          'El cliente ha sido eliminado satisfactoriamente.',
        );
      },
    );
  }

  void updateClientsList() => update(['clients_list']);
}
