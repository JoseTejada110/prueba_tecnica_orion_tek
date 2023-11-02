import 'package:flutter/material.dart';

class Utils {
  static void unfocus(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  static double parseControllerText(String? text) {
    return double.tryParse(text?.replaceAll(',', '') ?? '0.0') ?? 0.0;
  }

  static bool isNumeric(String? string) {
    if (string == null) {
      return false;
    }
    return double.tryParse(string) != null;
  }

  static String getNameShortcuts(String name) {
    if (name.isEmpty) return '';
    final splittedName = name.split(' ');
    switch (splittedName.length) {
      case 1:
        return splittedName[0][0];
      case 2:
        return splittedName[0][0] + splittedName[1][0];
      case 3:
        return splittedName[0][0] + splittedName[2][0];
      case 4:
        return splittedName[0][0] + splittedName[2][0];
    }
    return name[0];
  }

  // static int getUserId() => Get.find<HomeController>().usuario.idUsuario;
}
