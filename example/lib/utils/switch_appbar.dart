import 'package:flutter/material.dart';

///helper class to show an item is selected, to use across the application
class SwitchAppBar extends StatelessWidget implements PreferredSizeWidget {
  SwitchAppBar(
      {this.primaryAppBar,
      this.switchAppBar,
      this.showSwitch = false,
      this.switchLeadingCallback,
      this.switchTitle,
      this.switchActions})
      : preferredSize = Size.fromHeight(showSwitch
            ? kToolbarHeight
            : primaryAppBar?.preferredSize.height ?? kToolbarHeight);

  final bool showSwitch;
  final PreferredSizeWidget? primaryAppBar;
  final PreferredSizeWidget? switchAppBar;
  final VoidCallback? switchLeadingCallback;
  final Widget? switchTitle;
  final List<Widget>? switchActions;

  @override
  Widget build(BuildContext context) {
    return showSwitch
        ? switchAppBar != null
            ? switchAppBar!
            : AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                leading: IconButton(
                  onPressed: switchLeadingCallback,
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
                title: switchTitle,
                actions: switchActions,
              )
        : primaryAppBar ?? AppBar();
  }

  @override
  final Size preferredSize;
}
