import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:orion_tek_app/core/utils/messages_utils.dart';
import 'package:orion_tek_app/data/models/address_type_model.dart';
import 'package:orion_tek_app/data/models/clients_model.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';
import 'package:orion_tek_app/domain/usecases/clients_usecase.dart';
import 'package:orion_tek_app/presentation/clients/clients_controller.dart';

class CreateClientController extends GetxController {
  CreateClientController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    _loadClientData();
    _loadAddressTypes();
    super.onInit();
  }

  void _loadClientData() async {
    if (Get.arguments == null) return;
    client = Get.arguments as ClientModel;
    nameController.text = client!.name;
    selectedAddresses = client!.addresses;
  }

  void _loadAddressTypes() async {
    final result = await ClientsUsecase(apiRepository).getAddressTypes();
    result.fold(
      (l) => null,
      (r) => addressTypes = r,
    );
  }

  List<AddressType> addressTypes = [];
  Rxn<AddressType> selectedAddressType = Rxn<AddressType>();
  ClientModel? client;
  bool get isEditing => client != null;
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  List<ClientAddress> selectedAddresses = [];

  void addSelectedAddress(ClientAddress addressData) {
    selectedAddresses.insert(0, addressData);
    listKey.currentState!.insertItem(0);
    update(['selected_addresses_list']);
  }

  void removeParticion(int index) {
    selectedAddresses.removeAt(index);
    update(['selected_addresses_list']);
  }

  void updateAddressType(AddressType? value) =>
      selectedAddressType.value = value;

  Future<void> saveClient() async {
    final isValidFields = _validateFields();
    if (!isValidFields) return;
    MessagesUtils.showLoading(message: 'Guardando...');
    final addressesData = selectedAddresses
        .map(
          (address) => {
            'formatted_address': address.formattedAddress,
            'lat': address.lat,
            'lng': address.lng,
            'type_id': address.typeId,
            'type': address.type,
          },
        )
        .toList();
    final body = {
      'id': client?.id,
      'name': nameController.text,
      'addresses': addressesData,
    };
    final result = await ClientsUsecase(apiRepository).storeClient(body);
    MessagesUtils.dismissLoading();
    result.fold(
      (failure) => MessagesUtils.errorDialog(failure, tryAgain: saveClient),
      (ClientModel newClient) {
        final clientsController = Get.find<ClientsController>();
        if (isEditing) {
          final indexToReplace = clientsController.clients.indexWhere(
            (element) => element.id == client!.id,
          );
          clientsController.clients.removeAt(indexToReplace);
          clientsController.clients.insert(indexToReplace, newClient);
          clientsController.updateClientsList();
          Get.back();
          MessagesUtils.successSnackbar(
            'Cliente Editado',
            '¡Su cliente ha sido editado satisfactoriamente!',
          );
        } else {
          clientsController.clients.insert(0, newClient);
          clientsController.updateClientsList();
          _clearForm();
          MessagesUtils.successSnackbar(
            'Cliente Guardado',
            '¡Su cliente ha sido registrado satisfactoriamente!',
          );
        }
      },
    );
  }

  bool _validateFields() {
    if (nameController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Nombre Obligatorio',
        'Debe introducir el nombre del cliente',
      );
      return false;
    }
    if (selectedAddresses.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Dirección Obligatoria',
        'Debe introducir al menos una dirección',
      );
      return false;
    }
    return true;
  }

  void _clearForm() {
    nameController.clear();
    selectedAddresses.clear();
    listKey.currentState!
        .removeAllItems((context, animation) => const SizedBox());
    update(['selected_addresses_list']);
  }
}
