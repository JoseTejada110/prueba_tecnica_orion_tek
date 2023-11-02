import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:orion_tek_app/domain/repositories/api_repository.dart';

class HomeController extends GetxController {
  HomeController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  void updateMenuIndex(int newIndex) {
    currentIndex.value = newIndex;
    pageController.jumpToPage(newIndex);
  }
}
