import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static final dateFormat = DateFormat('dd/MM/yyyy');
  static final decimalFormat =
      NumberFormat.decimalPatternDigits(decimalDigits: 2);
  static const bodyPadding = EdgeInsets.all(10);

  // Colors
  static const red = Color(0XFFf5465d);
  static const blue = Color(0XFF1773ec);
  static const green = Color(0XFF2ebd85);
}
