// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_avatar.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

/// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************
/// Build the stacked group avatar itself
class _BuildStackedGroupAvatar<T> extends StatelessWidget {
  /// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************
  /// Build the stacked group avatar itself
  const _BuildStackedGroupAvatar(this.style, this.items, this.builder,
      {Key? key})
      : super(key: key);

  /// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************
  /// Build the stacked group avatar itself
  final GroupAvatarStyle style;

  /// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************
  /// Build the stacked group avatar itself
  final List<T> items;

  /// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************
  /// Build the stacked group avatar itself
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  @override
  Widget build(BuildContext _context) =>
      _buildStackedGroupAvatar<T>(_context, style, items, builder);
}

/// Helper
class _BuildStackedAvatar<T> extends StatelessWidget {
  /// Helper
  const _BuildStackedAvatar(
      this.items, this.builder, this.index, this.size, this.border,
      {Key? key})
      : super(key: key);

  /// Helper
  final List<T> items;

  /// Helper
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  /// Helper
  final int index;

  /// Helper
  final double size;

  /// Helper
  final Border? border;

  @override
  Widget build(BuildContext _context) =>
      _buildStackedAvatar<T>(_context, items, builder, index, size, border);
}

/// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************
/// Build a separator
class _BuildSeparator extends StatelessWidget {
  /// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************
  /// Build a separator
  const _BuildSeparator(this.style, {Key? key, this.width = 0, this.height = 0})
      : super(key: key);

  /// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************
  /// Build a separator
  final GroupAvatarStyle style;

  /// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************
  /// Build a separator
  final double width;

  /// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************
  /// Build a separator
  final double height;

  @override
  Widget build(BuildContext _context) =>
      _buildSeparator(_context, style, width: width, height: height);
}

/// Build the aligned group avatar itself
class _BuildAlignedGroupAvatar<T> extends StatelessWidget {
  /// Build the aligned group avatar itself
  const _BuildAlignedGroupAvatar(this.style, this.items, this.builder,
      {Key? key})
      : super(key: key);

  /// Build the aligned group avatar itself
  final GroupAvatarStyle style;

  /// Build the aligned group avatar itself
  final List<T> items;

  /// Build the aligned group avatar itself
  final Widget Function(BuildContext, int, Size, List<dynamic>) builder;

  @override
  Widget build(BuildContext _context) =>
      _buildAlignedGroupAvatar<T>(_context, style, items, builder);
}

/// Helper
class _BuildAlignedAvatar<T> extends StatelessWidget {
  /// Helper
  const _BuildAlignedAvatar(this.items, this.builder, this.index, this.size,
      {Key? key})
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
      _buildAlignedAvatar<T>(_context, items, builder, index, size);
}
