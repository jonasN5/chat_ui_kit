import 'package:flutter/material.dart';

/// App Colors Class - Resource class for storing app level color constants
class AppColors {
  static const Color white18 = Color(0x2EFFFFFF);
  static const Color black18 = Color(0x2E000000);

  static const Color white8 = Color(0x14FFFFFF);
  static const Color black8 = Color(0x14000000);

  static const Color white72 = Color(0xB8FFFFFF);
  static const Color black72 = Color(0xB8000000);

  static Color chatsSeparatorLineColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? white18 : black18;

  static Color chatsAttachmentIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? white72 : black72;

  static Color chatMessageInputBGColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? white8 : black8;

  static Color chatMessageOverlayBGColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? white8 : black8;
}
