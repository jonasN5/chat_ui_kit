// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_screen.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************


class _ChatMessageText extends StatelessWidget {
  const _ChatMessageText(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key key})
      : super(key: key);

  final int index;

  final ChatMessage message;

  final MessagePosition messagePosition;

  final MessageFlow messageFlow;

  @override
  Widget build(BuildContext _context) =>
      _chatMessageText(_context, index, message, messagePosition, messageFlow);
}

class ChatMessageFooter extends StatelessWidget {
  const ChatMessageFooter(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key key})
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
      {Key key})
      : super(key: key);

  final int index;

  final ChatMessage message;

  final MessagePosition messagePosition;

  @override
  Widget build(BuildContext _context) =>
      _chatMessageDate(_context, index, message, messagePosition);
}
