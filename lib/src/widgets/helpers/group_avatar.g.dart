// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_avatar.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

///build a separator
class _BuildSeparator extends StatelessWidget {
  ///build a separator
  const _BuildSeparator(this.style, {Key key, this.width = 0, this.height = 0})
      : super(key: key);

  ///build a separator
  final GroupAvatarStyle style;

  ///build a separator
  final double width;

  ///build a separator
  final double height;

  @override
  Widget build(BuildContext _context) =>
      _buildSeparator(_context, style, width: width, height: height);
}

///build the group avatar itself
class _BuildGroupAvatar<T> extends StatelessWidget {
  ///build the group avatar itself
  const _BuildGroupAvatar(this.style, this.items, this.builder, {Key key})
      : super(key: key);

  ///build the group avatar itself
  final GroupAvatarStyle style;

  ///build the group avatar itself
  final List<T> items;

  ///build the group avatar itself
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  @override
  Widget build(BuildContext _context) =>
      _buildGroupAvatar<T>(_context, style, items, builder);
}

///helper
class _BuildAvatar<T> extends StatelessWidget {
  ///helper
  const _BuildAvatar(this.items, this.builder, this.index, this.size, {Key key})
      : super(key: key);

  ///helper
  final List<T> items;

  ///helper
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  ///helper
  final int index;

  ///helper
  final Size size;

  @override
  Widget build(BuildContext _context) =>
      _buildAvatar<T>(_context, items, builder, index, size);
}
