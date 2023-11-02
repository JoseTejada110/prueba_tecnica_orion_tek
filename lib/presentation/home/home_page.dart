import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:orion_tek_app/presentation/clients/clients_page.dart';
import 'package:orion_tek_app/presentation/dashboard/dashboard_page.dart';
import 'package:orion_tek_app/presentation/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: const [
          DashboardPage(),
          ClientsPage(),
        ],
      ),
      bottomNavigationBar: const _BottomMenu(),
    );
  }
}

class _BottomMenu extends GetView<HomeController> {
  const _BottomMenu();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.currentIndex.value,
        selectedItemColor: theme.indicatorColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
        ],
        onTap: (int newIndex) => controller.updateMenuIndex(newIndex),
      ),
    );
  }
}
