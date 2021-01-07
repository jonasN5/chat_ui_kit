import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'group_avatar.g.dart';

/// Builder called to construct the Image widget
/// [imageIndex] is the position of the image inside the [GroupAvatar] as follows:
///
///   index 0 || index 1
///   ----------------
///   index 2 || index 3
///
/// Use [size] to determine the size of the image you should load
typedef GroupAvatarWidgetBuilder<T> = Widget Function(
    BuildContext context, int imageIndex, Size size, List<T> items);

enum GroupAvatarShape { circle, rectangle }

class GroupAvatarStyle {
  /// The shape of your GroupAvatar;
  /// When passing [GroupAvatarShape.rectangle], you can also specify [borderRadius]
  final GroupAvatarShape shape;

  /// The [Radius] when [shape] == [GroupAvatarShape.rectangle]
  /// Ignored if [shape] == [GroupAvatarShape.circle]
  final double borderRadius;

  /// Set to true if you wish to display a separator between avatars
  final bool withSeparator;

  /// If [withSeparator] == false
  final Color separatorColor;

  /// Ignore if [withSeparator] == false
  final double separatorThickness;

  /// The size of this widget
  final double size;

  const GroupAvatarStyle({this.size = 56.0,
    this.shape = GroupAvatarShape.rectangle,
    this.borderRadius = 20.0,
    this.withSeparator = false,
    this.separatorColor,
    this.separatorThickness = 1.5});
}

/// A widget the display multiple avatars inside a single widget
class GroupAvatar<T> extends StatelessWidget {
  GroupAvatar({Key key,
    @required this.items,
    @required this.builder,
    GroupAvatarStyle style})
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
    final child = SizedBox(
        width: style.size,
        height: style.size,
        child: _BuildGroupAvatar(style, items, builder));

    return style.shape == GroupAvatarShape.circle
        ? ClipOval(clipBehavior: Clip.antiAlias, child: child)
        : ClipRRect(
        child: child,
        clipBehavior: Clip.antiAlias,
        borderRadius:
        BorderRadius.all(Radius.circular(style.borderRadius)));
  }
}

/// Build a separator
@swidget
Widget _buildSeparator(BuildContext context, GroupAvatarStyle style,
    {double width = 0, double height = 0}) {
  return Container(
      width: width,
      height: height,
      color: style.separatorColor ?? Theme
          .of(context)
          .backgroundColor);
}

/// Build the group avatar itself
@swidget
Widget _buildGroupAvatar<T>(BuildContext context, GroupAvatarStyle style,
    List<T> items, GroupAvatarWidgetBuilder builder) {
  if (items.length == 1)
    return builder.call(context, 0, Size(style.size, style.size), items);
  final separatorSize = style.withSeparator ? style.separatorThickness : 0;
  if (items.length == 2) {
    final _size = Size((style.size - separatorSize) / 2, style.size);
    return Row(
      children: [
        _BuildAvatar(items, builder, 0, _size),
        if (style.withSeparator)
          _BuildSeparator(style,
              width: style.separatorThickness, height: style.size),
        _BuildAvatar(items, builder, 1, _size)
      ],
    );
  }
  if (items.length == 3) {
    return Row(
      children: [
        _BuildAvatar(items, builder, 0,
            Size((style.size - separatorSize) / 2, style.size)),
        if (style.withSeparator)
          _BuildSeparator(style,
              width: style.separatorThickness, height: style.size),
        Column(
          children: [
            _BuildAvatar(
                items,
                builder,
                1,
                Size((style.size - separatorSize) / 2,
                    (style.size - separatorSize) / 2)),
            if (style.withSeparator)
              _BuildSeparator(style,
                  width: (style.size - separatorSize) / 2,
                  height: style.separatorThickness),
            _BuildAvatar(
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
          _BuildAvatar(items, builder, 0, _size),
          if (style.withSeparator)
            _BuildSeparator(style,
                width: style.separatorThickness, height: _size.height),
          _BuildAvatar(items, builder, 1, _size)
        ],
      ),
      if (style.withSeparator)
        _BuildSeparator(style,
            width: style.size, height: style.separatorThickness),
      Row(
        children: [
          _BuildAvatar(items, builder, 2, _size),
          if (style.withSeparator)
            _BuildSeparator(style,
                width: style.separatorThickness, height: _size.height),
          _BuildAvatar(items, builder, 3, _size)
        ],
      )
    ],
  );
}

/// Helper
@swidget
Widget _buildAvatar<T>(BuildContext context, List<T> items,
    GroupAvatarWidgetBuilder builder, int index, Size size) {
  return Expanded(child: builder.call(context, index, size, items));
}
