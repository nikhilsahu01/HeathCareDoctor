import 'package:flutter/material.dart';

import '../theams/color_resource.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? customStyle;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 17,
    this.fontWeight = FontWeight.bold,
    this.color = ColorResource.darkText,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.customStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: customStyle ?? TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}