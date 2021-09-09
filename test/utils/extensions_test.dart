import 'package:flutter_test/flutter_test.dart';
import 'package:chat_ui_kit/src/utils/extensions.dart';

void main() {
  test('Test isBeforeAndDifferentDay property', () {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final yesterday = now.subtract(Duration(days: 1));

    expect(yesterday.isBeforeAndDifferentDay(now), true);
    expect(now.isBeforeAndDifferentDay(tomorrow), true);
    expect(now.isBeforeAndDifferentDay(yesterday), false);
    expect(tomorrow.isBeforeAndDifferentDay(now), false);
    expect(now.isBeforeAndDifferentDay(now), false);
    expect(yesterday.isBeforeAndDifferentDay(yesterday), false);
  });

}
