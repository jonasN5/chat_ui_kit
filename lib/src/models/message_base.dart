import 'package:chat_ui_kit/src/utils/enums.dart';

import './user_base.dart';

/// The base class for your custom ChatMessage model, which has to extend [MessageBase]
abstract class MessageBase {
  /// Id of your ChatMessage
  String get id;

  /// Actual text message.
  String? get text;

  /// Date at which the message has been created at
  DateTime get createdAt;

  /// The author of this message
  UserBase? get author;

  /// Helper method to check whether the message is from the app user
  bool isFromAppUser(String appUserId) => author?.id == appUserId;

  /// The type of message, which will determine which Widget has to be built
  MessageBaseType get messageType;

  /// The url to the attachment associated to the message
  String get url;
}
