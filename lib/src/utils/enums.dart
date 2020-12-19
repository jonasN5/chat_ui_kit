import 'package:chat_ui_kit/src/models/message_base.dart';
import 'package:chat_ui_kit/src/utils/selection_event.dart';
import 'package:chat_ui_kit/src/widgets/core/message_input.dart';

/// Represents the position of a [MessageBase] relative to others
enum MessagePosition {
  /// The previous and next messages are either non existent or from another user
  isolated,

  /// The previous message is from the same user and
  /// the next message is either non existent or from another user
  surroundedTop,

  /// The previous message is either non existent or from another user and
  /// the next message is from the same user
  surroundedBot,

  /// The previous and next messages exist and are from the same user
  surrounded
}

/// Determines the flow of the message;
/// [incoming] == a message from another user
/// [outgoing] == a message from the app user
enum MessageFlow { incoming, outgoing }

/// The type of selection passed in [SelectionEvent]
enum SelectionType { select, unSelect }

/// The type of the [MessageBase], see [MessageBase.messageType]
enum MessageBaseType { text, image, audio, video, other }

/// An event called by [MessageInputTypingHandler] when the user starts or stop typing
enum TypingEvent { start, stop }
