import './user_base.dart';
import './message_base.dart';

/// The base class for your custom Chat model, which has to extend [ChatBase]
abstract class ChatBase {
  /// Id of your ChatMessage
  String get id;

  /// Name of your Chat, used to display as the chat title
  String get name;

  /// The members of this chat, as an extension of [UserBase]
  List<UserBase> get members;

  /// The chat's last message, used to display below the chat's title
  MessageBase? get lastMessage;

  /// The number of unread messages
  /// pass null or 0 if you don't plan on displaying it
  int? get unreadCount;

  /// Whether the status of this chat is "unread", e.g. the last message has not been read
  bool get isUnread => (unreadCount ?? 0) > 0;
}
