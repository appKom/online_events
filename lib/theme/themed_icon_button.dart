import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'themed_icon.dart';

class ThemedIconButton extends StatefulWidget {
  const ThemedIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.size,
    required this.color,
    this.hoverColor,
  });

  final void Function()? onPressed;

  final IconType icon;
  final double size;

  final Color color;
  final Color? hoverColor;

  @override
  State<StatefulWidget> createState() => ThemedIconButtonState();
}

class ThemedIconButtonState extends State<ThemedIconButton> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  void onEnter(PointerEnterEvent _) {
    setState(() {
      color = widget.hoverColor ?? widget.color;
    });
  }

  void onExit(PointerExitEvent _) {
    setState(() {
      color = widget.color;
    });
  }

  void onTapDown(TapDownDetails _) {
    setState(() {
      color = widget.hoverColor ?? widget.color;
    });
  }

  void onTapUp(TapUpDetails _) {
    setState(() {
      color = widget.color;
    });
  }

  void onTapCancel() {
    setState(() {
      color = widget.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      hitTestBehavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: ThemedIcon(
            icon: widget.icon,
            color: color,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
