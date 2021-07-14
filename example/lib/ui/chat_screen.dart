import 'package:chat_ui_kit/chat_ui_kit.dart' hide ChatMessageImage;
import 'package:example/models/chat.dart';
import 'package:example/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

import 'package:example/models/chat_message.dart';
import 'package:example/ui/chat_viewmodel.dart';

import '../utils/date_formatter.dart';
import '../utils/switch_appbar.dart';
import '../utils/chat_message_image.dart';

part 'chat_screen.g.dart';

class ChatScreenArgs {
  /// Pass the chat for an already existing chat
  final ChatWithMembers chat;

  ChatScreenArgs({required this.chat});
}

class ChatScreen extends StatefulWidget {
  final ChatScreenArgs args;

  ChatScreen(this.args);

  @override
  _ChatScreenSate createState() => _ChatScreenSate();
}

class _ChatScreenSate extends State<ChatScreen> with TickerProviderStateMixin {
  final ChatViewModel _model = ChatViewModel();

  final TextEditingController _textController = TextEditingController();

  /// The data controller
  final MessagesListController _controller = MessagesListController();

  /// Whether at least 1 message is selected
  int _selectedItemsCount = 0;

  /// Whether it's a group chat (more than 2 users)
  bool get _isGroupChat => widget.args.chat.members.length > 2;

  ChatWithMembers get _chat => widget.args.chat;

  ChatUser get _currentUser => _model.localUser;

  @override
  void initState() {
    _controller.addAll(_model.chatMessages[_chat.id] ?? []);

    _controller.selectionEventStream.listen((event) {
      setState(() {
        _selectedItemsCount = event.currentSelectionCount;
      });
    });

    super.initState();
  }

  /// Called when the user pressed the top right corner icon
  void onChatDetailsPressed() {
    print("Chat details pressed");
  }

  /// Called when a user tapped an item
  void onItemPressed(int index, MessageBase message) {
    print(
        "item pressed, you could display images in full screen or play videos with this callback");
  }

  void onMessageSend(String text) {
    _controller.insertAll(0, [
      ChatMessage(
          author: _currentUser,
          text: text,
          creationTimestamp: DateTime.now().millisecondsSinceEpoch)
    ]);
  }

  void onTypingEvent(TypingEvent event) {
    print("typing event received: $event");
  }

  /// Copy the selected comment's comment to the clipboard.
  /// Reset selection once copied.
  void copyContent() {
    String text = "";
    _controller.selectedItems.forEach((element) {
      text += element.text ?? "";
      text += '\n';
    });
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      print("text selected");
      _controller.unSelectAll();
    });
  }

  void deleteSelectedMessages() {
    _controller.removeSelectedItems();
    //update app bar
    setState(() {});
  }

  Widget _buildChatTitle() {
    if (_isGroupChat) {
      return Text(_chat.name);
    } else {
      final _user = _chat.membersWithoutSelf.first;
      return Row(children: [
        ClipOval(
            child: Image.asset(_user.avatar,
                width: 32, height: 32, fit: BoxFit.cover)),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(_user.username ?? "",
                    overflow: TextOverflow.ellipsis)))
      ]);
    }
  }

  Widget _buildMessageBody(
      context, index, item, messagePosition, MessageFlow messageFlow) {
    final _chatMessage = item as ChatMessage;
    Widget _child;

    if (_chatMessage.type == ChatMessageType.text) {
      _child = _ChatMessageText(index, item, messagePosition, messageFlow);
    } else if (_chatMessage.type == ChatMessageType.image) {
      _child = ChatMessageImage(index, item, messagePosition, messageFlow,
          callback: () => onItemPressed(index, item));
    } else if (_chatMessage.type == ChatMessageType.video) {
      _child = ChatMessageVideo(index, item, messagePosition, messageFlow);
    } else if (_chatMessage.type == ChatMessageType.audio) {
      _child = ChatMessageAudio(index, item, messagePosition, messageFlow);
    } else {
      //return text message as default
      _child = _ChatMessageText(index, item, messagePosition, messageFlow);
    }

    if (messageFlow == MessageFlow.incoming) return _child;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(alignment: Alignment.centerRight, child: _child));
  }

  Widget _buildDate(BuildContext context, DateTime date) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
                child: Text(
                    DateFormatter.getVerboseDateTimeRepresentation(
                        context, date),
                    style:
                        TextStyle(color: Theme.of(context).disabledColor)))));
  }

  Widget _buildEventMessage(context, animation, index, item, messagePosition) {
    final _chatMessage = item as ChatMessage;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
                child: Text(
              _chatMessage.messageText(_currentUser.id),
              style: TextStyle(color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ))));
  }

  Widget _buildMessagesList() {
    IncomingMessageTileBuilders incomingBuilders = _isGroupChat
        ? IncomingMessageTileBuilders(
            bodyBuilder: (context, index, item, messagePosition) =>
                _buildMessageBody(context, index, item, messagePosition,
                    MessageFlow.incoming),
            avatarBuilder: (context, index, item, messagePosition) {
              final _chatMessage = item as ChatMessage;
              return Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: ClipOval(
                      child: Image.asset(_chatMessage.author!.avatar,
                          width: 32, height: 32, fit: BoxFit.cover)));
            })
        : IncomingMessageTileBuilders(
            bodyBuilder: (context, index, item, messagePosition) =>
                _buildMessageBody(context, index, item, messagePosition,
                    MessageFlow.incoming),
            titleBuilder: null);

    return Expanded(
        child: MessagesList(
            controller: _controller,
            appUserId: _currentUser.id,
            useCustomTile: (i, item, pos) {
              final msg = item as ChatMessage;
              return msg.isTypeEvent;
            },
            messagePosition: _messagePosition,
            builders: MessageTileBuilders(
                customTileBuilder: _buildEventMessage,
                customDateBuilder: _buildDate,
                incomingMessageBuilders: incomingBuilders,
                outgoingMessageBuilders: OutgoingMessageTileBuilders(
                    bodyBuilder: (context, index, item, messagePosition) =>
                        _buildMessageBody(context, index, item, messagePosition,
                            MessageFlow.outgoing)))));
  }

  /// Override [MessagePosition] to return [MessagePosition.isolated] when
  /// our [ChatMessage] is an event
  MessagePosition _messagePosition(
      MessageBase? previousItem,
      MessageBase currentItem,
      MessageBase? nextItem,
      bool Function(MessageBase currentItem) shouldBuildDate) {
    ChatMessage? _previousItem = previousItem as ChatMessage?;
    final ChatMessage _currentItem = currentItem as ChatMessage;
    ChatMessage? _nextItem = nextItem as ChatMessage?;

    if (shouldBuildDate(_currentItem)) {
      _previousItem = null;
    }

    if (_nextItem?.isTypeEvent == true) _nextItem = null;
    if (_previousItem?.isTypeEvent == true) _previousItem = null;

    if (_previousItem?.author?.id == _currentItem.author?.id &&
        _nextItem?.author?.id == _currentItem.author?.id) {
      return MessagePosition.surrounded;
    } else if (_previousItem?.author?.id == _currentItem.author?.id &&
        _nextItem?.author?.id != _currentItem.author?.id) {
      return MessagePosition.surroundedTop;
    } else if (_previousItem?.author?.id != _currentItem.author?.id &&
        _nextItem?.author?.id == _currentItem.author?.id) {
      return MessagePosition.surroundedBot;
    } else {
      return MessagePosition.isolated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SwitchAppBar(
          showSwitch: _controller.isSelectionModeActive,
          switchLeadingCallback: () => _controller.unSelectAll(),
          primaryAppBar: AppBar(
            title: _buildChatTitle(),
            actions: [
              IconButton(
                  icon: Icon(Icons.more_vert), onPressed: onChatDetailsPressed)
            ],
          ),
          switchTitle: Text(_selectedItemsCount.toString(),
              style: TextStyle(color: Colors.black)),
          switchActions: [
            IconButton(
                icon: Icon(Icons.content_copy),
                color: Colors.black,
                onPressed: copyContent),
            IconButton(
                color: Colors.black,
                icon: Icon(Icons.delete),
                onPressed: deleteSelectedMessages),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessagesList(),
            MessageInput(
                textController: _textController,
                sendCallback: onMessageSend,
                typingCallback: onTypingEvent),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }
}

///************************************************ Functional widgets used in the screen ***************************************

@swidget
Widget _chatMessageText(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition, MessageFlow messageFlow) {
  return MessageContainer(
      decoration: messageDecoration(context,
          messagePosition: messagePosition, messageFlow: messageFlow),
      child: Wrap(runSpacing: 4.0, alignment: WrapAlignment.end, children: [
        Text(message.text ?? ""),
        ChatMessageFooter(index, message, messagePosition, messageFlow)
      ]));
}

@swidget
Widget chatMessageFooter(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition, MessageFlow messageFlow) {
  final Widget _date = _ChatMessageDate(index, message, messagePosition);
  return messageFlow == MessageFlow.incoming
      ? _date
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              _date,
            ]);
}

@swidget
Widget _chatMessageDate(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition) {
  final color =
      message.isTypeMedia ? Colors.white : Theme.of(context).disabledColor;
  return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Text(
          DateFormatter.getVerboseDateTimeRepresentation(
              context, message.createdAt,
              timeOnly: true),
          style: TextStyle(color: color)));
}
