import 'dart:async';

import 'package:chat_ui_kit/src/models/chat_base.dart';
import 'package:chat_ui_kit/src/models/message_base.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:chat_ui_kit/src/utils/selection_event.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

/// A class that manages the item list; as such, this class should be the only one holding the list of items it controls
/// You should perform all add/remove items with the api this class provides.
/// This class also handles click management:
/// longPressing an item will select it;
/// tapping an item will toggle its selection if [isSelectionModeActive] is true.
/// Listen to [selectionEventStream] to catch any selection event [SelectionEvent].
/// Make sure to call [MessagesListController.dispose] when disposing the widget.
class MessagesListController<T extends MessageBase> extends ChangeNotifier {
  MessagesListController({List<T>? items}) {
    if (items != null) addAll(items);
  }

  final List<T> _items = [];

  ///************************************************* Item management *************************************************************

  List<T> get items => _items;

  void addAll(List<T> items) {
    this._items.addAll(items);
    notifyListeners();
  }

  void insertAll(int index, List<T> items) {
    this._items.insertAll(index, items);
    notifyListeners();
  }

  void removeSelectedItems() {
    for (T item in _selectedItems) {
      this._items.remove(item);
    }
    _selectedItems.clear();
    notifyListeners();
  }

  void removeItem(T item) {
    this._items.remove(item);
    notifyListeners();
  }

  void removeItems(List<T> items) {
    for (T item in items) {
      this._items.remove(item);
    }
    notifyListeners();
  }

  void updateById(T item) {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index > -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  T? getById(String id) {
    return _items.firstWhereOrNull((element) => element.id == id);
  }

  void notifyChanges() => notifyListeners();

  ///************************************************* Action management *************************************************************

  void onItemTap(BuildContext context, int index, T item) {
    if (isSelectionModeActive) toggleSelection(item);
  }

  void onItemLongPress(BuildContext context, int index, T item) {
    if (!isSelectionModeActive) select(item);
  }

  ///************************************************* Selection management *************************************************************

  final List<T> _selectedItems = [];

  List<T> get selectedItems => _selectedItems;

  final StreamController<SelectionEvent> _controller =
      StreamController<SelectionEvent>.broadcast();

  /// Listen to this stream to catch any selection/unSelection events
  Stream<SelectionEvent> get selectionEventStream => _controller.stream;

  /// Whether at least one item is currently selected
  bool get isSelectionModeActive => _selectedItems.isNotEmpty;

  bool isItemSelected(T item) {
    return _selectedItems.contains(item);
  }

  void select(T item) {
    _selectedItems.add(item);
    notifyListeners();
    _controller.sink.add(
        SelectionEvent(SelectionType.select, [item], _selectedItems.length));
  }

  void unSelect(T item) {
    _selectedItems.remove(item);
    notifyListeners();
    _controller.sink.add(
        SelectionEvent(SelectionType.unSelect, [item], _selectedItems.length));
  }

  void toggleSelection(T item) {
    if (_selectedItems.contains(item)) {
      unSelect(item);
    } else {
      select(item);
    }
  }

  void unSelectAll() {
    _selectedItems.clear();
    notifyListeners();
    _controller.sink.add(SelectionEvent(SelectionType.unSelect, [], 0));
  }

  void selectAll() {
    _selectedItems.addAll(_items);
    notifyListeners();
    _controller.sink.add(SelectionEvent(
        SelectionType.select, _selectedItems, _selectedItems.length));
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

/// A class that manages the item list; as such, this class should be the only one holding the list of items it controls
/// You should perform all add/remove items with the api this class provides.
/// There is no selection management since usually tapping simply means navigating to the chat
/// and longPressing will trigger single item actions;
class ChatsListController<T extends ChatBase> extends ChangeNotifier {
  ChatsListController({List<T>? items}) {
    if (items != null) addAll(items);
  }

  final List<T> _items = [];

  List<T> get items => _items;

  void addAll(List<T> items) {
    this._items.addAll(items);
    notifyListeners();
  }

  void insertAll(int index, List<T> items) {
    this._items.insertAll(index, items);
    notifyListeners();
  }

  void removeItem(T item) {
    this._items.remove(item);
    notifyListeners();
  }

  void removeAt(int index) {
    this._items.removeAt(index);
    notifyListeners();
  }

  /// Update a given item by comparing their respective id.
  /// If [pushToStart] is true, the item will be repositioned to index 0;
  /// If [pushToEnd] is true, the item will be repositioned to the end of the list;
  void updateById(T item, {bool pushToStart = true, bool pushToEnd = false}) {
    // Since pushToStart is the default, we swap if pushToEnd is true in case
    // pushToStart is still true, which should not be the case.
    if (pushToEnd) pushToStart = false;
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index > -1) {
      if (pushToStart || pushToEnd) {
        _items.removeAt(index);
        if (pushToStart) {
          _items.insert(0, item);
        } else {
          _items.add(item);
        }
      } else {
        _items[index] = item;
      }
      notifyListeners();
    }
  }

  T? getById(String id) {
    return _items.firstWhereOrNull((element) => element.id == id);
  }

  void notifyChanges() => notifyListeners();
}
