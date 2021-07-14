// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_screen.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

///************************************************ Functional widgets used in the screen ***************************************
class _ChatMessageText extends StatelessWidget {
  ///************************************************ Functional widgets used in the screen ***************************************
  const _ChatMessageText(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key? key})
      : super(key: key);

  ///************************************************ Functional widgets used in the screen ***************************************
  final int index;

  ///************************************************ Functional widgets used in the screen ***************************************
  final ChatMessage message;

  ///************************************************ Functional widgets used in the screen ***************************************
  final MessagePosition messagePosition;

  ///************************************************ Functional widgets used in the screen ***************************************
  final MessageFlow messageFlow;

  @override
  Widget build(BuildContext _context) =>
      _chatMessageText(_context, index, message, messagePosition, messageFlow);
}

class ChatMessageFooter extends StatelessWidget {
  const ChatMessageFooter(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key? key})
      : super(key: key);

  final int index;

  final ChatMessage message;

  final MessagePosition messagePosition;

  final MessageFlow messageFlow;

  @override
  Widget build(BuildContext _context) =>
      chatMessageFooter(_context, index, message, messagePosition, messageFlow);
}

class _ChatMessageDate extends StatelessWidget {
  const _ChatMessageDate(this.index, this.message, this.messagePosition,
      {Key? key})
      : super(key: key);

  final int index;

  final ChatMessage message;

  final MessagePosition messagePosition;

  @override
  Widget build(BuildContext _context) =>
      _chatMessageDate(_context, index, message, messagePosition);
}
