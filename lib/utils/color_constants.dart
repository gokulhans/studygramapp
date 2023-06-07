import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color lightScaffoldBackgroundColor = hexToColor('#F9F9F9');
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  static Color secondaryAppColor = hexToColor('#5E92F3');
  static Color secondaryDarkAppColor = Colors.white;
  static Color blue = Colors.blue;
  static Color black = const Color.fromRGBO(48, 47, 48, 1.0);
  static Color grey = const Color.fromRGBO(141, 141, 141, 1.0);
  static Color white = Colors.white;
  static Color bluegradient1 = const Color.fromARGB(255, 83, 164, 231);
  static Color bluegradient2 = const Color.fromARGB(255, 20, 128, 190);
  static Color greengradient1 = const Color(0xFF53E78B);
  static Color greengradient2 = const Color(0xFF14BE77);
  static Color appbgclr = const Color.fromARGB(255, 255, 255, 255);
  static Color appbgclr2 = const Color.fromARGB(255, 255, 255, 255);
  static Color textclr = Colors.black87;
  static Color textclrw = Colors.black;
  static Color iconclr = Colors.black87;
  static Color green = Colors.green;
}
