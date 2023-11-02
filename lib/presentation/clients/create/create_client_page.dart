import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orion_tek_app/core/constants.dart';
import 'package:orion_tek_app/core/utils/utils.dart';
import 'package:orion_tek_app/data/models/clients_model.dart';
import 'package:orion_tek_app/presentation/clients/create/create_client_controller.dart';
import 'package:orion_tek_app/presentation/routes/app_navigation.dart';
import 'package:orion_tek_app/presentation/widgets/custom_buttons.dart';
import 'package:orion_tek_app/presentation/widgets/custom_card.dart';
import 'package:orion_tek_app/presentation/widgets/custom_input.dart';
import 'package:orion_tek_app/presentation/widgets/input_title.dart';
import 'package:orion_tek_app/presentation/widgets/placeholders_widgets.dart';

class CreateClientPage extends GetView<CreateClientController> {
  const CreateClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${controller.isEditing ? 'Editar' : 'Crear'} Cliente',
          ),
        ),
        body: CustomCard(
          margin: Constants.bodyPadding,
          padding: Constants.bodyPadding,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputTitle('Nombre', isRequired: true),
                CustomInput(
                  textCapitalization: TextCapitalization.words,
                  controller: controller.nameController,
                  focusNode: controller.nameFocus,
                ),
                const SizedBox(height: 10),
                const InputTitle('Direcciones', isRequired: true),
                const _AddressList(),
                ElevatedButton(
                  onPressed: _showMapPicker,
                  child: const Text('Seleccionar Dirección'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: controller.saveClient,
          icon: const Icon(Icons.save_rounded),
          label:
              Text('${controller.isEditing ? 'Editar' : 'Registrar'} Cliente'),
        ),
      ),
    );
  }

  void _showMapPicker() async {
    final result = await Get.toNamed(AppRoutes.mapPicker) as ClientAddress?;
    if (result == null) return;
    controller.addSelectedAddress(result);
  }
}

class _AddressList extends StatelessWidget {
  const _AddressList();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: GetBuilder<CreateClientController>(
          id: 'selected_addresses_list',
          builder: (controller) {
            return Column(
              children: [
                Visibility(
                  visible: controller.selectedAddresses.isEmpty,
                  child: const SizedBox(
                    height: 100,
                    child: EmptyPlaceHolder(
                      title: 'No hay direcciones seleccionadas.',
                    ),
                  ),
                ),
                AnimatedList(
                  physics: const NeverScrollableScrollPhysics(),
                  key: controller.listKey,
                  shrinkWrap: true,
                  initialItemCount: controller.selectedAddresses.length,
                  itemBuilder: (BuildContext context, int index,
                      Animation<double> animation) {
                    return _ListItem(
                      index: index,
                      address: controller.selectedAddresses[index],
                      controller: controller,
                      animation: animation,
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.index,
    required this.address,
    required this.controller,
    required this.animation,
  });

  final int index;
  final ClientAddress address;
  final CreateClientController controller;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          address.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(address.formattedAddress),
        trailing: CustomIconButton(
          tooltip: 'Remover Dirección',
          icon: Icons.delete,
          onPressed: () {
            // Eliminando elemento del estado de la lista animada
            controller.listKey.currentState?.removeItem(
              index,
              (_, removeAnimation) => _ListItem(
                address: address,
                index: index,
                controller: controller,
                animation: removeAnimation,
              ),
            );
            // Eliminando elemento de la lista de elementos
            controller.removeParticion(index);
          },
        ),
      ),
    );
  }
}
