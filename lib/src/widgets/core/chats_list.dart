import 'package:chat_ui_kit/src/styling/chats_list_style.dart';
import 'package:chat_ui_kit/src/utils/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'package:chat_ui_kit/src/models/chat_base.dart';
import 'package:chat_ui_kit/src/widgets/core/chats_list_tile.dart';
import 'package:chat_ui_kit/src/widgets/helpers/group_avatar.dart';

class ChatsList<T extends ChatBase> extends StatefulWidget {
  ChatsList(
      {Key? key,
      required this.controller,
      required this.appUserId,
      this.areItemsTheSame,
      this.chatsListStyle,
      this.groupAvatarStyle,
      this.unreadBubbleEnabled = true,
      required this.builders,
      this.scrollHandler})
      : super(key: key);

  /// The controller that manages items and actions
  final ChatsListController controller;

  /// The id of the app's current user
  /// required to determine whether a message is owned
  final String appUserId;

  /// Called by the DiffUtil to decide whether two object represent the same Item.
  /// By default, this will check whether oldItem.getId() == newItem.getId();
  final bool Function(T oldItem, T newItem)? areItemsTheSame;

  /// Styling and settings for [ChatsList].
  final ChatsListStyle? chatsListStyle;

  /// Styling configuration for the default [GroupAvatar] used in [_buildLeading]
  final GroupAvatarStyle? groupAvatarStyle;

  /// Set to true if you want to display a bubble above the group avatar
  /// which shows the number of unread messages
  final bool unreadBubbleEnabled;

  /// Replace any component you are unsatisfied with with a custom Widget, build using
  /// these builders
  final ChatsListTileBuilders builders;

  /// Scrolling will trigger [NotificationListener], which will call this handler;
  /// Typically looks like this:
  /// void _handleScrollEvent(ScrollNotification scroll) {
  ///   if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent)
  ///     _getMoreChats();
  /// }
  final Function(ScrollNotification scroll)? scrollHandler;

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState<T extends ChatBase> extends State<ChatsList<T>> {
  @override
  void initState() {
    widget.controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() {
    setState(() {});
  }

  Widget _buildItem(
      BuildContext context, Animation<double> animation, T item, int index) {
    // Specify a transition to be used by the ImplicitlyAnimatedList.
    // See the Transitions section on how to import this transition.
    return SizeFadeTransition(
      sizeFraction: 0.7,
      curve: Curves.easeInOut,
      animation: animation,
      child: ChatsListTile(
          item: item,
          index: index,
          appUserId: widget.appUserId,
          builders: widget.builders,
          groupAvatarStyle: widget.groupAvatarStyle,
          unreadBubbleEnabled: widget.unreadBubbleEnabled),
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
            padding: widget.chatsListStyle?.padding,
            physics: widget.chatsListStyle?.physics,
            // The current items in the list.
            items: widget.controller.items as List<T>,
            areItemsTheSame: (T a, T b) {
              if (widget.areItemsTheSame != null)
                return widget.areItemsTheSame!(a, b);
              return a.id == b.id;
            },
            // Called, as needed, to build list item .
            // List items are only built when they're scrolled into view.
            itemBuilder: _buildItem));
  }
}
