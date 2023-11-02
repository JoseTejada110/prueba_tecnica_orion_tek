import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orion_tek_app/core/constants.dart';

List<ChartData> chartDataFromJson(List<dynamic> json) =>
    List<ChartData>.from(json.map((x) => ChartData.fromJson(x)));

class ChartData {
  ChartData({required this.y, required this.x, required this.color});
  final double y;
  final dynamic x;
  final Color color;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        y: double.parse((json['y'] ?? 0).toString()),
        x: DateTime.tryParse(json['x']) == null
            ? json['x']
            : DateFormat.MMM('es').format(DateTime.parse(json['x'])),
        color: _getColor(json['x']),
      );

  static Color _getColor(String x) {
    switch (x) {
      case 'Hogar':
        return Constants.green;
      case 'Trabajo':
        return Constants.blue;
      default:
        return const Color(0XFF5F35F9);
    }
  }
}
