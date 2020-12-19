import 'package:flutter/material.dart';

enum AvatarBehaviour { alwaysTop, alwaysBottom }

class MessageStyle {
  /// Only used for incoming messages
  final AvatarBehaviour avatarBehaviour;

  /// Constrained width for the avatar, when displayed
  /// if an avatarBuilder is supplied but no avatar is built due to positioning,
  /// [avatarWidth] is also used to build an empty container to align all messages
  final double avatarWidth;

  /// The outer padding of each tile
  final EdgeInsets padding;

  /// The foreground color applied to the whole item when it is selected
  /// Defaults to Colors.white.withAlpha(50)
  final Color selectionColor;

  const MessageStyle(
      {this.padding = EdgeInsets.zero,
      this.avatarWidth = 48.0,
      this.selectionColor,
      this.avatarBehaviour = AvatarBehaviour.alwaysBottom});
}
