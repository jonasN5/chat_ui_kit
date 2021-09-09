import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';

void main() {
  testWidgets('Test the GroupAvatar Widget', (WidgetTester tester) async {
    final items = List.generate(6, (index) => 'notRelevantStringForThisTest');
    await tester.pumpWidget(MaterialApp(
        home: GroupAvatar(
            items: items,
            style: GroupAvatarStyle(mode: GroupAvatarMode.stackedCircles),
            builder: (ctx, imageIndex, size, items) {
              return Container();
            })));

    // Searching by type ClipOval will allow testing the
    // GroupAvatarMode.stackedCircles at the same time than making sure the
    // number of children matches the passed items and at most 4.
    final finder = find.byType(ClipOval);
    expect(finder, findsNWidgets(min(items.length, 4)));
  });
}
