import 'package:flutter/material.dart';
import 'color_resource.dart';
import 'package:flutter/material.dart';
import 'color_resource.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: ColorResource.background,
      primaryColor: ColorResource.primaryColor,
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorResource.darkText),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ColorResource.darkText),
        bodyLarge: TextStyle(fontSize: 16, color: ColorResource.darkText),
        bodyMedium: TextStyle(fontSize: 14, color: ColorResource.lightText),
        labelLarge: TextStyle(fontSize: 12, color: ColorResource.lightText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResource.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorResource.background,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResource.greyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResource.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResource.primaryColor),
        ),
        hintStyle: TextStyle(color: ColorResource.lightText),
      ),
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorResource.toggleOn;
          }
          return ColorResource.toggleOff;
        }),
        thumbColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );
  }
}


