import 'package:chat_ui_kit/src/models/message_base.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:chat_ui_kit/src/widgets/core/messages_list_tile.dart';
import 'package:chat_ui_kit/src/widgets/helpers/message_container.dart';
import 'package:flutter/material.dart';

/// A default Widget that can be used to display text
/// This is more an example to give you an idea how to structure your own Widget
class ChatMessageText extends StatelessWidget {
  const ChatMessageText(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key? key})
      : super(key: key);

  final int index;

  final MessageBase message;

  final MessagePosition? messagePosition;

  final MessageFlow messageFlow;

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        decoration: messageDecoration(context,
            messagePosition: messagePosition, messageFlow: messageFlow),
        child: Wrap(alignment: WrapAlignment.end, children: [
          Text(message.text ?? "", style: TextStyle(color: Colors.black)),
          MessageFooter(message)
        ]));
  }
}
