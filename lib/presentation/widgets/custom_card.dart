import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.height,
  });
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).cardColor,
            borderRadius: borderRadius,
            boxShadow: Get.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}
