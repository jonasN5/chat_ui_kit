import 'package:chat_ui_kit/src/models/chat_base.dart';
import 'package:chat_ui_kit/src/widgets/helpers/group_avatar.dart';
import 'package:flutter/material.dart';
import 'package:chat_ui_kit/src/utils/builders.dart';
import 'package:chat_ui_kit/src/utils/date_formatter.dart';

class ChatsListTileBuilders<T extends ChatBase> {
  /// Pass a custom leading Widget to replace the default in [ChatsListTile._buildLeading]
  final ChatsWidgetBuilder? leading;

  /// Builder used by [GroupAvatar] in [ChatsListTile._buildLeading] if [leading] is null.
  /// Must be provided if leading is null.
  /// Build your individual image widget with it.
  /// The image widgets you provide will then be aggregated by [GroupAvatar].
  /// [itemIndex] is the position of the item (tile) in the list.
  /// [imageIndex] is the avatar's position with the following map.
  final Widget Function(BuildContext context, int imageIndex, int itemIndex,
      Size size, T item)? groupAvatarBuilder;

  /// Builder used only if [midSection] is null
  /// Replaces the default unread bubble Widget
  /// The widget is a child of Stack, place above the group avatar
  final ChatsWidgetBuilder? unreadBubbleBuilder;

  /// Pass a custom mid section Widget to replace the default
  /// [ChatsListTile._buildMidSection]
  final ChatsWidgetBuilder? midSection;

  /// Builder used only if [midSection] is null
  /// Replaces the default title
  final ChatsWidgetBuilder? titleBuilder;

  /// Builder used only if [midSection] is null and [titleBuilder] is null
  /// Replaces the default date Widget
  final DateBuilder? dateBuilder;

  /// Builder used only if [midSection] is null.
  /// Replaces the default last message Widget.
  final ChatsWidgetBuilder? lastMessageBuilder;

  /// Build a custom trailing Widget, otherwise empty.
  final ChatsWidgetBuilder? trailing;

  /// A top level wrapper for the whole tile, whose child should be [child].
  /// This is meant for you to be able to build your custom action manager, typically
  /// [InkWell] or [GestureDetector] and/or [Dismissible].
  final Widget Function(BuildContext context, int index, T item, Widget child)?
      wrapper;

  const ChatsListTileBuilders(
      {this.leading,
      this.groupAvatarBuilder,
      this.unreadBubbleBuilder,
      this.midSection,
      this.titleBuilder,
      this.dateBuilder,
      this.lastMessageBuilder,
      this.trailing,
      this.wrapper = _defaultChatsListTileWrapper})
      : assert(leading != null || groupAvatarBuilder != null,
            "One of groupAvatarBuilder or leading must be provided");
}

Widget _defaultChatsListTileWrapper(
    BuildContext context, int index, ChatBase item, Widget child) {
  const Color white18 = Color(0x2EFFFFFF);
  const Color black18 = Color(0x2E000000);

  return Column(children: [
    Padding(padding: EdgeInsets.all(16), child: child),
    Divider(
        height: 1.5,
        thickness: 1.5,
        color:
            Theme.of(context).brightness == Brightness.dark ? white18 : black18,
        indent: 56.0 + 32.0,
        //56 default GroupAvatar size + 32 padding
        endIndent: 16.0)
  ]);
}

class ChatsListTile<T extends ChatBase> extends StatelessWidget {
  ChatsListTile(
      {Key? key,
      required this.item,
      required this.index,
      required this.appUserId,
      this.groupAvatarStyle,
      this.unreadBubbleEnabled = true,
      required this.builders})
      : super(key: key);

  /// The item containing the tile data
  final T item;

  /// The list index of this tile
  final int index;

  /// The id of the app's current user
  /// Required to determine whether a message is owned
  final String appUserId;

  /// Styling configuration for the default [GroupAvatar] used in [_buildLeading]
  final GroupAvatarStyle? groupAvatarStyle;

  /// Default is true; set to false if you want to disable displaying a bubble
  /// above the group avatar which shows the number of unread messages.
  final bool unreadBubbleEnabled;

  /// Replace any component you are unsatisfied with with a custom Widget, built using
  /// these builders.
  /// The minimum setup is providing [ChatsListTileBuilders.groupAvatarBuilder].
  final ChatsListTileBuilders builders;

  /// Build the group avatar with the optional unread bubble
  Widget _buildLeading(BuildContext context) {
    final child = builders.leading != null
        ? builders.leading!.call(context, index, item)
        : Padding(
            padding: EdgeInsets.all(16),
            child: GroupAvatar(
                key: Key("Groupavatar_$index"),
                items: item.members
                    .where((element) => element.id != appUserId)
                    .toList(),
                style: groupAvatarStyle,
                builder: (ctx, imageIndex, size, items) => builders
                    .groupAvatarBuilder!
                    .call(ctx, imageIndex, index, size, item)));
    if (!unreadBubbleEnabled || (item.unreadCount ?? 0) < 1) return child;

    final bubble = builders.unreadBubbleBuilder != null
        ? builders.unreadBubbleBuilder!.call(context, index, item)
        : Positioned(
            right: builders.leading == null ? 12 : 0,
            top: builders.leading == null ? 12 : 0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    item.unreadCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          );

    return Stack(
      children: [child, bubble],
    );
  }

  Widget _buildMidSection(BuildContext context) {
    if (builders.midSection != null)
      return builders.midSection!.call(context, index, item);
    final date = item.lastMessage?.createdAt;

    //build the title
    final Widget title = builders.titleBuilder != null
        ? builders.titleBuilder!.call(context, index, item)
        : Row(
            children: [
              Expanded(
                  child: Text(item.name,
                      overflow: TextOverflow.ellipsis,
                      style: item.isUnread
                          ? TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)
                          : TextStyle(fontWeight: FontWeight.bold))),
              if (date != null)
                builders.dateBuilder != null
                    ? builders.dateBuilder!.call(context, date)
                    : Text(DateFormatter.getVerboseDateTimeRepresentation(
                        context, date))
            ],
          );

    Widget? lastMessage;
    if (item.lastMessage != null) {
      //build the last message
      lastMessage = builders.lastMessageBuilder != null
          ? builders.lastMessageBuilder!.call(context, index, item)
          : Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(item.lastMessage?.text ?? "",
                  overflow: TextOverflow.ellipsis));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, if (item.lastMessage != null) lastMessage!],
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        _buildLeading(context),
        Expanded(child: _buildMidSection(context)),
        if (builders.trailing != null)
          builders.trailing!.call(context, index, item)
      ],
    );
    if (builders.wrapper != null)
      return builders.wrapper!.call(context, index, item, child);
    return child;
  }
}
