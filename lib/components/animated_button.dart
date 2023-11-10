import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    this.onPressed,
    this.behavior = HitTestBehavior.deferToChild,
    this.scale = 0.8,
    required this.child,
  });

  final double scale;

  final Widget child;
  final void Function()? onPressed;
  final HitTestBehavior behavior;

  @override
  State<StatefulWidget> createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  bool down = false;

  void _onTapDown(TapDownDetails _) {
    setState(() {
      down = true;
    });
  }

  void _onTap() {
    widget.onPressed?.call();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() {
      down = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      down = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onTapDown,
      onTap: _onTap,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: down ? widget.scale : 1,
        duration: Duration(milliseconds: down ? 100 : 1000),
        alignment: Alignment.center,
        curve: down ? Curves.linear : Curves.elasticOut,
        child: widget.child,
      ),
    );
  }
}
