import 'package:flutter/material.dart';
import 'Constants.dart';

class MyColor {

  static Color primaryColor = Color(Constants.primaryColor);

  static const MaterialColor primaryColorMaterial = const MaterialColor(
    Constants.primaryColor,
    const <int, Color>{
      50: const Color(Constants.primaryColor),
      100: const Color(Constants.primaryColor),
      200: const Color(Constants.primaryColor),
      300: const Color(Constants.primaryColor),
      400: const Color(Constants.primaryColor),
      500: const Color(Constants.primaryColor),
      600: const Color(Constants.primaryColor),
      700: const Color(Constants.primaryColor),
      800: const Color(Constants.primaryColor),
      900: const Color(Constants.primaryColor),
    },
  );

}