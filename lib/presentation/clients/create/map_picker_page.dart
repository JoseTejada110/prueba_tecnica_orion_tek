import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:orion_tek_app/core/utils/messages_utils.dart';
import 'package:orion_tek_app/data/models/address_type_model.dart';
import 'package:orion_tek_app/data/models/clients_model.dart';
import 'package:orion_tek_app/presentation/clients/create/create_client_controller.dart';
import 'package:orion_tek_app/presentation/widgets/input_title.dart';

class MapPickerPage extends GetView<CreateClientController> {
  const MapPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: InputTitle('Tipo de ubicación', isRequired: true),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomDropdown(
                items: controller.addressTypes,
                value: controller.selectedAddressType.value,
                onChanged: controller.updateAddressType,
              ),
            );
          }),
          const SizedBox(height: 20),
          Expanded(
            child: SafeArea(
              child: MapLocationPicker(
                apiKey: 'AIzaSyDsRewTRXv-yOzZGGYEYDbxAvothZ8IGmE',
                language: 'es',
                searchHintText: 'Empieza a escribir para buscar',
                hideMapTypeButton: true,
                hideMoreOptions: true,
                bottomCardTooltip: 'Seleccionar esta dirección',
                backButton: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                dialogTitle:
                    'También puedes usar una de las siguientes direcciones',
                onNext: (GeocodingResult? result) {
                  if (controller.selectedAddressType.value == null) {
                    MessagesUtils.errorSnackbar(
                      'Tipo de ubicación obligatorio',
                      'Debes seleccionar el tipo de ubicación',
                    );
                    return;
                  }

                  final clientAddress = ClientAddress(
                    id: 0,
                    formattedAddress: result?.formattedAddress ?? '',
                    lat: result?.geometry.location.lat ?? 0,
                    lng: result?.geometry.location.lat ?? 0,
                    typeId: controller.selectedAddressType.value!.id,
                    type: controller.selectedAddressType.value!.type,
                  );
                  controller.selectedAddressType.value = null;
                  Get.back(result: clientAddress);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.errorText,
  });
  final List<AddressType> items;
  final dynamic value;
  final void Function(AddressType?) onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AddressType>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        isDense: true,
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
      ),
      value: value,
      items: _builItems(),
      onChanged: onChanged,
    );
  }

  List<DropdownMenuItem<AddressType>> _builItems() {
    return items
        .map((element) => DropdownMenuItem<AddressType>(
              value: element,
              child: Text(element.type),
            ))
        .toList();
  }
}
