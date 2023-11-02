import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 25,
    this.constraints,
    this.padding = const EdgeInsets.all(8.0),
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry padding;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: constraints,
      padding: padding,
      tooltip: tooltip,
      color: iconColor ?? Theme.of(context).primaryColor,
      iconSize: iconSize,
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class CustomFormButton extends StatelessWidget {
  const CustomFormButton({
    super.key,
    required this.title,
    required this.buttonTitle,
    required this.onPressed,
    this.prefixIcon,
  });
  final String title;
  final String buttonTitle;
  final VoidCallback onPressed;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Get.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onPressed,
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              isDense: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            // onPressed: onPressed,
            // padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    buttonTitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: title.toLowerCase().contains('seleccion')
                          ? Get.textTheme.bodySmall?.color
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.foregroundColor,
    this.alignment = Alignment.center,
  });
  final String title;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: alignment,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });
  final bool? value;
  final String title;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      activeColor: Get.theme.indicatorColor,
      onChanged: onChanged,
      value: value,
      title: Text(title),
    );
  }
}
