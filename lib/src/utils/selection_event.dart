import 'package:chat_ui_kit/src/utils/enums.dart';

/// A wrapper called every time an item is either selected or unselected.
class SelectionEvent<T> {
  final SelectionType type;

  final List<T> items;

  final int currentSelectionCount;

  SelectionEvent(this.type, this.items, this.currentSelectionCount);
}
