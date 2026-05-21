import 'package:flutter/material.dart';
import '../theams/color_resource.dart';

class CustomAppButton extends StatelessWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final Color? textColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isOutlined;
  final Widget? child;
  final IconData? icon;
  final bool useGradient;
  final bool isLoading; // ✅ NEW PARAMETER

  const CustomAppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.textColor = Colors.white,
    this.borderColor,
    this.height = 50,
    this.borderRadius = 48,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.isOutlined = false,
    this.child,
    this.icon,
    this.useGradient = true,
    this.isLoading = false, // ✅ DEFAULT TO FALSE
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOutlineStyle = isOutlined;

    return InkWell(
      onTap: isLoading ? null : onPressed, // 🔒 Disable on loading
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        decoration: ShapeDecoration(
          gradient: (useGradient && !isOutlineStyle)
              ? const LinearGradient(
            begin: Alignment(0.48, -0.48),
            end: Alignment(0.52, 1.48),
            colors: [const Color(0xFF006492), const Color(0xFF2D9CDB)],

          )
              : null,
          color: (!useGradient && !isOutlineStyle)
              ? ColorResource.primaryColor
              : (isOutlineStyle ? Colors.white : null),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isOutlineStyle
                ? BorderSide(
              color: borderColor ?? Colors.grey.shade400,
              width: 1.2,
            )
                : BorderSide.none,
          ),
        ),
        // decoration: BoxDecoration(
        //   gradient: useGradient && !isOutlineStyle
        //       ? const LinearGradient(
        //
        //
        //
        //     colors: [
        //       ColorResource.primaryColor,
        //       Color(0xff9DCCD3),
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   )
        //       : null,
        //   color: !useGradient && !isOutlineStyle
        //       ? ColorResource.primaryColor
        //       : Colors.white,
        //   borderRadius: BorderRadius.circular(borderRadius),
        //   border: isOutlineStyle
        //       ? Border.all(
        //     color: borderColor ?? Colors.grey.shade400,
        //     width: 1.2,
        //   )
        //       : null,
        // ),
        child: Center(
          child: isLoading
              ? SizedBox(
            width: fontSize + 6,
            height: fontSize + 6,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlineStyle ? ColorResource.primaryColor : textColor!,
              ),
            ),
          )
              : child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: isOutlineStyle
                          ? ColorResource.primaryColor
                          : textColor,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      icon,
                      color: isOutlineStyle
                          ? ColorResource.primaryColor
                          : textColor,
                      size: fontSize + 2,
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
//outlined button

class CustomOutlineButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isExpanded;

  const CustomOutlineButton({
    super.key,
    this.label,
    this.child,
    required this.color,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    this.borderRadius = 12,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      onPressed: onTap,
      child: child ??
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: isExpanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
