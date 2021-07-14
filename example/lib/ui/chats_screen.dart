import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:example/models/chat.dart';
import 'package:example/models/chat_message.dart';
import 'package:example/ui/chat_viewmodel.dart';
import 'package:flutter/material.dart';

import '../utils/date_formatter.dart';
import '../utils/app_colors.dart';
import '../ui/chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenSate createState() => _ChatsScreenSate();
}

class _ChatsScreenSate extends State<ChatsScreen> {
  final ChatViewModel _model = ChatViewModel();

  @override
  void initState() {
    _model.controller = ChatsListController();
    _model.controller.addAll(_model.generateExampleChats());
    super.initState();
  }

  /// Called from [NotificationListener] when the user scrolls
  void handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
      //_model.getMoreChats();
    }
  }

  /// Called when the user pressed an item (a chat)
  void onItemPressed(ChatWithMembers chat) {
    //navigate to the chat
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(ChatScreenArgs(chat: chat))));
    //reset unread count
    if (chat.isUnread) {
      chat.chat!.unreadCount = 0;
    }
  }

  /// Called when the user long pressed an item (a chat)
  void onItemLongPressed(ChatBase chat) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              content: Text(
                  "This chat and any related message will be deleted permanently."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //delete in DB, from the current list in memory and update UI
                      _model.controller.removeItem(chat);
                    },
                    child: Text("ok")),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("cancel")),
                ),
              ]);
        });
  }

  /// Build the last message depending on how many members the Chat has
  /// and on the message type [ChatMessage.type]
  Widget _buildLastMessage(BuildContext context, int index, ChatBase item) {
    final _chat = item as ChatWithMembers;
    //display avatar only if not a 1 to 1 conversation
    final bool displayAvatar = item.members.length > 2;
    //display an icon if there's an attachment
    Widget? attachmentIcon;
    if (_chat.lastMessage!.hasAttachment) {
      final _type = _chat.lastMessage!.type;
      final iconColor = AppColors.chatsAttachmentIconColor(context);
      if (_type == ChatMessageType.audio) {
        attachmentIcon = Icon(Icons.keyboard_voice, color: iconColor);
      } else if (_type == ChatMessageType.video) {
        attachmentIcon = Icon(Icons.videocam, color: iconColor);
      } else if (_type == ChatMessageType.image) {
        attachmentIcon = Icon(Icons.image, color: iconColor);
      }
    }

    //get the message label
    String messageText = _chat.lastMessage!.messageText(_model.localUser.id);

    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Row(children: [
          if (displayAvatar)
            Padding(
                padding: EdgeInsets.only(right: 8),
                child: ClipOval(
                    child: Image.asset(item.lastMessage!.author!.avatar,
                        width: 24, height: 24, fit: BoxFit.cover))),
          if (attachmentIcon != null)
            Padding(padding: EdgeInsets.only(right: 8), child: attachmentIcon),
          Expanded(
              child: Text(
            messageText,
            overflow: TextOverflow.ellipsis,
          ))
        ]));
  }

  Widget _buildTileWrapper(
      BuildContext context, int index, ChatBase item, Widget child) {
    return InkWell(
        onTap: () => onItemPressed(item as ChatWithMembers),
        onLongPress: () => onItemLongPressed(item),
        child: Column(children: [
          Padding(padding: EdgeInsets.only(right: 16), child: child),
          Divider(
            height: 1.5,
            thickness: 1.5,
            color: AppColors.chatsSeparatorLineColor(context),
            //56 default GroupAvatar size + 32 padding
            indent: 56.0 + 32.0,
            endIndent: 16.0,
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
          automaticallyImplyLeading: false,
        ),
        body: ChatsList(
            controller: _model.controller,
            appUserId: _model.localUser.id,
            scrollHandler: handleScrollEvent,
            groupAvatarStyle: GroupAvatarStyle(
                withSeparator: true, separatorColor: Colors.white),
            builders: ChatsListTileBuilders(
                groupAvatarBuilder:
                    (context, imageIndex, itemIndex, size, item) {
                  final chat = item as ChatWithMembers;
                  return Image.asset(chat.membersWithoutSelf[imageIndex].avatar,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover);
                },
                lastMessageBuilder: _buildLastMessage,
                wrapper: _buildTileWrapper,
                dateBuilder: (context, date) => Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(DateFormatter.getVerboseDateTimeRepresentation(
                        context, date)))),
            areItemsTheSame: (ChatBase oldItem, ChatBase newItem) =>
                oldItem.id == newItem.id));
  }

  @override
  void dispose() {
    _model.controller.dispose();
    super.dispose();
  }
}
