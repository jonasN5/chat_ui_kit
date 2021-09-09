import 'package:flutter_test/flutter_test.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';
import '../models/fake_models.dart';

void main() {
  group('MessagesListController', () {
    test('Test controller addAll method', () {
      final controller = MessagesListController();
      controller.addAll([FakeMessage(), FakeMessage()]);

      expect(controller.items.length, 2);
    });

    test('Test controller insertAll method', () {
      final controller =
          MessagesListController(items: [FakeMessage(), FakeMessage()]);
      final fake1 = FakeMessage();
      final fake2 = FakeMessage();
      controller.insertAll(1, [fake1, fake2]);

      expect(controller.items[1], fake1);
      expect(controller.items[2], fake2);
    });

    test('Test controller removeItem method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);
      controller.removeItem(fake1);

      expect(controller.items.length, 0);
    });

    test('Test controller removeItems method', () {
      final fake1 = FakeMessage();
      final fake2 = FakeMessage();
      final controller = MessagesListController(items: [fake1, fake2]);
      controller.removeItems([fake1, fake2]);

      expect(controller.items.length, 0);
    });

    test('Test controller getById method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);

      expect(controller.getById(fake1.id), fake1);
    });

    test('Test controller updateById method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);
      final fake2 = FakeMessage();
      fake2.id = fake1.id;
      fake2.text = 'test';
      controller.updateById(fake2);

      expect(controller.getById(fake1.id)!.text, 'test');
    });

    test('Test controller select method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);
      // Expect that the stream emits an instance of type SelectionEvent with
      // type == SelectionType.select.
      expect(controller.selectionEventStream,
          emits((SelectionEvent e) => e.type == SelectionType.select));
      controller.select(fake1);
      expect(controller.selectedItems.length, 1);
    });

    test('Test controller select method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);
      // Expect that the stream emits the correct SelectionEvent.
      expect(controller.selectionEventStream, emits((SelectionEvent e) {
        return e.type == SelectionType.select &&
            e.items.first == fake1 &&
            e.currentSelectionCount == 1;
      }));
      controller.select(fake1);
      expect(controller.selectedItems.length, 1);
    });

    test('Test controller unSelect method', () {
      final fake1 = FakeMessage();
      final controller = MessagesListController(items: [fake1]);
      controller.select(fake1);
      expect(controller.selectionEventStream, emits((SelectionEvent e) {
        return e.type == SelectionType.unSelect &&
            e.items.first == fake1 &&
            e.currentSelectionCount == 0;
      }));
      controller.unSelect(fake1);
      expect(controller.selectedItems.length, 0);
    });

    test('Test controller selectAll method', () {
      final fake1 = FakeMessage();
      final fake2 = FakeMessage();
      final controller = MessagesListController(items: [fake1, fake2]);
      expect(controller.selectionEventStream, emits((SelectionEvent e) {
        return e.type == SelectionType.select &&
            e.items.length == 2 &&
            e.currentSelectionCount == 2;
      }));
      controller.selectAll();
      expect(controller.selectedItems.length, 2);
    });

    test('The controller dispose method should close the stream.', () {
      final controller = MessagesListController();
      expect(controller.selectionEventStream, emitsDone);
      controller.dispose();
    });

  });

  test('Test ChatsListController updateById method', () {
    final fake1 = FakeChat();
    final controller = ChatsListController(items: [FakeChat(), FakeChat(), fake1]);
    final fake2 = FakeChat();
    fake2.id = fake1.id;
    fake2.name = 'test';
    expect(fake1.name, '');

    controller.updateById(fake2);
    // Test update and pushToStart (the default)
    expect(controller.getById(fake1.id)!.name, 'test');
    expect(controller.items[0].id, fake1.id);
    // Test pushToEnd
    controller.updateById(fake2, pushToEnd: true);
    expect(controller.items.last.id, fake1.id);
  });
}
