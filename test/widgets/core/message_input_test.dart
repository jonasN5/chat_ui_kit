import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';

void main() {
  group('Test the MessageInput Widget along with MessageInputTypingHandler',
      () {
    final TextEditingController _textController = TextEditingController();

    String? sentMessage;
    TypingEvent? typingEvent;

    testWidgets('Test callbacks', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: MessageInput(
                  textController: _textController,
                  sendCallback: (text) => sentMessage = text,
                  typingCallback: (e) => typingEvent = e))));

      await tester.enterText(find.byType(TextField), 'test text');
      expect(sentMessage, null);
      expect(typingEvent, (e) => e == TypingEvent.start);

      await tester.tap(find.byType(RaisedButton));
      // Required for the timer
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(sentMessage, 'test text');
      expect(typingEvent, (e) => e == TypingEvent.stop);

      // Test stop event on idle
      typingEvent = null;
      await tester.enterText(find.byType(TextField), 'test text');
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(typingEvent, (e) => e == TypingEvent.stop);

      // Test stop event when clearing the whole text
      typingEvent = null;
      await tester.enterText(find.byType(TextField), 'test text');
      await tester.enterText(find.byType(TextField), '');
      expect(typingEvent, (e) => e == TypingEvent.stop);
    });
  });
}
