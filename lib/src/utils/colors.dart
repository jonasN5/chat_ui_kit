import 'package:flutter/material.dart';

class CustomColors {
  static const Color white88 = Color(0xE0FFFFFF);
  static const Color black18 = Color(0x2E000000);

  static Color incomingMessageContainerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? white88 : black18;
}
