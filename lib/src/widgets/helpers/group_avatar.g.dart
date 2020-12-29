// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_avatar.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

/// Build a separator
class _BuildSeparator extends StatelessWidget {
  /// Build a separator
  const _BuildSeparator(this.style, {Key key, this.width = 0, this.height = 0})
      : super(key: key);

  /// Build a separator
  final GroupAvatarStyle style;

  /// Build a separator
  final double width;

  /// Build a separator
  final double height;

  @override
  Widget build(BuildContext _context) =>
      _buildSeparator(_context, style, width: width, height: height);
}

/// Build the group avatar itself
class _BuildGroupAvatar<T> extends StatelessWidget {
  /// Build the group avatar itself
  const _BuildGroupAvatar(this.style, this.items, this.builder, {Key key})
      : super(key: key);

  /// Build the group avatar itself
  final GroupAvatarStyle style;

  /// Build the group avatar itself
  final List<T> items;

  /// Build the group avatar itself
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  @override
  Widget build(BuildContext _context) =>
      _buildGroupAvatar<T>(_context, style, items, builder);
}

/// Helper
class _BuildAvatar<T> extends StatelessWidget {
  /// Helper
  const _BuildAvatar(this.items, this.builder, this.index, this.size, {Key key})
      : super(key: key);

  /// Helper
  final List<T> items;

  /// Helper
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  /// Helper
  final int index;

  /// Helper
  final Size size;

  @override
  Widget build(BuildContext _context) =>
      _buildAvatar<T>(_context, items, builder, index, size);
}
