import 'package:chat_ui_kit/src/models/message_base.dart';
import 'package:chat_ui_kit/src/styling/message_style.dart';
import 'package:chat_ui_kit/src/utils/controllers.dart';
import 'package:chat_ui_kit/src/utils/date_formatter.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:chat_ui_kit/src/widgets/core/incoming_message.dart';
import 'package:chat_ui_kit/src/widgets/core/messages_list.dart';
import 'package:chat_ui_kit/src/widgets/core/outgoing_message.dart';
import 'package:chat_ui_kit/src/widgets/helpers/date_label.dart';
import 'package:flutter/material.dart';

import 'package:chat_ui_kit/src/utils/builders.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'messages_list_tile.g.dart';

class MessageTileBuilders<T extends MessageBase> {
  /// Called if [MessagesList.useCustomTile] is not null.
  /// The typical use case is to call the custom builder when you have
  /// event types messages (user joined chat, renaming chat etc.).
  /// This builder will be called instead of [MessagesList._buildItem].
  final Widget Function(BuildContext context, Animation<double> animation,
      int index, T item, MessagePosition messagePosition)? customTileBuilder;

  /// Call this builder to override the default [DateLabel] widget to build the date labels
  final DateBuilder? customDateBuilder;

  /// Wraps the default [MessagesListTile] and overrides the default [InkWell]
  /// If you use this, you have to implement your own selection Widget
  final Widget Function(BuildContext context, int index, T item,
      MessagePosition? messagePosition, Widget child)? wrapperBuilder;

  final IncomingMessageTileBuilders incomingMessageBuilders;

  final OutgoingMessageTileBuilders outgoingMessageBuilders;

  const MessageTileBuilders(
      {this.customTileBuilder,
      this.customDateBuilder,
      this.wrapperBuilder,
      this.incomingMessageBuilders = const IncomingMessageTileBuilders(),
      this.outgoingMessageBuilders = const OutgoingMessageTileBuilders()});
}

class IncomingMessageTileBuilders<T extends MessageBase> {
  /// Builder to display a widget in front of the body;
  /// Typically build the user's avatar here
  final MessageWidgetBuilder? avatarBuilder;

  /// Builder to display a widget on top of the first message from the same user.
  /// Typically build the user's username here.
  /// Pass null to disable the default builder [_defaultIncomingMessageTileTitleBuilder].
  final MessageWidgetBuilder? titleBuilder;

  /// Override the default text widget and supply a complete widget (including container) using your own logic
  final MessageWidgetBuilder? bodyBuilder;

  const IncomingMessageTileBuilders(
      {this.avatarBuilder,
      this.bodyBuilder,
      this.titleBuilder = _defaultIncomingMessageTileTitleBuilder});
}

class OutgoingMessageTileBuilders<T extends MessageBase> {
  /// Override the default text widget and supply a complete widget (including container) using your own logic
  final MessageWidgetBuilder? bodyBuilder;

  const OutgoingMessageTileBuilders({this.bodyBuilder});
}

Widget _defaultIncomingMessageTileTitleBuilder(BuildContext context, int index,
    MessageBase item, MessagePosition? messagePosition) {
  return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Text(item.author?.name ?? "",
          style: TextStyle(color: Theme.of(context).disabledColor)));
}

class MessagesListTile<T extends MessageBase> extends StatelessWidget {
  MessagesListTile(
      {Key? key,
      required this.item,
      required this.index,
      required this.controller,
      required this.appUserId,
      this.style,
      this.builders,
      this.messagePosition})
      : super(key: key);

  /// The item containing the tile data
  final T item;

  /// The list index of this tile
  final int index;

  /// The controller that manages items and actions
  final MessagesListController controller;

  /// The id of the app's current user.
  /// Required to determine whether a message is owned
  final String appUserId;

  final MessageStyle? style;

  final MessageTileBuilders? builders;

  final MessagePosition? messagePosition;

  MessageFlow get _messageFlow => item.isFromAppUser(appUserId)
      ? MessageFlow.outgoing
      : MessageFlow.incoming;

  @override
  Widget build(BuildContext context) {
    final Widget child = Padding(
        padding: style!.padding,
        child: _messageFlow == MessageFlow.outgoing
            ? OutgoingMessage(
                item: item,
                index: index,
                messagePosition: messagePosition,
                builders: builders!.outgoingMessageBuilders)
            : IncomingMessage(
                item: item,
                index: index,
                style: style,
                messagePosition: messagePosition,
                builders: builders!.incomingMessageBuilders));
    if (builders!.wrapperBuilder != null)
      return builders!.wrapperBuilder!
          .call(context, index, item, messagePosition, child);
    return Container(
        foregroundDecoration: BoxDecoration(
            color: controller.isItemSelected(item)
                ? style!.selectionColor ?? Colors.white.withAlpha(50)
                : Colors.transparent),
        child: Material(
            clipBehavior: Clip.antiAlias,
            type: MaterialType.transparency,
            child: InkWell(
                onTap: () => controller.onItemTap(context, index, item),
                onLongPress: () =>
                    controller.onItemLongPress(context, index, item),
                child: AbsorbPointer(
                    absorbing: controller.isSelectionModeActive,
                    child: child))));
  }
}

@swidget
Widget messageFooter<T extends MessageBase>(BuildContext context, T item) {
  return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Text(
          DateFormatter.getVerboseDateTimeRepresentation(
              context, item.createdAt,
              timeOnly: true),
          style: TextStyle(color: Theme.of(context).disabledColor)));
}
