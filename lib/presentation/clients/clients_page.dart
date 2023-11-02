import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:orion_tek_app/core/constants.dart';
import 'package:orion_tek_app/core/utils/messages_utils.dart';
import 'package:orion_tek_app/core/utils/utils.dart';
import 'package:orion_tek_app/presentation/clients/clients_controller.dart';
import 'package:orion_tek_app/presentation/routes/app_navigation.dart';
import 'package:orion_tek_app/presentation/widgets/custom_buttons.dart';
import 'package:orion_tek_app/presentation/widgets/custom_card.dart';
import 'package:orion_tek_app/presentation/widgets/custom_shimmer.dart';
import 'package:orion_tek_app/presentation/widgets/placeholders_widgets.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClientsController(apiRepository: Get.find()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Column(
        children: [
          const _CreateClientCard(),
          const SizedBox(height: 10),
          Expanded(
            child: CustomCard(
              margin: Constants.bodyPadding,
              child: controller.obx(
                onError: (errorString) => ErrorPlaceholder(
                  errorString ?? '',
                  tryAgain: controller.getClients,
                ),
                onLoading: const _LoadingList(),
                (_) => const _ClientsList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateClientCard extends StatelessWidget {
  const _CreateClientCard();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).indicatorColor;
    return CustomCard(
      margin: Constants.bodyPadding,
      onPressed: () => Get.toNamed(AppRoutes.createClient),
      child: ListTile(
        leading: Icon(
          Icons.person,
          color: primaryColor,
        ),
        title: const Text(
          'Crear Cliente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 30,
          color: primaryColor,
        ),
      ),
    );
  }
}

class _ClientsList extends StatelessWidget {
  const _ClientsList();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GetBuilder<ClientsController>(
          id: 'clients_list',
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: controller.getClients,
              child: controller.clients.isEmpty
                  ? const EmptyPlaceHolder(title: 'No hay clientes')
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.clients.length,
                      itemBuilder: (BuildContext context, int index) {
                        final client = controller.clients[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              Utils.getNameShortcuts(client.name),
                              style: TextStyle(
                                color: Theme.of(context).indicatorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(client.name),
                          trailing: CustomIconButton(
                            iconColor: Constants.red,
                            tooltip: 'Eliminar Cliente',
                            icon: Icons.delete_rounded,
                            onPressed: () => MessagesUtils.showConfirmation(
                              context: context,
                              title: 'Eliminar Cliente',
                              subtitle: const Text(
                                  '¿Estás seguro que deseas eliminar este cliente?'),
                              onConfirm: () {
                                Get.back();
                                controller.deleteClient(client);
                              },
                              onCancel: Get.back,
                              confirmColor: Constants.red,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed(AppRoutes.createClient,
                                arguments: client);
                          },
                        );
                      },
                    ),
            );
          }),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return CustomShimmer(
          child: ListTile(
            leading: const CircleAvatar(),
            title: Container(
              width: 40,
              height: 20,
              color: Colors.white,
            ),
            trailing: const Icon(Icons.delete_rounded),
          ),
        );
      },
    );
  }
}
