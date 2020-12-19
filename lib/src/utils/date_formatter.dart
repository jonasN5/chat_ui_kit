import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Small helper class to make verbose representation of a [DateTime] easier
class DateFormatter {
  static String getVerboseDateTimeRepresentation(
      BuildContext context, DateTime dateTime,
      {bool timeOnly = false}) {
    DateTime now = DateTime.now();
    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (timeOnly ||
        (localDateTime.day == now.day &&
            localDateTime.month == now.month &&
            localDateTime.year == now.year)) {
      return roughTimeString;
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday =
          DateFormat('E', Localizations.localeOf(context).toLanguageTag())
              .format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMMMd', Localizations.localeOf(context).toLanguageTag()).format(dateTime)}';
  }
}
