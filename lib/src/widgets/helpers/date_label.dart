import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateLabel extends StatelessWidget {
  DateLabel({
    required this.date,
    this.dateFormat,
  });

  final DateTime date;
  final DateFormat? dateFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.only(
        bottom: 5.0,
        top: 5.0,
        left: 10.0,
        right: 10.0,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        dateFormat != null
            ? dateFormat!.format(date)
            : DateFormat('yyyy-MMM-dd').format(date),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
