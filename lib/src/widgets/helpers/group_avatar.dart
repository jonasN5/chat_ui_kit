import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'group_avatar.g.dart';

/// Builder called to construct the Image widget.
/// [imageIndex] is the position of the image inside the [GroupAvatar] as follows:
///
///   index 0 || index 1
///   ----------------
///   index 2 || index 3
///
/// Use [size] to determine the size of the image you should load.
typedef GroupAvatarWidgetBuilder<T> = Widget Function(
    BuildContext context, int imageIndex, Size size, List<T?> items);

enum GroupAvatarShape { circle, rectangle }

enum GroupAvatarMode {
  /// Display up to 4 images, aligned in Rows & Columns.
  aligned,

  /// Display up to 4 images, stacked on each other as circles.
  stackedCircles
}

class GroupAvatarStyle {
  /// The mode of your GroupAvatar. See [GroupAvatarMode].
  final GroupAvatarMode mode;

  /// Only used with [mode] == [GroupAvatarMode.stackedCircles].
  /// Determines the size of each individual image, compared to the widget size.
  /// The list must have 4 values. Index 0 will be if the [GroupAvatar] only has 1 image.
  /// Index 1 for 2 images. Index 3 for 3 images. Index 4 for 4 images or more.
  /// The default is [1.0, 1.25, 1.4, 1.5], 1.0 resulting in [size] and 1.5 resulting in [size]/1.5.
  final List<double> stackedReductionFactor;

  /// The border for each loaded image. Only used with [mode] == [GroupAvatarMode.stackedCircles].
  /// Usually you will want to pass something like this:
  /// Border.all(color: Theme.of(context).backgroundColor, width: 2.0).
  /// Default is no border.
  final Border? stackedBorder;

  /// The shape of your GroupAvatar;
  /// When passing [GroupAvatarShape.rectangle], you can also specify [borderRadius]
  final GroupAvatarShape shape;

  /// The [Radius] when [shape] == [GroupAvatarShape.rectangle].
  /// Ignored if [shape] == [GroupAvatarShape.circle].
  final double borderRadius;

  /// Set to true if you wish to display a separator between avatars.
  final bool withSeparator;

  /// Ignored if [withSeparator] == false.
  final Color? separatorColor;

  /// Ignored if [withSeparator] == false.
  final double separatorThickness;

  /// The size of this widget.
  final double size;

  const GroupAvatarStyle(
      {this.size = 56.0,
      this.mode = GroupAvatarMode.aligned,
      this.stackedReductionFactor = const [1.0, 1.25, 1.4, 1.5],
      this.stackedBorder,
      this.shape = GroupAvatarShape.rectangle,
      this.borderRadius = 20.0,
      this.withSeparator = false,
      this.separatorColor,
      this.separatorThickness = 1.5})
      : assert(
            stackedReductionFactor.length == 4, "The list must have 4 values");
}

/// A widget the display multiple avatars inside a single widget
class GroupAvatar<T> extends StatelessWidget {
  GroupAvatar(
      {Key? key,
      required this.items,
      required this.builder,
      GroupAvatarStyle? style})
      : style = style ?? GroupAvatarStyle(),
        super(key: key);

  /// The items, typically a List of Users [IUser]
  final List<T> items;

  /// This builder will be called every time an image needs to be loaded;
  /// It is your image loader
  final GroupAvatarWidgetBuilder builder;

  /// The style configuration for the widget
  final GroupAvatarStyle style;

  @override
  Widget build(BuildContext context) {
    if (style.mode == GroupAvatarMode.stackedCircles) {
      return SizedBox(
          width: style.size,
          height: style.size,
          child: _BuildStackedGroupAvatar(style, items, builder));
    } else {
      final child = SizedBox(
          width: style.size,
          height: style.size,
          child: _BuildAlignedGroupAvatar(style, items, builder));

      return style.shape == GroupAvatarShape.circle
          ? ClipOval(clipBehavior: Clip.antiAlias, child: child)
          : ClipRRect(
              child: child,
              clipBehavior: Clip.antiAlias,
              borderRadius:
                  BorderRadius.all(Radius.circular(style.borderRadius)));
    }
  }
}

/// ***************************************************************** For GroupAvatarMode.stacked ************************************************************************

/// Build the stacked group avatar itself
@swidget
Widget _buildStackedGroupAvatar<T>(BuildContext context, GroupAvatarStyle style,
    List<T> items, GroupAvatarWidgetBuilder builder) {
  final border = style.stackedBorder;

  if (items.length == 1)
    return _BuildStackedAvatar(items, builder, 0,
        style.size / style.stackedReductionFactor[0], border);

  if (items.length == 2) {
    final _size = style.size / style.stackedReductionFactor[1];
    return Stack(
      children: [
        _BuildStackedAvatar(items, builder, 0, _size, border),
        Positioned(
            bottom: 0,
            right: 0,
            child: _BuildStackedAvatar(items, builder, 1, _size, border))
      ],
    );
  }
  if (items.length == 3) {
    final _size = style.size / style.stackedReductionFactor[2];
    final remainingSpace = style.size - _size;
    return Stack(
      children: [
        _BuildStackedAvatar(items, builder, 0, _size, border),
        Positioned(
            top: remainingSpace / 3,
            right: 0,
            child: _BuildStackedAvatar(items, builder, 1, _size, border)),
        Positioned(
            left: remainingSpace / 3,
            bottom: 0,
            child: _BuildStackedAvatar(items, builder, 2, _size, border))
      ],
    );
  }

  //4 or more
  final _size = style.size / style.stackedReductionFactor[3];
  return Stack(
    children: [
      _BuildStackedAvatar(items, builder, 0, _size, border),
      Positioned(
          top: 0,
          right: 0,
          child: _BuildStackedAvatar(items, builder, 1, _size, border)),
      Positioned(
          bottom: 0,
          child: _BuildStackedAvatar(items, builder, 2, _size, border)),
      Positioned(
          bottom: 0,
          right: 0,
          child: _BuildStackedAvatar(items, builder, 3, _size, border))
    ],
  );
}

/// Helper
@swidget
Widget _buildStackedAvatar<T>(BuildContext context, List<T> items,
    GroupAvatarWidgetBuilder builder, int index, double size, Border? border) {
  return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          color: Theme.of(context).backgroundColor),
      child: ClipOval(
          child: builder.call(context, index, Size(size, size), items)));
}

/// ***************************************************************** For GroupAvatarMode.aligned ************************************************************************

/// Build a separator
@swidget
Widget _buildSeparator(BuildContext context, GroupAvatarStyle style,
    {double width = 0, double height = 0}) {
  return Container(
      width: width,
      height: height,
      color: style.separatorColor ?? Theme.of(context).backgroundColor);
}

/// Build the aligned group avatar itself
@swidget
Widget _buildAlignedGroupAvatar<T>(BuildContext context, GroupAvatarStyle style,
    List<T> items, GroupAvatarWidgetBuilder builder) {
  if (items.length == 1)
    return builder.call(context, 0, Size(style.size, style.size), items);
  final separatorSize = style.withSeparator ? style.separatorThickness : 0;
  if (items.length == 2) {
    final _size = Size((style.size - separatorSize) / 2, style.size);
    return Row(
      children: [
        _BuildAlignedAvatar(items, builder, 0, _size),
        if (style.withSeparator)
          _BuildSeparator(style,
              width: style.separatorThickness, height: style.size),
        _BuildAlignedAvatar(items, builder, 1, _size)
      ],
    );
  }
  if (items.length == 3) {
    return Row(
      children: [
        _BuildAlignedAvatar(items, builder, 0,
            Size((style.size - separatorSize) / 2, style.size)),
        if (style.withSeparator)
          _BuildSeparator(style,
              width: style.separatorThickness, height: style.size),
        Column(
          children: [
            _BuildAlignedAvatar(
                items,
                builder,
                1,
                Size((style.size - separatorSize) / 2,
                    (style.size - separatorSize) / 2)),
            if (style.withSeparator)
              _BuildSeparator(style,
                  width: (style.size - separatorSize) / 2,
                  height: style.separatorThickness),
            _BuildAlignedAvatar(
                items,
                builder,
                2,
                Size((style.size - separatorSize) / 2,
                    (style.size - separatorSize) / 2))
          ],
        )
      ],
    );
  }
  //4 or more
  final Size _size =
      Size((style.size - separatorSize) / 2, (style.size - separatorSize) / 2);
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          _BuildAlignedAvatar(items, builder, 0, _size),
          if (style.withSeparator)
            _BuildSeparator(style,
                width: style.separatorThickness, height: _size.height),
          _BuildAlignedAvatar(items, builder, 1, _size)
        ],
      ),
      if (style.withSeparator)
        _BuildSeparator(style,
            width: style.size, height: style.separatorThickness),
      Row(
        children: [
          _BuildAlignedAvatar(items, builder, 2, _size),
          if (style.withSeparator)
            _BuildSeparator(style,
                width: style.separatorThickness, height: _size.height),
          _BuildAlignedAvatar(items, builder, 3, _size)
        ],
      )
    ],
  );
}

/// Helper
@swidget
Widget _buildAlignedAvatar<T>(BuildContext context, List<T> items,
    GroupAvatarWidgetBuilder builder, int index, Size size) {
  return Expanded(child: builder.call(context, index, size, items));
}
