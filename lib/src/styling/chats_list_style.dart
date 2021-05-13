import 'package:flutter/material.dart';
import 'package:chat_ui_kit/src/widgets/core/chats_list.dart';

/// Styling and settings for [ChatsList].
class ChatsListStyle {
  /// [ScrollPhysics] parameter for the list of chats.
  /// Defaults to platform default.
  final ScrollPhysics? physics;

  /// [EdgeInsetsGeometry] parameter for the list of chats.
  final EdgeInsetsGeometry? padding;

  const ChatsListStyle({this.physics, this.padding});
}
