import 'package:chat_ui_kit/src/styling/message_style.dart';
import 'package:chat_ui_kit/src/utils/controllers.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:chat_ui_kit/src/widgets/core/messages_list_tile.dart';
import 'package:chat_ui_kit/src/widgets/helpers/date_label.dart';
import 'package:chat_ui_kit/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'package:chat_ui_kit/src/models/message_base.dart';

part 'messages_list.g.dart';

class MessagesList<T extends MessageBase> extends StatefulWidget {
  MessagesList(
      {Key? key,
      required this.controller,
      required this.appUserId,
      this.areItemsTheSame,
      this.scrollHandler,
      this.style,
      this.useCustomTile,
      this.messagePosition,
      this.shouldBuildDate,
      this.builders = const MessageTileBuilders()})
      : assert(useCustomTile == null || builders.customTileBuilder != null,
            "You have to provide a customTileBuilder if you set useCustomTile"),
        super(key: key);

  /// The controller that manages items and actions
  final MessagesListController controller;

  /// The id of the app's current user.
  /// Required to determine whether a message is owned.
  final String appUserId;

  /// Called by the DiffUtil to decide whether two object represent the same Item.
  /// By default, this will check whether oldItem.id == newItem.id;
  final bool Function(T oldItem, T newItem)? areItemsTheSame;

  /// Scrolling will trigger [NotificationListener], which will call this handler.
  /// Typically looks like this:
  /// void _handleScrollEvent(ScrollNotification scroll) {
  ///   if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent)
  ///     _getMoreChats();
  /// }
  final Function(ScrollNotification scroll)? scrollHandler;

  /// Provide your custom builders to override the default behaviour
  final MessageTileBuilders builders;

  /// Custom styling you want to apply to the messages
  final MessageStyle? style;

  /// Pass a function to test whether [builders.customTileBuilder] should be called.
  /// The typical use case is to call the custom builder when you have
  /// event types messages (user joined chat, renaming chat etc.).
  final bool Function(int index, T item, MessagePosition messagePosition)?
      useCustomTile;

  /// Pass a function to override the default [_messagePosition]
  final MessagePosition Function(T? previousItem, T currentItem, T? nextItem,
      bool Function(T currentItem) shouldBuildDate)? messagePosition;

  /// Pass a function to override the default [_shouldBuildDate]
  final bool Function(T currentItem)? shouldBuildDate;

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState<T extends MessageBase> extends State<MessagesList<T>> {
  @override
  void initState() {
    widget.controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() {
    setState(() {});
  }

  List<T> get _items => widget.controller.items as List<T>;

  /// Helper method to determine whether a date label should be shown.
  /// If true, [_buildDate] will be called
  bool _shouldBuildDate(T currentItem) {
    if (widget.shouldBuildDate != null)
      return widget.shouldBuildDate!.call(currentItem);

    final int index = _items.indexOf(currentItem);
    final DateTime currentDate = currentItem.createdAt;

    final T? previousItem =
        index + 1 < _items.length ? _items[index + 1] : null;
    final DateTime? previousDate = previousItem?.createdAt;

    //build date if the previous item is older than the current item (and not same day)
    //or if no previous item exists and the current item is older than today
    return (previousDate == null && currentDate.isYesterdayOrOlder ||
        previousDate != null &&
            previousDate.isBeforeAndDifferentDay(currentDate));
  }

  /// Default method to determine the padding above the tile
  /// It will vary depending on the [MessagePosition]
  double _topItemPadding(int index, MessagePosition messagePosition) {
    double padding = 8.0;
    if (index == _items.length) return 0;
    if (messagePosition == MessagePosition.surrounded ||
        messagePosition == MessagePosition.surroundedTop) return 1.0;
    return padding;
  }

  /// Default method to determine the padding below the tile.
  /// It will vary depending on the [MessagePosition]
  double _bottomItemPadding(int index, MessagePosition messagePosition) {
    double padding = 8.0;
    if (messagePosition == MessagePosition.surrounded ||
        messagePosition == MessagePosition.surroundedBot) return 1.0;
    return padding;
  }

  /// Helper method to determine the [MessagePosition]
  MessagePosition _messagePosition(T item) {
    final currentItem = item;
    //this will return the index in the new item list
    final int index = _items.indexOf(currentItem);

    final T? nextItem =
        (index > 0 && _items.length >= index) ? _items[index - 1] : null;

    T? previousItem = index + 1 < _items.length ? _items[index + 1] : null;

    if (widget.messagePosition != null)
      return widget.messagePosition!
          .call(previousItem, currentItem, nextItem, _shouldBuildDate);

    if (_shouldBuildDate(currentItem)) {
      previousItem = null;
    } else {
      previousItem = index + 1 < _items.length ? _items[index + 1] : null;
    }

    if (previousItem?.author?.id == currentItem.author?.id &&
        nextItem?.author?.id == currentItem.author?.id) {
      return MessagePosition.surrounded;
    } else if (previousItem?.author?.id == currentItem.author?.id &&
        nextItem?.author?.id != currentItem.author?.id) {
      return MessagePosition.surroundedTop;
    } else if (previousItem?.author?.id != currentItem.author?.id &&
        nextItem?.author?.id == currentItem.author?.id) {
      return MessagePosition.surroundedBot;
    } else {
      return MessagePosition.isolated;
    }
  }

  /// The item builder.
  /// Be aware that [ImplicitlyAnimatedList] will call this builder to build new items as well
  /// as update items. Therefore, the index passed can be the index in the old items list as
  /// well as the index in the new items list.
  Widget _buildItem(
      BuildContext context, Animation<double> animation, T item, int index) {
    final MessagePosition _position = _messagePosition(item);

    if (widget.useCustomTile != null &&
        widget.useCustomTile!.call(index, item, _position))
      return widget.builders.customTileBuilder!
          .call(context, animation, index, item, _position);

    final Widget child = SizeFadeTransition(
      sizeFraction: 0.7,
      curve: Curves.easeInOut,
      animation: animation,
      child: MessagesListTile(
          item: item,
          index: index,
          controller: widget.controller,
          appUserId: widget.appUserId,
          builders: widget.builders,
          style: widget.style ??
              MessageStyle(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: _topItemPadding(index, _position),
                      bottom: _bottomItemPadding(index, _position))),
          messagePosition: _position),
    );

    if (index == -1 || !_shouldBuildDate(item)) return child;

    return Column(
      children: [_BuildDate(item, widget.builders), child],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Specify the generic type of the data in the list.
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          if (widget.scrollHandler != null) widget.scrollHandler!.call(scroll);
          return false;
        },
        child: ImplicitlyAnimatedList<T>(
            physics: widget.style?.physics,
            // The current _items in the list.
            reverse: true,
            items: _items,
            removeItemBuilder:
                //pass -1 as an index to differentiate with normal buildItem
                (BuildContext context, Animation<double> animation, T item) =>
                    _buildItem(context, animation, item, -1),
            areItemsTheSame: (T a, T b) {
              if (widget.areItemsTheSame != null)
                return widget.areItemsTheSame!(a, b);
              return a.id == b.id;
            },
            // Called, as needed, to build list item .
            // List _items are only built when they're scrolled into view.
            itemBuilder: _buildItem));
  }
}

@swidget
Widget _buildDate<T extends MessageBase>(
    BuildContext context, T item, MessageTileBuilders? builders) {
  if (builders?.customDateBuilder != null)
    return builders!.customDateBuilder!.call(context, item.createdAt);
  return DateLabel(date: item.createdAt);
}
