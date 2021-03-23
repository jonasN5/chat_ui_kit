import 'package:chat_ui_kit/src/utils/colors.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:flutter/material.dart';

class MessageContainerStyle {}

class MessageContainer extends StatelessWidget {
  final Widget child;

  final EdgeInsets padding;

  final BoxDecoration? decoration;

  final BoxConstraints? constraints;

  MessageContainer(
      {required this.child,
      this.padding = const EdgeInsets.all(8),
      this.decoration,
      this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        constraints: constraints ??
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: padding,
        decoration: decoration ?? messageDecoration(context),
        child: child);
  }
}

BoxDecoration messageDecoration(BuildContext context,
    {Color? color,
    double radius = 8.0,
    double tightRadius = 0.0,
    MessagePosition? messagePosition = MessagePosition.isolated,
    MessageFlow messageFlow = MessageFlow.outgoing}) {
  double topLeftRadius;
  double topRightRadius;
  double botLeftRadius;
  double botRightRadius;

  final bool isTopSurrounded = messagePosition == MessagePosition.surrounded ||
      messagePosition == MessagePosition.surroundedTop;
  if (messageFlow == MessageFlow.outgoing) {
    botLeftRadius = radius;
    botRightRadius = 0;
    topLeftRadius = radius;
    topRightRadius = isTopSurrounded ? tightRadius : radius;
  } else {
    botLeftRadius = 0;
    botRightRadius = radius;
    topLeftRadius = isTopSurrounded ? tightRadius : radius;
    topRightRadius = radius;
  }

  return BoxDecoration(
      color: color ??
          (messageFlow == MessageFlow.outgoing
              ? Theme.of(context).primaryColor
              : CustomColors.incomingMessageContainerColor(context)),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
          bottomLeft: Radius.circular(botLeftRadius),
          bottomRight: Radius.circular(botRightRadius)));
}
