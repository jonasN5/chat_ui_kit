import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';
import '../../models/fake_models.dart';

void main() {
  group('Test the ChatsList Widget', () {
    final controller = ChatsListController();

    Widget getWidget() {
      return MaterialApp(
          home: ChatsList(
              controller: controller,
              appUserId: 'testUserId',
              builders: ChatsListTileBuilders(
                groupAvatarBuilder:
                    (context, imageIndex, itemIndex, size, item) {
                  return SizedBox.fromSize(size: size);
                },
              )));
    }

    Future<void> _addChatsToList(WidgetTester tester) async {
      // Adding items to the controller should trigger an update
      controller.addAll([FakeChat(name: 'chat1'), FakeChat(name: 'chat2')]);
      // Need pumpAndSettle since there are animations
      await tester.pumpAndSettle();

      expect(find.byType(ChatsListTile), findsNWidgets(2));
      expect(find.text('chat1'), findsOneWidget);
      expect(find.text('chat2'), findsOneWidget);

      // Test adding a message to a chat
      final item = controller.items.first as FakeChat;
      item.lastMessage = FakeMessage(text: 'testLastMessage');
      controller.updateById(item);
      await tester.pumpAndSettle();
      expect(find.text('testLastMessage'), findsOneWidget);
    }

    Future<void> _updateListItem(WidgetTester tester) async {
      // Test the controller.updateById method with the widget
      await tester.pumpWidget(getWidget());
      final item = controller.items.first as FakeChat;
      item.lastMessage = FakeMessage(text: 'anotherLastMessage');
      controller.updateById(item);
      await tester.pumpAndSettle();
      expect(find.text('anotherLastMessage'), findsOneWidget);
    }

    Future<void> _testUnreadBubbleDisplayed(WidgetTester tester) async {
      // Test the display of the unread bubble
      final item = controller.items.first as FakeChat;
      item.unreadCount = 4;
      controller.updateById(item);
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);
      // Check if changing it to 0 hides the widget
      item.unreadCount = 0;
      controller.updateById(item);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
    }

    Future<void> _testUnreadBubbleDisabled(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChatsList(
              controller: controller,
              unreadBubbleEnabled: false,
              appUserId: 'testUserId',
              builders: ChatsListTileBuilders(
                groupAvatarBuilder:
                    (context, imageIndex, itemIndex, size, item) {
                  return SizedBox.fromSize(size: size);
                },
              ))));

      final item = controller.items.first as FakeChat;
      item.unreadCount = 4;
      controller.updateById(item);
      await tester.pumpAndSettle();
      expect(find.text('4'), findsNothing);
    }

    Future<void> _testScrollingCallsListener(WidgetTester tester) async {
      bool scrollCalled = false;
      await tester.pumpWidget(MaterialApp(
          home: ChatsList(
              controller: controller,
              unreadBubbleEnabled: false,
              scrollHandler: (e) => scrollCalled = true,
              appUserId: 'testUserId',
              builders: ChatsListTileBuilders(
                groupAvatarBuilder:
                    (context, imageIndex, itemIndex, size, item) {
                  return SizedBox.fromSize(size: size);
                },
              ))));

      await tester.flingFrom(Offset(200, 200), Offset(200, 150), 100);
      await tester.pumpAndSettle();
      expect(scrollCalled, true);
    }

    testWidgets('ChatsList tests', (WidgetTester tester) async {
      await tester.pumpWidget(getWidget());
      expect(find.byType(ChatsListTile), findsNothing,
          reason:
              'ChatsList should not have children with an empty controller');
      await _addChatsToList(tester);
      await _updateListItem(tester);
      await _testUnreadBubbleDisplayed(tester);
      await _testUnreadBubbleDisabled(tester);
      await _testScrollingCallsListener(tester);
    });
  });
}
